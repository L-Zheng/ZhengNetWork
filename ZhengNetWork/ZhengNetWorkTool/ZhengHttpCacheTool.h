//
//  ZhengHttpCacheTool.h
//  AFN封装使用
//
//  Created by 李保征 on 16/7/22.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhengCacheTool.h"

@interface ZhengHttpCacheTool : NSObject


#pragma mark - 用户列表数据请求（分页的）列表数据（数据类型数组） 最好用SQLite也可用Coding
/**   get请求  （返回json数据为字典）
 @param urlStr      请求地址
 @param parameters  传入参数
 @param cacheArrayField    要缓存的数组所在字典的字段
 @param ClassName   获得Json字典转成的模型类
 @param cacheMethod 缓存方法
 @param success     成功回调  传出数据模型
 @param failure     失败回调
 */
+ (NSURLSessionDataTask *)getRequestListUrlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters cacheArrayField:(NSString *)cacheArrayField class:(Class)ClassName cacheMethod:(CacheMethod)cacheMethod success:(void (^)(id responseModelArray))success failure:(void (^)(NSError *error))failure;

/**   post请求  （返回json数据为字典）
 @param urlStr      请求地址
 @param parameters  传入参数
 @param ClassName   获得Json字典转成的模型类
 @param cacheMethod 缓存方法
 @param success     成功回调  传出数据模型
 @param failure     失败回调
 */
+ (NSURLSessionDataTask *)postRequestListUrlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters cacheArrayField:(NSString *)cacheArrayField class:(Class)ClassName cacheMethod:(CacheMethod)cacheMethod success:(void (^)(id responseModelArray))success failure:(void (^)(NSError *error))failure;


/**   读取缓存  返回列表数据模型数组
 @param parameters  传入参数(列表主要参数page  limit)
 @param ClassName   获得Json字典转成的模型类
 @param cacheMethod 缓存方法
 */
+ (NSArray *)readCacheListArray:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod;


#pragma mark - 数据请求  不是分页数据  单纯Json字典或者数组   只能用Coding
/**  get请求  responseObject是字典回调模型 responseObject是数组回调模型数组
 */
+ (NSURLSessionDataTask *)getRequestJsonUrlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters class:(Class)ClassName cacheMethod:(CacheMethod)cacheMethod success:(void (^)(id responseModelDicOrArray))success failure:(void (^)(NSError *error))failure;

/**  post请求  responseObject是字典回调模型 responseObject是数组回调模型数组
 */
+ (NSURLSessionDataTask *)postRequestJsonUrlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters class:(Class)ClassName cacheMethod:(CacheMethod)cacheMethod success:(void (^)(id responseModelDicOrArray))success failure:(void (^)(NSError *error))failure;


/**  读取缓存  返回Json数据模型  Json为字典返回单个模型   Json为数组 返回模型数组
 @param parameters  传入参数(列表主要参数page  limit)
 @param ClassName   获得Json字典转成的模型类
 @param cacheMethod 缓存方法
 */
+ (id)readCacheJson:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod;

#pragma mark - requestHeader

+ (void)setRequestHeader:(NSDictionary *)headerInfo urlStr:(NSString *)urlStr;

#pragma mark - 停止请求

+ (void)stopAllRequest;

+ (void)stopRequestWith:(NSString *)urlStr;

@end
