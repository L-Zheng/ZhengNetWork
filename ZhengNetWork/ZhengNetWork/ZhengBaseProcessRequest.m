//
//  ZhengBaseProcessRequest.m
//  ZhengNetWork
//
//  Created by 李保征 on 2017/3/20.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZhengBaseProcessRequest.h"

@implementation ZhengBaseProcessRequest

- (void)resume{
    if (self.currentTask) {
        if (self.currentTask.state == NSURLSessionTaskStateRunning) {
            return;
        } else{
            [self.currentTask resume];
        }
    }
}

- (void)suspend{
    if (self.currentTask) {
        if (self.currentTask.state == NSURLSessionTaskStateSuspended) {
            return;
        } else{
            [self.currentTask suspend];
        }
    }
}

- (void)cancel{
    if (self.currentTask) {
        if (self.currentTask.state == NSURLSessionTaskStateCanceling) {
            return;
        } else{
            [self.currentTask cancel];
        }
    }
}

@end
