//
//  ZhengCacheSQLite.h
//  AFN封装使用
//
//  Created by 李保征 on 16/7/21.
//  Copyright © 2016年 李保征. All rights reserved.
//
//
//  此类隔离FMDB框架

#import <Foundation/Foundation.h>

@interface ZhengCacheSQLite : NSObject


+ (instancetype)shareCacheSQLite;

#pragma mark - 缓存读取数据   列表分页数据  （数据类型数组）
/** 缓存数据库 列表分页数据  （数据类型数组） */
- (BOOL)cacheArray:(NSArray *)cacheArray class:(Class)ClassName parameters:(NSDictionary *)parameters;

/** 读取数据库 列表分页数据  （数据类型数组）*/
- (NSArray *)readArrayClass:(Class)ClassName parameters:(NSDictionary *)parameters;

@end
