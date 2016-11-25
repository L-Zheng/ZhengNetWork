//
//  ZhengCacheSQLite.m
//  AFN封装使用
//
//  Created by 李保征 on 16/7/21.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengCacheSQLite.h"
#import "ZhengCacheDirectory.h"
#import "FMDB.h"
#import "ZhengParameterFieldConst.h"

//数据库字段（不要改）
#define SQTableName @"t_myTable"
#define SQDicID @"dict_ID"
#define SQDicFiledName @"my_respose_dict"


@interface ZhengCacheSQLite ()

@property (nonatomic, strong) FMDatabase *myDataBase;

@end

@implementation ZhengCacheSQLite

#pragma mark - 缓存读取数据   列表分页数据  （数据类型数组）
//缓存数据库
- (BOOL)cacheArray:(NSArray *)cacheArray class:(Class)ClassName parameters:(NSDictionary *)parameters{
    
    //缓存完整路径  数据库文件用不到page字段
    //  (Library/Caches/LiBaoZhengCache/LiBaoZhengCacheSQLite/ClassName/ClassName_CacheData.sqlite)
    NSString *cachefullPath = [ZhengCacheDirectory cacheFullPathWithDirectory:NSStringFromClass(ClassName) cacheMethod:CacheMethodSQLite];
    
    self.myDataBase = [FMDatabase databaseWithPath:cachefullPath];
    
    if ([self.myDataBase open]) {   //数据库打开成功
        
        // 创表  字段   id  dict_ID  my_respose_dict
        NSString *creatTableStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT,%@ text NOT NULL,%@ blob NOT NULL);",SQTableName,SQDicID,SQDicFiledName];
        BOOL result = [self.myDataBase executeUpdate:creatTableStr];
        
        if (result) {      //创表成功
            for (NSDictionary *dic in cacheArray) {
                //取出字典唯一ID
                NSString *dicID = [NSString stringWithFormat:@"%@",dic[EachInfoID]];
                // 把cacheDic字典对象序列化成NSData二进制数据  存储数据库
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
                
                //插入数据之前先查询数据库有没有该条信息
                FMResultSet *resultSet = nil;
                NSString *selectStr = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = %@;",SQTableName,SQDicID,dicID];
                resultSet = [self.myDataBase executeQuery:selectStr];
                
                if (resultSet.next == NO) {  //插入数据
                    
                    [self.myDataBase executeUpdate:@"INSERT INTO t_myTable (my_respose_dict,dict_ID) VALUES (?, ?);", data,dicID];
                    
                }else{  //更新数据
                    [self.myDataBase executeUpdate:@"UPDATE t_myTable set my_respose_dict = ? where dict_ID = ?;", data,dicID];
                }
            }
            return [self.myDataBase close];
        } else {  //创表失败
            return NO;
        }
    }else{   //数据库打开失败
        return NO;
    }
}

//读取数据库
- (NSArray *)readArrayClass:(Class)ClassName parameters:(NSDictionary *)parameters{
    
    //缓存完整路径  数据库文件用不到page字段
    //  (Library/Caches/LiBaoZhengCache/LiBaoZhengCacheSQLite/ClassName/ClassName_CacheData.sqlite)
    NSString *cachefullPath = [ZhengCacheDirectory cacheFullPathWithDirectory:NSStringFromClass(ClassName) cacheMethod:CacheMethodSQLite];
    
    //不存在文件直接返回空
    if (![ZhengCacheDirectory fileIsExistsAtPath:cachefullPath]){
        return nil;
    }
    
    //设置页码 默认为1
    NSString *pageStr = [NSString stringWithFormat:@"%@",parameters[ParameterPageFiled]];
    NSInteger page = ((pageStr == nil || pageStr.integerValue <= 1) ? 1 : pageStr.integerValue);
    //限制条数  默认为10
    NSString *limitStr = [NSString stringWithFormat:@"%@",parameters[ParameterLimitFiled]];
    NSInteger limit = ((limitStr == nil) ? 10 : limitStr.integerValue);
    
    self.myDataBase = [FMDatabase databaseWithPath:cachefullPath];
    
    if ([self.myDataBase open]) {
        //查询数据
        NSMutableArray *statuses = [NSMutableArray array];
        // 根据请求参数查询数据
        FMResultSet *resultSet = nil;
        NSString *selectStr = [NSString stringWithFormat:@"SELECT * FROM %@ order by %@ desc limit %ld, %ld;",SQTableName,SQDicID,limit * (page - 1),limit];
        resultSet = [self.myDataBase executeQuery:selectStr];
        
        // 遍历查询结果
        while (resultSet.next) {
            NSData *dictData = [resultSet objectForColumnName:SQDicFiledName];
            NSDictionary *getDict = [NSKeyedUnarchiver unarchiveObjectWithData:dictData];
            [statuses addObject:getDict];
        }
        if (statuses == nil || statuses.count == 0) {
            return nil;
        }else{
            return statuses;
        }
    }
    return nil;
}

// 单例
static id _instance;
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)shareCacheSQLite{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return _instance;
}

@end
