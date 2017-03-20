//
//  ZhengImageUploadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2017/3/20.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZhengBaseProcessRequest.h"

@interface ZhengImageUploadRequest : ZhengBaseProcessRequest

@property (nonatomic, nonnull, retain) NSMutableArray *imageArray;

@property (nonatomic ,nonnull, strong) NSDictionary *parameters;

//可传(单纯文件上传暂时不需要) @"image/jpeg"
@property (nonatomic, nullable, copy, readonly) NSString *mimeType;

@end
