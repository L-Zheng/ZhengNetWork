//
//  ZhengHttpTool.m
//  GoldTouTiao
//
//  Created by 李保征 on 16/7/11.
//  Copyright © 2016年 wallstreetcn. All rights reserved.
//

#import "ZhengHttpTool.h"
#import "AFNetworking.h"

@interface ZhengHttpTool ()

@property (nonatomic, strong) NSMutableDictionary *allManagerRequestDic;

@property (nonatomic, strong) NSMutableDictionary *allRequestHeaderDic;

@end

@implementation ZhengHttpTool

#pragma mark - 公共方法
/** get请求 封装AFNetWorking */
+ (NSURLSessionDataTask *)getRequest:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    //检查urlStr
    NSError *myError = [ZhengHttpTool checkUrlStr:urlStr];
    if (myError) {
        failure(myError); return nil;
    }
    
    //创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求头
    [ZhengHttpTool handleRequestHeader:manager urlStr:urlStr];
    
    //发送get请求
     NSURLSessionDataTask *task = [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功回调
        success(responseObject);
        //移除请求
        [ZhengHttpTool removeCacheDicDataUrlStr:urlStr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败回调
        failure(error);
        //移除请求
        [ZhengHttpTool removeCacheDicDataUrlStr:urlStr];
    }];
    
    //保存请求
    [[ZhengHttpTool sharedZhengHttpTool].allManagerRequestDic setObject:manager forKey:urlStr];
    
    return task;
}

/** post请求 封装AFNetWorking */
+ (NSURLSessionDataTask *)postRequest:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{
    
    //检查urlStr
    NSError *myError = [ZhengHttpTool checkUrlStr:urlStr];
    if (myError) {
        failure(myError); return nil;
    }
    //创建管理者  AFHTTPSessionManager继承自AFURLSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求头
    [ZhengHttpTool handleRequestHeader:manager urlStr:urlStr];
    
    //发送POST请求
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功回调
        success(responseObject);
        //移除请求
        [ZhengHttpTool removeCacheDicDataUrlStr:urlStr];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败回调
        failure(error);
        //移除请求
        [ZhengHttpTool removeCacheDicDataUrlStr:urlStr];
    }];
    
    //保存请求
    [[ZhengHttpTool sharedZhengHttpTool].allManagerRequestDic setObject:manager forKey:urlStr];
    
    return task;
}

+ (void)setRequestHeader:(NSDictionary *)headerInfo urlStr:(NSString *)urlStr{
    if (headerInfo&&urlStr) {
        if (![urlStr isEqualToString:@""]) {
            [[ZhengHttpTool sharedZhengHttpTool].allRequestHeaderDic setObject:headerInfo forKey:urlStr];
        }
    }
}

#pragma mark - 停止请求

+ (void)stopAllRequest{
//    [manager.operationQueue cancelAllOperations];
    for (AFHTTPSessionManager *manager in [ZhengHttpTool sharedZhengHttpTool].allManagerRequestDic) {
        [manager.operationQueue cancelAllOperations];
//        for (NSURLSessionTask *task in manager.tasks) {
//            if (task.state == NSURLSessionTaskStateRunning) {
//                [task cancel];
//            }
//        }
    }
    [[ZhengHttpTool sharedZhengHttpTool].allManagerRequestDic removeAllObjects];
}

+ (void)stopRequestWith:(NSString *)urlStr{
    AFHTTPSessionManager *manager = [[ZhengHttpTool sharedZhengHttpTool].allManagerRequestDic objectForKey:urlStr];
    if (manager) {
        [manager.operationQueue cancelAllOperations];
//        for (NSURLSessionTask *task in manager.tasks) {
//            [task cancel];
//        }
        [[ZhengHttpTool sharedZhengHttpTool].allManagerRequestDic removeObjectForKey:urlStr];
    }
}

#pragma mark - getter

- (NSMutableDictionary *)allManagerRequestDic{
    if (!_allManagerRequestDic) {
        _allManagerRequestDic = [NSMutableDictionary dictionary];
    }
    return _allManagerRequestDic;
}

- (NSMutableDictionary *)allRequestHeaderDic{
    if (!_allRequestHeaderDic) {
        _allRequestHeaderDic = [NSMutableDictionary dictionary];
    }
    return _allRequestHeaderDic;
}

#pragma mark - 私有方法

static id _instance;
+ (instancetype)sharedZhengHttpTool{
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

- (void)dealloc{
    
}

/** 判断请求地址是否为空 */
+ (NSError *)checkUrlStr:(NSString *)urlStr{
    if (urlStr == nil || [urlStr isEqual:[NSNull null]] || [urlStr isEqualToString:@""]){
        //失败回调
        NSError *myError = [NSError errorWithDomain:@"请求链接为空" code:404 userInfo:nil];
        return myError;
    }
    else{
        return nil;
    }
}

//处理请求头数据
+ (void)handleRequestHeader:(AFHTTPSessionManager *)manager urlStr:(NSString *)urlStr{
    
    NSDictionary *headerInfo = [[ZhengHttpTool sharedZhengHttpTool].allRequestHeaderDic valueForKey:urlStr];
    
    if (headerInfo) {
        for (NSString *key in headerInfo.allKeys) {
            [manager.requestSerializer setValue:headerInfo[key] forHTTPHeaderField:key];
        }
    }
}

//移除保存数据
+ (void)removeCacheDicDataUrlStr:(NSString *)urlStr{
    [[ZhengHttpTool sharedZhengHttpTool].allManagerRequestDic removeObjectForKey:urlStr];
    [[ZhengHttpTool sharedZhengHttpTool].allRequestHeaderDic removeObjectForKey:urlStr];
}

@end
