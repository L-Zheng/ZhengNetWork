//
//  ZhengCacheTool.h
//  AFN封装使用
//
//  Created by 李保征 on 16/7/18.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZhengCacheDirectory.h"


@interface ZhengCacheTool : NSObject

#pragma mark - 缓存读取方法 列表数据（数据类型数组） 建议用SQLite也可用Coding
/**   缓存数组
 @param cacheArray        数组
 @param ClassName         转换的模型类
 @param parameters        请求参数  同网络请求参数相同
 @param cacheMethod       缓存方法
 
 @return 模型数组
 */
+ (BOOL)cacheArray:(NSArray *)cacheArray class:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod;

/**  读取缓存返回源数据
 @param ClassName         转换的模型类
 @param parameters        请求参数  同网络请求参数相同
 @param cacheMethod       缓存方法
 
 @return 模型数组
 */
+ (NSArray *)readArrayFromClass:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod;


#pragma mark - 缓存读取数据   不是分页数据  单纯Json字典或者数组   只能用Coding
/** 缓存数据 不是分页数据 单纯Json字典或者数组 Coding
 @param cacheJson         缓存的数据（字典或者数组  数组中必须装字典）
 @param ClassName         转换的模型类
 @param parameters        请求参数  同网络请求参数相同
 @param cacheMethod       缓存方法
 
 @return 模型
 */
+ (BOOL)cacheJson:(id)cacheJson class:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod;

/** 读取数据 不是分页数据 单纯Json字典或者数组 Coding 指定参数
 @param cacheJson         缓存的数据（字典或者数组  数组中必须装字典）
 @param ClassName         转换的模型类
 @param parameters        请求参数  同网络请求参数相同
 @param cacheMethod       缓存方法
 
 @return 模型
 */
+ (id)readJsonClass:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod;



@end
