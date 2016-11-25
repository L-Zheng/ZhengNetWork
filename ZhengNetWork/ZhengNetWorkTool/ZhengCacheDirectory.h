//
//  ZhengCacheDirectory.h
//  AFN封装使用
//
//  Created by 李保征 on 16/7/18.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    CacheMethodCoding = 0, // coding
    CacheMethodSQLite = 1, // 数据库
} CacheMethod;

#define CodingCacheFileSuffixName @"data"
#define SQLiteCacheFileSuffixName @"sqlite"


@interface ZhengCacheDirectory : NSObject


#pragma mark - 缓存目录方法

/**   返回缓存的全路径
 @param directory   请求获得数据需要转成什么类型的模型  以该模型的类名作为缓存目录名
 @param page        第几页数据（不同页的数据以不同的文件保存）
 */
+ (NSString *)cacheFullPathWithDirectory:(NSString *)classNameDirectory cacheMethod:(CacheMethod)cacheMethod;

/** 清除缓存 总体缓存目录LiBaoZheng */
+ (BOOL)deleteAllCache;

/** 获取缓存目录文件(夹)大小  字节数 总体缓存目录LiBaoZheng */
+ (long long)readCacheDirectorySize;

/** 获取文件(夹)大小  字节数 */
+ (long long)readFileSize:(NSString *)filePath;


/** 是否存在某文件 */
+ (BOOL)fileIsExistsAtPath:(NSString *)filePath;


@end
