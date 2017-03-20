//
//  ZhengUploadRequest.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/8.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengBaseProcessRequest.h"

@interface ZhengUploadRequest : ZhengBaseProcessRequest

@property (nonatomic, nonnull, copy) NSString *upLoadFilePath;

@end
