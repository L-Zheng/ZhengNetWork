//
//  ViewController.m
//  AFN封装使用
//
//  Created by 李保征 on 16/7/12.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ViewController.h"

#import "ZhengNetworkHeader.h"


#import "MJExtension.h"
#import "JsonDicModel.h"
#import "JsonArrayModel.h"
#import "PageModel.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//        [self requestJsonDicDataNoCache];
    //    [self requestListPageDataNoCache];
    
//    [self requestJsonDicDataCache];
//            [self requestListPageDataCache];
    
//    [self downloadFile];
    
//    [self downloadBRFile];
    
//    [self uploadFile];
}

- (void)requestJsonDicDataNoCache{
    ZhengRequest *zhengRequest = [[ZhengRequest alloc] init];
//    zhengRequest.enableHTTPS = YES;
//    zhengRequest.baseUrlStr = @"https://";
    zhengRequest.urlStr = @"https://itunes.apple.com/lookup";
//    zhengRequest.urlStr = @"itunes.apple.com/lookup";
    zhengRequest.parameters = @{@"id":@"444934666"};
    zhengRequest.cacheMethod = CacheMethod_NoCache;
    
    [ZhengNetWork sendRequest:zhengRequest success:^(id responseObject ,NSMutableArray *modelArray) {
        NSLog(@"%@",responseObject);
        NSLog(@"%ld",zhengRequest.requestStatus);
    } failure:^(NSError *error) {
        NSLog(@"--------------------");
    }];
    //不可连用  一个请求一个状态
    //    [ZhengNetWork sendRequest:zhengRequest success:^(id responseObject) {
    //        NSLog(@"%@",responseObject);
    //        NSLog(@"%ld",zhengRequest.requestStatus);
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    //    [zhengRequest stopRequest];
    //    NSLog(@"%ld",zhengRequest.requestStatus);
}

- (void)requestListPageDataNoCache{
    ZhengPageRequest *zhengPageRequest = [[ZhengPageRequest alloc] init];
    zhengPageRequest.urlStr = @"http://api.goldtoutiao.com/v2/livenews";
    zhengPageRequest.page = 1;
    zhengPageRequest.limit = @(2);
    
    [ZhengNetWork sendRequest:zhengPageRequest success:^(id responseObject ,NSMutableArray *modelArray) {
        NSLog(@"%@",responseObject);
        NSLog(@"%ld",zhengPageRequest.requestStatus);
    } failure:^(NSError *error) {
        
    }];
    //    [zhengRequest stopRequest];
    //    NSLog(@"%ld",zhengRequest.requestStatus);
    //    NSLog(@"--------------------");
}

