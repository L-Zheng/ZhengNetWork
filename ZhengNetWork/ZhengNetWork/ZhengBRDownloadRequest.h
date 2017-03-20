//
//  ZhengBRDownloadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2017/3/20.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZhengBaseProcessRequest.h"

@interface ZhengBRDownloadRequest : ZhengBaseProcessRequest

/** 目标地址 完整路径 */
@property (nonatomic, nonnull, strong) NSString *targetPath;

/** AFNetworking断点下载（支持离线）需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) long long fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) long long currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle * _Nullable fileHandle;

@end
