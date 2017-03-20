//
//  ZhengDownloadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/7.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengBaseProcessRequest.h"

@interface ZhengDownloadRequest : ZhengBaseProcessRequest

/** 下载目录 */
@property (nonatomic, nonnull, strong) NSURL *targetDirectoryURL;

@end
