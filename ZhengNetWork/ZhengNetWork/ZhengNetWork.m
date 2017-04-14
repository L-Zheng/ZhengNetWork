//
//  ZhengNetWork.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengNetWork.h"
#import "ZhengNetWork+Error.h"
#import "ZhengCacheTool.h"
#import "ZhengParseTool.h"

@implementation ZhengNetWork

#pragma mark - Public func

#pragma mark - Request
/** 发送请求 */
+ (void)sendRequest:(ZhengRequest *)zhengRequest success:(void (^)(id responseObject ,id modelObject))success failure:(void (^)(NSError *error))failure{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengRequest];
    if (myError) {
        if (failure) {
            failure(myError);
        }
        return;
    }
    
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    zhengRequest.sessionManager = manager;
    
    manager.requestSerializer = manager.requestSerializer ? manager.requestSerializer : [AFJSONRequestSerializer serializer];
    //设置请求头
//    @{@"Content-Type":@"application/json"}
    NSDictionary *header = zhengRequest.header;
    if (header) {
        NSArray *keysArray = header.allKeys;
        for (NSString *key in keysArray) {
            if ([header[key] isKindOfClass:[NSString class]]) {
                [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
            }
        }
    }
    
    //设置请求超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = zhengRequest.timeOut.doubleValue;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    manager.responseSerializer = manager.responseSerializer ? manager.responseSerializer : [AFJSONResponseSerializer serializer];
    //设置ContentType
//    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    manager.responseSerializer.acceptableContentTypes = [[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"] setByAddingObject:@"text/plain"];
    
    //发送请求
    switch (zhengRequest.requestType) {
        case RequestType_Get:
            [ZhengNetWork getRequest:zhengRequest success:success failure:failure];
            break;
            
        case RequestType_Post:
            [ZhengNetWork postRequest:zhengRequest success:success failure:failure];
            break;
            
        default:
            return;
            break;
    }
}

/** 读取缓存 */
+ (void)readCacheRequest:(ZhengRequest *)zhengRequest cache:(void (^)(id responseObject ,id modelObject))cache failure:(void (^)(NSError *error))failure{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengRequest];
    if (myError) {
        if (failure) {
            failure(myError);
        }
        return;
    }
    
    id cacheData = [ZhengCacheTool readData:zhengRequest];
    
    [ZhengNetWork callBackCache:zhengRequest cacheData:cacheData cache:cache];
}

#pragma mark - download

/** 非断点下载  下载文件临时存放目录和目标目录不同 */
+ (void)downLoadFileRequst:(ZhengDownloadRequest *)zhengDownloadRequest
              progress:(void (^)(NSProgress *downloadProgress))downloadProgress
           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
     completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengDownloadRequest];
    if (myError) {
        if (completionHandler) {
            completionHandler(nil,nil,myError);
        }
        return;
    }
    
    NSString *urlStr = zhengDownloadRequest.urlStr;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    manager.securityPolicy.allowInvalidCertificates = YES;
    
    zhengDownloadRequest.sessionManager = manager;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgress destination:destination completionHandler:completionHandler];
    
    zhengDownloadRequest.currentTask = downloadTask;
    
    [downloadTask resume];
}

