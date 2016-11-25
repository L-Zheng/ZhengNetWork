//
//  ZhengCacheTool.m
//  AFN封装使用
//
//  Created by 李保征 on 16/7/18.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengCacheTool.h"
#import "ZhengCacheSQLite.h"
#import "ZhengCacheCoding.h"

@implementation ZhengCacheTool

#pragma mark - 缓存与读取   列表数据（数据类型数组）
//缓存数据
+ (BOOL)cacheArray:(NSArray *)cacheArray class:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod{
    
    //请求数据 数组 若为空
    if (cacheArray == nil || cacheArray.count == 0) {
        return nil;
    }
    
    switch (cacheMethod) {
        case CacheMethodCoding:{      //缓存Coding
            return [ZhengCacheCoding cacheArray:cacheArray class:ClassName parameters:parameters];
        }
            break;
            
        case CacheMethodSQLite:{      //缓存数据库
            return [[ZhengCacheSQLite shareCacheSQLite] cacheArray:cacheArray class:ClassName parameters:parameters];
        }
            break;
            
        default:{
            return NO;
        }
            break;
    }
}

//读取缓存数据
+ (NSArray *)readArrayFromClass:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod{
    
    NSArray *readArray;
    
    //从缓存加载数据
    switch (cacheMethod) {
        case CacheMethodCoding:{  //Coding
            readArray = [ZhengCacheCoding readArrayClass:ClassName parameters:parameters];
        }
            break;
            
        case CacheMethodSQLite:{  //数据库
            readArray = [[ZhengCacheSQLite shareCacheSQLite] readArrayClass:ClassName parameters:parameters];
        }
            break;
            
        default:{
            readArray = nil;
        }
            break;
    }
    //读取数据若为空
    return readArray;
}


#pragma mark - 缓存读取数据   不是分页数据  单纯Json字典或者数组
/** 缓存数据 不是分页数据 单纯Json字典或者数组 只能用Coding */
+ (BOOL)cacheJson:(id)cacheJson class:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod{
    
    if (cacheJson == nil || cacheJson == (id)[NSNull null]) return nil;
    
#warning 此处强制转为CacheMethodCoding方式缓存数据
    cacheMethod = CacheMethodCoding;
    
    switch (cacheMethod) {
        case CacheMethodCoding:{
            return [ZhengCacheCoding cacheJson:cacheJson class:ClassName parameters:parameters];
        }
            break;
            
        case CacheMethodSQLite:{
            return NO;
        }
            break;
            
        default:{
            return NO;
        }
            break;
    }
}

/** 读取数据 不是分页数据 单纯Json字典或者数组 只能用Coding指定参数 */
+ (id)readJsonClass:(Class)ClassName parameters:(NSDictionary *)parameters cacheMethod:(CacheMethod)cacheMethod{
    
    id readJson;
    
#warning 此处强制转为CacheMethodCoding方式读取缓存
    cacheMethod = CacheMethodCoding;
    
    switch (cacheMethod) {
        case CacheMethodCoding:{
            readJson = [ZhengCacheCoding readJsonClass:ClassName parameters:parameters];
        }
            break;
            
        case CacheMethodSQLite:{
            readJson = nil;
        }
            break;
            
        default:{
            readJson = nil;
        }
            break;
    }

    return readJson;
}


@end
