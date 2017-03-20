//
//  ZhengFileUploadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2017/3/20.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ZhengBaseProcessRequest.h"

@interface ZhengFileUploadRequest : ZhengBaseProcessRequest

@property (nonatomic, nonnull, copy) NSString *upLoadFilePath;

@property (nonatomic ,nonnull, strong) NSDictionary *parameters;

/** 可传(单纯文件上传暂时不需要) 
    @"image/jpeg"  @"video/mpeg4"
 */
@property (nonatomic, nullable, copy) NSString *mimeType;

@end