/** 断点下载  下载文件临时存放目录和目标目录相同 */
+ (void)downLoadFileBRRequst:(ZhengBRDownloadRequest *)zhengBRDownloadRequest
                    progress:(void (^)(NSProgress *downloadProgress))downloadProgress
           completionHandler:(void (^)(NSURLResponse * response, id responseObject, NSError * error))completionHandler{
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengBRDownloadRequest];
    if (myError) {
        if (completionHandler) {
            completionHandler(nil,nil,myError);
        }
        return;
    }
    
    NSString *urlStr = zhengBRDownloadRequest.urlStr;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    
    zhengBRDownloadRequest.sessionManager = manager;
    
    //读取已下载的长度
    zhengBRDownloadRequest.currentLength = [ZhengCacheDirectory readFileSize:zhengBRDownloadRequest.targetPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    // 设置HTTP请求头中的Range
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", zhengBRDownloadRequest.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    //创建数据任务
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        // 清空长度
        zhengBRDownloadRequest.currentLength = 0;
        zhengBRDownloadRequest.fileLength = 0;
        // 关闭fileHandle
        [zhengBRDownloadRequest.fileHandle closeFile];
        zhengBRDownloadRequest.fileHandle = nil;
        
        if (completionHandler) {
            completionHandler(response,responseObject,error);
        }
    }];
    zhengBRDownloadRequest.currentTask = downloadTask;
    
    //设置接受响应
    [manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        zhengBRDownloadRequest.fileLength = response.expectedContentLength + zhengBRDownloadRequest.currentLength;
        
        // 沙盒文件路径
//        [response suggestedFilename]
        NSString *targetPath = zhengBRDownloadRequest.targetPath;
        
        // 创建一个空的文件到沙盒中
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:targetPath]) {
            // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
            [fileManager createFileAtPath:targetPath contents:nil attributes:nil];
        }
        
        // 创建文件句柄
        zhengBRDownloadRequest.fileHandle = [NSFileHandle fileHandleForWritingAtPath:targetPath];
        
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    
    //设置接收数据
    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        // 指定数据的写入位置 -- 文件内容的最后面
        [zhengBRDownloadRequest.fileHandle seekToEndOfFile];
        
        // 向沙盒写入数据
        [zhengBRDownloadRequest.fileHandle writeData:data];
        
        // 拼接文件总长度
        zhengBRDownloadRequest.currentLength += data.length;
        
        // 进度回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (downloadProgress) {
                NSProgress *progress = [[NSProgress alloc] init];
                progress.totalUnitCount = zhengBRDownloadRequest.fileLength;
                progress.completedUnitCount = zhengBRDownloadRequest.currentLength;
                downloadProgress(progress);
            }
        });
    }];
    
    [downloadTask resume];
}

#pragma mark - upload

/** 普通上传任务 */
+ (void)upLoadRequst:(ZhengUploadRequest *)zhengUploadRequest
            progress:(void (^)(NSProgress *uploadProgress))uploadProgress
   completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengUploadRequest];
    if (myError) {
        if (completionHandler) {
            completionHandler(nil,nil,myError);
        }
        return;
    }
    
    NSString *urlStr = zhengUploadRequest.urlStr;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    
    zhengUploadRequest.sessionManager = manager;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    NSURL *filePath = [NSURL fileURLWithPath:zhengUploadRequest.upLoadFilePath];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:uploadProgress completionHandler:completionHandler];
    
    zhengUploadRequest.currentTask = uploadTask;
    
    [uploadTask resume];
}

