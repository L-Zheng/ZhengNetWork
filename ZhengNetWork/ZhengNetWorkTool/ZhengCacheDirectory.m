//
//  ZhengCacheDirectory.m
//  AFN封装使用
//
//  Created by 李保征 on 16/7/18.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengCacheDirectory.h"

@implementation ZhengCacheDirectory


#pragma mark - 缓存文件全路径
+ (NSString *)cacheFullPathWithDirectory:(NSString *)classNameDirectory cacheMethod:(CacheMethod)cacheMethod{
    //缓存的文件名
    NSString *fileName;
    //设定总体 数据缓存目录
    NSString *directoryStr;
    
    if (cacheMethod == CacheMethodCoding) {
        fileName = [NSString stringWithFormat:@"%@_CacheData.%@",classNameDirectory,CodingCacheFileSuffixName];
        
        //(Library/Caches/LiBaoZhengCache/LiBaoZhengCacheCoding)
        directoryStr = [ZhengCacheDirectory CodingCacheDirectory];
        
    }else if (cacheMethod == CacheMethodSQLite){
        //数据库缓存的话   缓存在单个文件中
        fileName = [NSString stringWithFormat:@"%@_CacheData.%@",classNameDirectory,SQLiteCacheFileSuffixName];
        
        //(Library/Caches/LiBaoZhengCache/LiBaoZhengCacheSQLite)
        directoryStr = [ZhengCacheDirectory SQLiteCacheDirectory];
    }
    else{
        
    }
    
    //(Library/Caches/LiBaoZhengCache/LiBaoZhengCacheCoding/ClassName)
    NSString *classNameDirectoryPath = [directoryStr stringByAppendingPathComponent:classNameDirectory];
    //创建文件夹
    [ZhengCacheDirectory creatFileFolder:classNameDirectoryPath];
    
    //返回全路径
    //  (Library/Caches/LiBaoZhengCache/LiBaoZhengCacheCoding/ClassName/ClassName_CacheData_1.data)
    return [classNameDirectoryPath stringByAppendingPathComponent:fileName];
}

#pragma mark - 缓存目录设置
// 清除缓存 总体缓存目录LiBaoZheng
+ (BOOL)deleteAllCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:[ZhengCacheDirectory allCacheDirectory] error:nil];
}

// 获取 总体缓存目录LiBaoZheng 大小 字节数
+ (long long)readCacheDirectorySize{
    return [self readFileSize:[ZhengCacheDirectory allCacheDirectory]];
}

// 获取文件(夹)大小  字节数
+ (long long)readFileSize:(NSString *)filePath{
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:filePath error:nil];
        long long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [filePath stringByAppendingPathComponent:subpath];
            totalSize += [self readFileSize:fullSubpath];
        }
        return totalSize;
    } else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
        return [attr[NSFileSize] longLongValue];
    }
}

// 创建文件夹
+ (BOOL)creatFileFolder:(NSString *)fileFolderPath{
    BOOL isDir = NO;
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fileFolderPath isDirectory:&isDir];
    if (!existed){
        BOOL isCreatSuccess = [fileManager createDirectoryAtPath:fileFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
        return isCreatSuccess;
    }else{
        return YES;
    }
}

// 文件是否存在
+ (BOOL)fileIsExistsAtPath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

#pragma mark - 私有方法
// 总体缓存目录
+ (NSString *)allCacheDirectory{
    NSString *allCachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LiBaoZhengCache"];
    BOOL isSuccess = [ZhengCacheDirectory creatFileFolder:allCachePath];
    if (isSuccess) {
        return allCachePath;
    }else{
        return nil;
    }
}
// 数据库缓存目录
+ (NSString *)SQLiteCacheDirectory{
    
    NSString *sqLiteCachePath = [[self allCacheDirectory] stringByAppendingPathComponent:@"LiBaoZhengCacheSQLite"];
    
    BOOL isSuccess = [ZhengCacheDirectory creatFileFolder:sqLiteCachePath];
    if (isSuccess) {
        return sqLiteCachePath;
    }else{
        return nil;
    }
}
// coding缓存目录
+ (NSString *)CodingCacheDirectory{
    
    NSString *codingCachePath = [[self allCacheDirectory] stringByAppendingPathComponent:@"LiBaoZhengCacheCoding"];
    
    BOOL isSuccess = [ZhengCacheDirectory creatFileFolder:codingCachePath];
    if (isSuccess) {
        return codingCachePath;
    }else{
        return nil;
    }
}

@end
