//
//  ZhengHttpTool.h
//  GoldTouTiao
//
//  Created by 李保征 on 16/7/11.
//  Copyright © 2016年 wallstreetcn. All rights reserved.
//
//
//  此类隔离AFNetworking框架

#import <Foundation/Foundation.h>

@interface ZhengHttpTool : NSObject

/** get请求 封装AFNetWorking */
+ (NSURLSessionDataTask *)getRequest:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

/** post请求 封装AFNetWorking */
+ (NSURLSessionDataTask *)postRequest:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)setRequestHeader:(NSDictionary *)headerInfo urlStr:(NSString *)urlStr;

#pragma mark - 停止请求

+ (void)stopAllRequest;

+ (void)stopRequestWith:(NSString *)urlStr;

@end
