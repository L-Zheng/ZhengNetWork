//
//  ZhengConvertModelTool.h
//  AFN封装使用
//
//  Created by 李保征 on 16/8/12.
//  Copyright © 2016年 李保征. All rights reserved.
//
//
//  此类隔离MJExtension框架

#import <Foundation/Foundation.h>

@interface ZhengConvertModelTool : NSObject


/**   转换模型  返回数据模型  
      如果是字典 返回单个模型   如果是数组 返回模型数组
 
 @param convertJsonData    转换的元数据  数组或者字典
 @param ClassName   获得Json转成的模型类
 */
+ (id)zhengSourceData:(id)convertJsonData toModel:(Class)ClassName;

@end
