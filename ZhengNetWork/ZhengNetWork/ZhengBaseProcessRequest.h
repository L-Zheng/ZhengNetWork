//
//  ZhengBaseProcessRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2017/3/20.
//  Copyright © 2017年 李保征. All rights reserved.
//

//用于上传或下载大文件的请求

#import "ZhengBaseRequest.h"
#import "AFNetworking.h"

@interface ZhengBaseProcessRequest : ZhengBaseRequest

@property (nullable, strong) AFURLSessionManager *sessionManager;

@property (nullable, strong) NSURLSessionTask *currentTask;

- (void)resume;

- (void)suspend;

- (void)cancel;

@end