/** 上传图片请求 */
+ (void)upLoadImageRequst:(ZhengImageUploadRequest *)zhengImageUploadRequest
                 progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengImageUploadRequest];
    if (myError) {
        if (failure) {
            failure(myError);
        }
        return;
    }
    
    NSString *urlStr = zhengImageUploadRequest.urlStr;
    NSDictionary *parameters = zhengImageUploadRequest.parameters;
    NSArray *imageArray = zhengImageUploadRequest.imageArray;
    NSString *mimeType = zhengImageUploadRequest.mimeType;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < imageArray.count; i ++) {
            UIImage *image = [imageArray objectAtIndex:i];
            NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"image%ld",(long)i] fileName:@"image.png" mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull progress) {
        if (uploadProgress) {
            uploadProgress(progress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** 上传文件请求 */
+ (void)upLoadFileRequst:(ZhengFileUploadRequest *)zhengFileUploadRequest
                progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                 success:(void (^)(id responseObject))success
                 failure:(void (^)(NSError *error))failure{
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengFileUploadRequest];
    if (myError) {
        if (failure) {
            failure(myError);
        }
        return;
    }
    
    NSString *urlStr = zhengFileUploadRequest.urlStr;
    NSDictionary *parameters = zhengFileUploadRequest.parameters;
    NSString *filePath = zhengFileUploadRequest.upLoadFilePath;
    NSString *mimeType = zhengFileUploadRequest.mimeType;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"write you want to writre" fileName:@"Files" mimeType:mimeType error:nil];
        
    } progress:^(NSProgress * _Nonnull progress) {
        if (uploadProgress) {
            uploadProgress(progress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

/** 上传多请求（多文件） */
+ (void)upLoadMultiRequst:(ZhengMultiUploadRequest *)zhengMultiUploadRequest
           multiprogress:(void (^)(NSProgress *uploadProgress))uploadMultiProgress
       completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler{
    
    //检查Request
    NSError *myError = [ZhengNetWork checkRequest:zhengMultiUploadRequest];
    if (myError) {
        if (completionHandler) {
            completionHandler(nil,nil,myError);
        }
        return;
    }
    
    NSString *urlStr = zhengMultiUploadRequest.urlStr;
    
    NSString *upLoadFilePath = zhengMultiUploadRequest.upLoadFilePath;
    NSString *fileName = zhengMultiUploadRequest.fileName;
    NSDictionary *parameters = zhengMultiUploadRequest.parameters;
    NSString *mimeType = zhengMultiUploadRequest.mimeType;
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:upLoadFilePath] name:@"file" fileName:fileName mimeType:mimeType error:nil];
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    zhengMultiUploadRequest.sessionManager = manager;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:uploadMultiProgress completionHandler:completionHandler];
    
    zhengMultiUploadRequest.currentTask = uploadTask;
    
    [uploadTask resume];
}

#pragma mark - Private func

#pragma mark - Request func

+ (void)getRequest:(ZhengRequest *)zhengRequest success:(void (^)(id responseObject ,id modelObject))success failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parameters = zhengRequest.parameters;
    NSString *urlStr = zhengRequest.urlStr;
    
    zhengRequest.requestStatus = RequestStatus_Running;
    
    [zhengRequest.sessionManager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZhengNetWork callBackSuccess:zhengRequest responseObject:responseObject success:success];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZhengNetWork callBackFailure:zhengRequest error:error failure:failure];
        });
        
    }];
}

+ (void)postRequest:(ZhengRequest *)zhengRequest success:(void (^)(id responseObject ,id modelObject))success failure:(void (^)(NSError *error))failure{
    
    NSDictionary *parameters = zhengRequest.parameters;
    NSString *urlStr = zhengRequest.urlStr;
    
    zhengRequest.requestStatus = RequestStatus_Running;
    
    [zhengRequest.sessionManager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZhengNetWork callBackSuccess:zhengRequest responseObject:responseObject success:success];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ZhengNetWork callBackFailure:zhengRequest error:error failure:failure];
        });
        
    }];
}

#pragma mark - CallBack func

+ (void)callBackSuccess:(ZhengRequest *)zhengRequest responseObject:(id _Nullable)responseObject success:(void (^)(id responseObject ,id modelObject))success{
    
    if (zhengRequest.requestStatus == RequestStatus_Running) {
        zhengRequest.requestStatus = RequestStatus_Success;
        if (success) {
            //分页数据处理
            id cacheData = nil;
            if (zhengRequest.needJsonField) {
                NSDictionary *jsonDic = (NSDictionary *)responseObject;
                cacheData = [jsonDic valueForKey:zhengRequest.needJsonField];
            } else {
                cacheData = responseObject;
            }
            //转模型
            id modelObject = nil;
            if (zhengRequest.className) {
                modelObject = [ZhengParseTool sourceData:cacheData toModel:zhengRequest.className];
            }
            //回调
            success(responseObject,modelObject);
            //缓存
            [ZhengCacheTool cacheData:cacheData zhengRequest:zhengRequest];
        }
    }
}

+ (void)callBackCache:(ZhengRequest *)zhengRequest cacheData:(id _Nullable)cacheData cache:(void (^)(id responseObject ,id modelObject))cache{
    if (cache) {
        zhengRequest.requestStatus = RequestStatus_Cache;
        //转模型
        id modelObject = nil;
        if (zhengRequest.className) {
            modelObject = [ZhengParseTool sourceData:cacheData toModel:zhengRequest.className];
        }
        //回调
        cache(cacheData,modelObject);
    }
}

+ (void)callBackFailure:(ZhengRequest *)zhengRequest error:(NSError * _Nonnull)error failure:(void (^)(NSError *error))failure{
    
    if (zhengRequest.requestStatus == RequestStatus_Running) {
        zhengRequest.requestStatus = RequestStatus_Fail;
        if (failure) {
            failure(error);
        }
    }
}

@end
