//
//  ZhengMultiUploadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/8.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengBaseProcessRequest.h"

@interface ZhengMultiUploadRequest : ZhengBaseProcessRequest

@property (nonatomic, nonnull, copy) NSString *upLoadFilePath;

//可传(单纯文件上传暂时不需要) @"image/jpeg"
@property (nonatomic, nullable, copy) NSString *mimeType;

@property (nonatomic ,nonnull, strong) NSDictionary *parameters;

@property (nonatomic, nullable, copy) NSString *fileName;

@end
