//
//  ZhengHttpCacheTool.m
//  AFN封装使用
//
//  Created by 李保征 on 16/7/22.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengHttpCacheTool.h"
#import "ZhengConvertModelTool.h"
#import "ZhengHttpTool.h"

@implementation ZhengHttpCacheTool


#pragma mark - 用户列表数据请求（分页的）列表数据（数据类型数组） 建议用SQLite也可用Coding
/** get请求 带有缓存 */
+ (NSURLSessionDataTask *)getRequestListUrlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters cacheArrayField:(NSString *)cacheArrayField class:(Class)ClassName cacheMethod:(CacheMethod)cacheMethod success:(void (^)(id responseModelArray))success failure:(void (^)(NSError *error))failure{
    
    //调用基类请求
    NSURLSessionDataTask *task = [ZhengHttpTool getRequest:urlStr parameters:parameters success:^(id responseObject) {
        
        //1.请求数据为空
        if (responseObject == nil || responseObject == (id)[NSNull null]){
            success(nil);
            return;
        }
        
        // 2.1拿到json数据
        NSDictionary *dic = (NSDictionary *)responseObject;
        //2.2取出待缓存的数组
        NSArray *cacheArray = dic[cacheArrayField];
        
        //3.缓存到本地
        BOOL isCacheSuccess = [ZhengCacheTool cacheArray:cacheArray class:ClassName parameters:parameters cacheMethod:cacheMethod];
        
        //4.模型转换处理
        NSArray *modelArray = (NSArray *)[ZhengConvertModelTool zhengSourceData:cacheArray toModel:ClassName];
        
        //5.回调数据
        success(modelArray);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    return task;
}

/** post请求 带有缓存 */
+ (NSURLSessionDataTask *)postRequestListUrlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters cacheArrayField:(NSString *)cacheArrayField class:(Class)ClassName cacheMethod:(CacheMethod)cacheMethod success:(void (^)(id responseModelArray))success failure:(void (^)(NSError *error))failure{
    
    //调用基类请求
    NSURLSessionDataTask *task = [ZhengHttpTool postRequest:urlStr parameters:parameters success:^(id responseObject) {
        
        //1.请求数据为空
        if (responseObject == nil || responseObject == (id)[NSNull null]){
            success(nil);
            return;
        }
        
        // 2.1拿到json数据
        NSDictionary *dic = (NSDictionary *)responseObject;
        //2.2取出待缓存的数组
        NSArray *cacheArray = dic[cacheArrayField];
        
        //3.缓存到本地
        BOOL isCacheSuccess = [ZhengCacheTool cacheArray:cacheArray class:ClassName parameters:parameters cacheMethod:cacheMethod];
        
        //4.模型转换处理
        NSArray *modelArray = (NSArray *)[ZhengConvertModelTool zhengSourceData:cacheArray toModel:ClassName];
        
        //5.回调数据
        success(modelArray);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    return task;
}

/** 读取缓存  返回列表数据模型数组 */
+ (NSArray *)readCacheListArray:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod{
    //获得源数据
    NSArray *sourceArray = [ZhengCacheTool readArrayFromClass:ClassName parameters:parameters cacheMethod:cacheMethod];
    
    //转模型处理
    return [ZhengConvertModelTool zhengSourceData:sourceArray toModel:ClassName];
}

#pragma mark - 数据请求  不是分页数据  单纯Json字典或者数组   暂时只能用Coding（内部会强制转为CacheMethodCoding方式）
/**   get请求 */
+ (NSURLSessionDataTask *)getRequestJsonUrlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters class:(Class)ClassName cacheMethod:(CacheMethod)cacheMethod success:(void (^)(id responseModelDicOrArray))success failure:(void (^)(NSError *error))failure{
    //调用基类请求
    NSURLSessionDataTask *task = [ZhengHttpTool getRequest:urlStr parameters:parameters success:^(id responseObject) {
        
        //1.请求数据为空
        if (responseObject == nil || responseObject == (id)[NSNull null]){
            success(nil);
            return;
        }

        //2.缓存到本地
        BOOL isCacheSuccess = [ZhengCacheTool cacheJson:responseObject class:ClassName parameters:parameters cacheMethod:cacheMethod];
        
        //3.转模型处理
        id model = [ZhengConvertModelTool zhengSourceData:responseObject toModel:ClassName];
        
        //4.回调数据
        //  如果responseObject是字典回调模型    如果responseObject是数组 回调模型数组
        success(model);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    return task;
}

/**  post请求  responseObject是字典回调模型 responseObject是数组回调模型数组
 */
+ (NSURLSessionDataTask *)postRequestJsonUrlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters class:(Class)ClassName cacheMethod:(CacheMethod)cacheMethod success:(void (^)(id responseModelDicOrArray))success failure:(void (^)(NSError *error))failure{
    //调用基类请求
    NSURLSessionDataTask *task = [ZhengHttpTool postRequest:urlStr parameters:parameters success:^(id responseObject) {
        
        //1.请求数据为空
        if (responseObject == nil || responseObject == (id)[NSNull null]){
            success(nil);
            return;
        }
        
        //2.缓存到本地
        BOOL isCacheSuccess = [ZhengCacheTool cacheJson:responseObject class:ClassName parameters:parameters cacheMethod:cacheMethod];
        
        //3.转模型处理
        id model = [ZhengConvertModelTool zhengSourceData:responseObject toModel:ClassName];
        
        //4.回调数据
        //  如果responseObject是字典回调模型    如果responseObject是数组 回调模型数组
        success(model);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    return task;
}

/** 读取缓存  返回Json数据模型  Json为字典返回单个模型   Json为数组 返回模型数组 */
+ (id)readCacheJson:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod{
    //获得源数据
    id sourceJson = [ZhengCacheTool readJsonClass:ClassName parameters:parameters cacheMethod:cacheMethod];
    
    //转模型处理
    return [ZhengConvertModelTool zhengSourceData:sourceJson toModel:ClassName];
}

#pragma mark - requestHeader

+ (void)setRequestHeader:(NSDictionary *)headerInfo urlStr:(NSString *)urlStr{
    [ZhengHttpTool setRequestHeader:headerInfo urlStr:urlStr];
}

#pragma mark - 停止请求

+ (void)stopAllRequest{
    [ZhengHttpTool stopAllRequest];
}

+ (void)stopRequestWith:(NSString *)urlStr{
    [ZhengHttpTool stopRequestWith:urlStr];
}

#pragma mark - Privacy func

static id _instance;
+ (instancetype)sharedZhengHttpCacheTool{
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

- (void)dealloc{
    
}

@end