- (void)requestJsonDicDataCache{
    
    
    ZhengRequest *zhengRequest = [[ZhengRequest alloc] init];
    zhengRequest.urlStr = @"https://itunes.apple.com/lookup";
    zhengRequest.parameters = @{@"id":@"444934666"};
    zhengRequest.cacheMethod = CacheMethod_Coding;
    zhengRequest.className = [JsonDicModel class];
//    zhengRequest.expiredTime = 58 * 60 * 60;
    //    [ZhengNetWork sendRequest:zhengRequest success:^(id responseObject ,id modelObject) {
    //        NSLog(@"%@",responseObject);
    //        NSLog(@"%ld",zhengRequest.requestStatus);
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    [ZhengNetWork readCacheRequest:zhengRequest cache:^(id responseObject, id modelObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",modelObject);
        NSLog(@"%ld",zhengRequest.requestStatus);
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestListPageDataCache{
    ZhengPageRequest *zhengPageRequest = [[ZhengPageRequest alloc] init];
    zhengPageRequest.urlStr = @"http://api.goldtoutiao.com/v2/livenews";
    zhengPageRequest.page = 1;
    zhengPageRequest.limit = @(2);
    
    zhengPageRequest.cacheMethod = CacheMethod_SQLite;
    
    zhengPageRequest.needJsonField = @"results";
    zhengPageRequest.className = [PageModel class];
    
//        [ZhengNetWork sendRequest:zhengPageRequest success:^(id responseObject ,id modelObject) {
//            NSLog(@"%@",responseObject);
//            NSLog(@"%@",modelObject);
//            NSLog(@"%ld",zhengPageRequest.requestStatus);
//        } failure:^(NSError *error) {
//    
//        }];
    
    [ZhengNetWork readCacheRequest:zhengPageRequest cache:^(id responseObject, id modelObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",modelObject);
        NSLog(@"%ld",zhengPageRequest.requestStatus);
    } failure:^(NSError *error) {
        
    }];
    
    //    [zhengRequest stopRequest];
    //    NSLog(@"%ld",zhengRequest.requestStatus);
    //    NSLog(@"--------------------");
}

- (void)downloadFile{
    
    NSLog(@"--------------------");
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"--------------------");
    
    NSURL *targetDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    ZhengDownloadRequest *zhengDownloadRequest = [[ZhengDownloadRequest alloc] init];
    
//    https://download3.vmware.com/software/fusion/file/VMware-Fusion-8.5.5-5192483.dmg
//    https://download.alicdn.com/dingtalk-desktop/Release/install/DingTalk_v3.2.0.dmg
    zhengDownloadRequest.urlStr = @"https://download.alicdn.com/dingtalk-desktop/Release/install/DingTalk_v3.2.0.dmg";
    zhengDownloadRequest.targetDirectoryURL = targetDirectoryURL;
    
    [ZhengNetWork downLoadFileRequst:zhengDownloadRequest progress:^(NSProgress *downloadProgress) {
        
//        NSLog(@"-------%@-----",downloadProgress);
        NSLog(@"----%lld----%lld-",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        NSLog(@"-------%f-----",downloadProgress.fractionCompleted);
//        NSLog(@"%@",zhengDownloadRequest.downloadTask.response.suggestedFilename);//DingTalk_v3.2.0.dmg
//        NSLog(@"%lld",zhengDownloadRequest.downloadTask.response.expectedContentLength);//68656690
//        NSLog(@"--------------------");
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //下载完成才会调用
        
//        NSLog(@"--------------------");
//        NSLog(@"%lld",response.expectedContentLength);//68656690
//        NSLog(@"%@",response.suggestedFilename);//DingTalk_v3.2.0.dmg
//        NSLog(@"%@",response.textEncodingName);//(null)
//        NSLog(@"%@",response.MIMEType);//application/octet-stream
//        NSLog(@"%@",targetPath);//临时缓存目录
//        NSLog(@"--------------------");
        
        
        //此处检查是否有相同文件（如果知道文件名  在下载前进行检查）
        
        return [zhengDownloadRequest.targetDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"--   %@   --", filePath);
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"-----------suspend---------");
//        [zhengDownloadRequest suspend];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [zhengDownloadRequest resume];
//            NSLog(@"-----------resume---------");
//        });
//    });
}

- (void)downloadBRFile{
    
    NSLog(@"--------------------");
    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"--------------------");
    
    NSURL *targetDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    ZhengBRDownloadRequest *request = [[ZhengBRDownloadRequest alloc] init];
    request.urlStr = @"https://download.alicdn.com/dingtalk-desktop/Release/install/DingTalk_v3.2.0.dmg";
    
    request.targetPath = [targetDirectoryURL.path stringByAppendingPathComponent:@"DingTalk_v3.2.0.dmg"];
    
    [ZhengNetWork downLoadFileBRRequst:request progress:^(NSProgress *downloadProgress) {
        NSLog(@"----%lld----%lld-",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        NSLog(@"-------%f-----",downloadProgress.fractionCompleted);
        
    } completionHandler:^(NSURLResponse * response, id responseObject, NSError *error) {
        NSLog(@"--------------------");
        NSLog(@"%@",response);
        NSLog(@"--------------------");
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [request suspend];
//    });
}

- (void)uploadFile{
    ZhengUploadRequest *zhengUploadRequest = [[ZhengUploadRequest alloc] init];
    zhengUploadRequest.urlStr = @"http://example.com/upload";
    zhengUploadRequest.upLoadFilePath = @"file://path/to/image.png";
    
    [ZhengNetWork upLoadRequst:zhengUploadRequest progress:^(NSProgress *uploadProgress) {
        NSLog(@"----%lld----%lld-",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        NSLog(@"-------%f-----",uploadProgress.fractionCompleted);
        
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
}

- (void)uploadMultiRequst{
    ZhengMultiUploadRequest *zhengMultiUploadRequest = [[ZhengMultiUploadRequest alloc] init];
    zhengMultiUploadRequest.urlStr = @"http://example.com/upload";
    zhengMultiUploadRequest.upLoadFilePath = @"file://path/to/image.jpg";
    zhengMultiUploadRequest.fileName = @"filename.jpg";
    zhengMultiUploadRequest.parameters = @{};
    zhengMultiUploadRequest.mimeType = @"image/jpeg";
    
    [ZhengNetWork upLoadMultiRequst:zhengMultiUploadRequest multiprogress:^(NSProgress *uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程操作
        });
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
}



@end
