//
//  NSString+Extension.h
//  ZhengNetWork
//
//  Created by 李保征 on 2016/12/6.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

@end

@interface NSString (isValue)

- (BOOL)isValue;

@end

@interface NSString (Hash)

@property (nonatomic,copy,readonly) NSString *md5String;
@property (nonatomic,copy,readonly) NSString *sha1String;
@property (nonatomic,copy,readonly) NSString *sha256String;
@property (nonatomic,copy,readonly) NSString *sha512String;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

@end
