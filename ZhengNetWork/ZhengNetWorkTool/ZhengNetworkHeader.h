//
//  ZhengNetworkHeader.h
//  AFN封装使用
//
//  Created by 李保征 on 16/8/3.
//  Copyright © 2016年 李保征. All rights reserved.
//

#ifndef ZhengNetworkHeader_h
#define ZhengNetworkHeader_h

/** 网络缓存请求        ----请求的数据需要缓存   时使用
    读取本地缓存    ----->  返回数据模型
 */
#import "ZhengHttpCacheTool.h"

/** 网络请求           ----请求的数据不需要缓存，单纯请求 时使用  */
#import "ZhengHttpTool.h"

/** 缓存工具           ----读取本地缓存       时使用  --- > 返回Json源数据 */
#import "ZhengCacheTool.h"

/** 缓存目录管理        ----管理本地缓存       时使用  */
#import "ZhengCacheDirectory.h"

#endif /* ZhengNetworkHeader_h */
