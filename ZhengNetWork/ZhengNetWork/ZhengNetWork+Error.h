//
//  ZhengNetWork+Error.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengNetWork.h"

@interface ZhengNetWork (Error)

/** 判断请求地址是否为空 */
+ (NSError *)checkUrlStr:(NSString *)urlStr;

@end
