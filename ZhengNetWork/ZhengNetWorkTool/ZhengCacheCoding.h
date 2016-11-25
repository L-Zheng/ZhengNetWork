//
//  ZhengCacheCoding.h
//  AFN封装使用
//
//  Created by 李保征 on 16/7/21.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhengCacheCoding : NSObject

#pragma mark - 缓存读取数据   列表分页数据  （数据类型数组）
/** 缓存数据 列表分页数据  （数据类型数组） Coding */
+ (BOOL)cacheArray:(NSArray *)cacheArray class:(Class)ClassName parameters:(NSDictionary *)parameters;

/** 读取数据 列表分页数据  （数据类型数组） Coding 指定参数 */
+ (NSArray *)readArrayClass:(Class)ClassName parameters:(NSDictionary *)parameters;

#pragma mark - 缓存读取数据   不是分页数据  单纯Json字典或者数组
/** 缓存数据 不是分页数据 单纯Json字典或者数 Coding */
+ (BOOL)cacheJson:(id)cacheJson class:(Class)ClassName parameters:(NSDictionary *)parameters;

/** 读取数据 不是分页数据 单纯Json字典或者数Coding 指定参数 */
+ (id)readJsonClass:(Class)ClassName parameters:(NSDictionary *)parameters;

@end
