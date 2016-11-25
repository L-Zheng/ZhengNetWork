//
//  ZhengConvertModelTool.m
//  AFN封装使用
//
//  Created by 李保征 on 16/8/12.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengConvertModelTool.h"
#import "MJExtension.h"

@implementation ZhengConvertModelTool


/**   转换模型  返回数据模型
 如果是字典 返回单个模型   如果是数组 返回模型数组
 */
+ (id)zhengSourceData:(id)convertJsonData toModel:(Class)ClassName{
    
    //1.判断是否为空
    if (convertJsonData == nil || convertJsonData == (id)[NSNull null]) {
        return nil;
    }
    
    //2.转模型处理
    if ([convertJsonData isKindOfClass:[NSArray class]] || [convertJsonData isKindOfClass:[NSMutableArray class]]) {  //Json为数组
        
        NSArray *cacheArray = (NSArray *)convertJsonData;
        
        NSMutableArray *mutableArrayModel = [NSMutableArray array];
        
        for (NSDictionary *dic in cacheArray) {
            id model = [ClassName mj_objectWithKeyValues:dic];
            [mutableArrayModel addObject:model];
        }
        return mutableArrayModel;
        
    }else if ([convertJsonData isKindOfClass:[NSDictionary class]] || [convertJsonData isKindOfClass:[NSMutableDictionary class]]) {  //Json为字典
        NSDictionary *cacheDic = (NSDictionary *)convertJsonData;
        //转模型
        id model = [ClassName mj_objectWithKeyValues:cacheDic];
        return model;
    }else{
        return nil;
    }
}

@end
