//
//  ZhengNetWork.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhengBaseRequest.h"
#import "ZhengRequest.h"
#import "ZhengDownloadRequest.h"
#import "ZhengBRDownloadRequest.h"
#import "ZhengUploadRequest.h"
#import "ZhengMultiUploadRequest.h"
#import "ZhengImageUploadRequest.h"
#import "ZhengFileUploadRequest.h"

@interface ZhengNetWork : NSObject

#pragma mark - Request

/** 发送请求 */
+ (void)sendRequest:(ZhengRequest *)zhengRequest success:(void (^)(id responseObject ,id modelObject))success failure:(void (^)(NSError *error))failure;

/** 读取缓存 */
+ (void)readCacheRequest:(ZhengRequest *)zhengRequest cache:(void (^)(id responseObject ,id modelObject))cache failure:(void (^)(NSError *error))failure;

#pragma mark - download

/** 非断点下载  下载文件临时存放目录和目标目录不同 */
+ (void)downLoadFileRequst:(ZhengDownloadRequest *)zhengDownloadRequest
              progress:(void (^)(NSProgress *downloadProgress))downloadProgress
           destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
     completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/** 断点下载  下载文件临时存放目录和目标目录相同 */
+ (void)downLoadFileBRRequst:(ZhengBRDownloadRequest *)zhengBRDownloadRequest
                    progress:(void (^)(NSProgress *downloadProgress))downloadProgress
           completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError * error))completionHandler;

#pragma mark - upload

/** 普通上传任务 */
+ (void)upLoadRequst:(ZhengUploadRequest *)zhengUploadRequest
            progress:(void (^)(NSProgress *uploadProgress))uploadProgress
   completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

/** 上传图片请求 */
+ (void)upLoadImageRequst:(ZhengImageUploadRequest *)zhengImageUploadRequest
                 progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/** 上传文件请求 */
+ (void)upLoadFileRequst:(ZhengFileUploadRequest *)zhengFileUploadRequest
                 progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/** 上传多请求（多文件） */
+ (void)upLoadMultiRequst:(ZhengMultiUploadRequest *)zhengMultiUploadRequest
           multiprogress:(void (^)(NSProgress *uploadProgress))uploadMultiProgress
       completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

@end
