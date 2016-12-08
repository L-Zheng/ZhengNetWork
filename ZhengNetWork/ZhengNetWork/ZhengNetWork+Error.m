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

+ (NSError *)checkRequest:(ZhengBaseRequest *)zhengBaseRequest{
    
    NSString *urlStr = zhengBaseRequest.urlStr;
    BOOL isEnableHTTPS = zhengBaseRequest.isEnableHTTPS;
    
    NSError *myError = nil;
    
    if ([urlStr isValue]){ //链接是否有值
        NSURL *url = [NSURL URLWithString:urlStr];
        
        if ([url.scheme isValue]) {//链接scheme是否有值
            
            if (isEnableHTTPS) { //是否启用HTTPS
                NSString *schemeStrUp = [url.scheme uppercaseString];
                
                if ([schemeStrUp isEqualToString:@"HTTP"]) {
                    myError = [NSError errorWithDomain:@"请求链接要求HTTPS" code:404 userInfo:nil];
                }
            }
        } else {
            myError = [NSError errorWithDomain:@"请求链接scheme为空" code:404 userInfo:nil];
        }
    }else{
        myError = [NSError errorWithDomain:@"请求链接为空" code:404 userInfo:nil];
    }
    
    return myError;
}
@end
