//
//  ZhengNetWork+Error.m
//  ZhengNetWork
//
//  Created by 李保征 on 2016/11/25.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengNetWork+Error.h"
#import "NSString+Extension.h"

@implementation ZhengNetWork (Error)

+ (NSError *)checkUrlStr:(NSString *)urlStr{
    if ([urlStr isValue]){
        return nil;
    }else{
        //失败回调
        NSError *myError = [NSError errorWithDomain:@"请求链接为空" code:404 userInfo:nil];
        return myError;
    }
}

@end
