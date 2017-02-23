//
//  ViewController.m
//  AFN封装使用
//
//  Created by 李保征 on 16/7/12.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ViewController.h"

#import "ZhengNetworkHeader.h"


#import "MJExtension.h"
#import "JsonDicModel.h"
#import "JsonArrayModel.h"
#import "PageModel.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self test];
    
        [self requestJsonDicDataNoCache];
    //    [self requestListPageDataNoCache];
    
//    [self requestJsonDicDataCache];
//            [self requestListPageDataCache];
    
//    [self downloadFile];
    
//    [self uploadFile];
}


- (void)test{
    ZhengRequest *request = [[ZhengRequest alloc] init];
    request.urlStr = @"http://139.196.20.6:10001/notify/config/update";
    request.requestType = RequestType_Post;
    
    request.parameters = @{
                           @"announce_flag" : @"0",
                           @"decline_limit" : @"1111111.00",
                           @"decline_limit_switch" : @"1",
                           @"frequency" : @"2",
                           @"pcp_limit" : @"1.200000",
                           @"pcp_limit_switch" : @"1",
                           @"raise_limit" : @"2222222.00",
                           @"raise_limit_switch" : @"1",
                           @"recent_day_high_price" : @"3258.26",
                           @"recent_day_low_price" : @"3094.01",
                           @"recent_high_price_day" : @"20",
                           @"recent_low_price_day" : @"20",
                           @"report_flag" : @"0",
                           @"symbol" : @"000001.SS",
                           };
    request.cacheMethod = CacheMethod_NoCache;
    request.header = @{
                       @"X-Ivanka-App":@"wscn|iOS|5.0.3|10.2|0",
                       @"host":@"139.196.20.6",
                       @"X-Ivanka-Token":@"i8B0IO/Rf/E9bUl6jnE0gH9H6rNeyu2vQx1uYG6WN4EaN54jF7QmPow2Z8DOMnsTfmVToke8s7X6G1xHz/+NFLMQ/aeAoZU/MzhGR33Vqrrz9+ko/Gop4nXsvY0xXBRftSJUmql07UVIegk1omqShJiy7Dj1wtwEx8UR56jvhzXDWF9FZOobYI4YalVkxKtR"
                       };
    
    [ZhengNetWork sendRequest:request success:^(id responseObject ,id modelObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%ld",request.requestStatus);
    } failure:^(NSError *error) {
        NSLog(@"--------------------");
    }];
}

- (void)requestJsonDicDataNoCache{
    ZhengRequest *zhengRequest = [[ZhengRequest alloc] init];
//    zhengRequest.enableHTTPS = YES;
//    zhengRequest.baseUrlStr = @"https://";
    zhengRequest.urlStr = @"https://itunes.apple.com/lookup";
//    zhengRequest.urlStr = @"itunes.apple.com/lookup";
    zhengRequest.parameters = @{@"id":@"444934666"};
    zhengRequest.cacheMethod = CacheMethod_Coding;
    
    [ZhengNetWork sendRequest:zhengRequest success:^(id responseObject ,NSMutableArray *modelArray) {
        NSLog(@"%@",responseObject);
        NSLog(@"%ld",zhengRequest.requestStatus);
    } failure:^(NSError *error) {
        NSLog(@"--------------------");
    }];
    //不可连用  一个请求一个状态
    //    [ZhengNetWork sendRequest:zhengRequest success:^(id responseObject) {
    //        NSLog(@"%@",responseObject);
    //        NSLog(@"%ld",zhengRequest.requestStatus);
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    //    [zhengRequest stopRequest];
    //    NSLog(@"%ld",zhengRequest.requestStatus);
}

- (void)requestListPageDataNoCache{
    ZhengPageRequest *zhengPageRequest = [[ZhengPageRequest alloc] init];
    zhengPageRequest.urlStr = @"http://api.goldtoutiao.com/v2/livenews";
    zhengPageRequest.page = 1;
    zhengPageRequest.limit = @(2);
    
    [ZhengNetWork sendRequest:zhengPageRequest success:^(id responseObject ,NSMutableArray *modelArray) {
        NSLog(@"%@",responseObject);
        NSLog(@"%ld",zhengPageRequest.requestStatus);
    } failure:^(NSError *error) {
        
    }];
    //    [zhengRequest stopRequest];
    //    NSLog(@"%ld",zhengRequest.requestStatus);
    //    NSLog(@"--------------------");
}

- (void)requestJsonDicDataCache{
    
    
    ZhengRequest *zhengRequest = [[ZhengRequest alloc] init];
    zhengRequest.urlStr = @"https://itunes.apple.com/lookup";
    zhengRequest.parameters = @{@"id":@"444934666"};
    zhengRequest.cacheMethod = CacheMethod_Coding;
    zhengRequest.className = [JsonDicModel class];
//    zhengRequest.expiredTime = 58 * 60 * 60;
    //    [ZhengNetWork sendRequest:zhengRequest success:^(id responseObject ,id modelObject) {
    //        NSLog(@"%@",responseObject);
    //        NSLog(@"%ld",zhengRequest.requestStatus);
    //    } failure:^(NSError *error) {
    //
    //    }];
    
    [ZhengNetWork readCacheRequest:zhengRequest cache:^(id responseObject, id modelObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",modelObject);
        NSLog(@"%ld",zhengRequest.requestStatus);
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestListPageDataCache{
    ZhengPageRequest *zhengPageRequest = [[ZhengPageRequest alloc] init];
    zhengPageRequest.urlStr = @"http://api.goldtoutiao.com/v2/livenews";
    zhengPageRequest.page = 1;
    zhengPageRequest.limit = @(2);
    
    zhengPageRequest.cacheMethod = CacheMethod_SQLite;
    
    zhengPageRequest.needJsonField = @"results";
    zhengPageRequest.className = [PageModel class];
    
//        [ZhengNetWork sendRequest:zhengPageRequest success:^(id responseObject ,id modelObject) {
//            NSLog(@"%@",responseObject);
//            NSLog(@"%@",modelObject);
//            NSLog(@"%ld",zhengPageRequest.requestStatus);
//        } failure:^(NSError *error) {
//    
//        }];
    
    [ZhengNetWork readCacheRequest:zhengPageRequest cache:^(id responseObject, id modelObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",modelObject);
        NSLog(@"%ld",zhengPageRequest.requestStatus);
    } failure:^(NSError *error) {
        
    }];
    
    //    [zhengRequest stopRequest];
    //    NSLog(@"%ld",zhengRequest.requestStatus);
    //    NSLog(@"--------------------");
}

- (void)downloadFile{
    
    NSURL *targetDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    ZhengDownloadRequest *zhengDownloadRequest = [[ZhengDownloadRequest alloc] init];
    zhengDownloadRequest.urlStr = @"https://download.alicdn.com/dingtalk-desktop/Release/install/DingTalk_v3.2.0.dmg";
    zhengDownloadRequest.targetDirectoryURL = targetDirectoryURL;
    
    [ZhengNetWork downLoadFileRequst:zhengDownloadRequest progress:^(NSProgress *downloadProgress) {
        
//        NSLog(@"-------%@-----",downloadProgress);
        NSLog(@"----%lld----%lld-",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        NSLog(@"-------%f-----",downloadProgress.fractionCompleted);
//        NSLog(@"%@",zhengDownloadRequest.downloadTask.response.suggestedFilename);//DingTalk_v3.2.0.dmg
//        NSLog(@"%lld",zhengDownloadRequest.downloadTask.response.expectedContentLength);//68656690
//        NSLog(@"--------------------");
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
//        NSLog(@"--------------------");
//        NSLog(@"%lld",response.expectedContentLength);//68656690
//        NSLog(@"%@",response.suggestedFilename);//DingTalk_v3.2.0.dmg
//        NSLog(@"%@",response.textEncodingName);//(null)
//        NSLog(@"%@",response.MIMEType);//application/octet-stream
//        NSLog(@"%@",targetPath);//临时缓存目录
//        NSLog(@"--------------------");
        
        
        //此处检查是否有相同文件（如果知道文件名  在下载前进行检查）
        
        return [zhengDownloadRequest.targetDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"--   %@   --", filePath);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"-----------suspend---------");
        [zhengDownloadRequest suspend];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [zhengDownloadRequest resume];
            NSLog(@"-----------resume---------");
        });
    });
}

- (void)uploadFile{
    ZhengUploadRequest *zhengUploadRequest = [[ZhengUploadRequest alloc] init];
    zhengUploadRequest.urlStr = @"http://example.com/upload";
    zhengUploadRequest.upLoadFilePath = @"file://path/to/image.png";
    
    [ZhengNetWork upLoadFileRequst:zhengUploadRequest progress:^(NSProgress *uploadProgress) {
        NSLog(@"----%lld----%lld-",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        NSLog(@"-------%f-----",uploadProgress.fractionCompleted);
        
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
}

- (void)uploadMultiRequst{
    ZhengMultiUploadRequest *zhengMultiUploadRequest = [[ZhengMultiUploadRequest alloc] init];
    zhengMultiUploadRequest.urlStr = @"http://example.com/upload";
    zhengMultiUploadRequest.upLoadFilePath = @"file://path/to/image.jpg";
    zhengMultiUploadRequest.fileName = @"filename.jpg";
    zhengMultiUploadRequest.parameters = @{};
    zhengMultiUploadRequest.mimeType = @"image/jpeg";
    
    [ZhengNetWork upLoadMultiRequst:zhengMultiUploadRequest multiprogress:^(NSProgress *uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程操作
        });
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
}



@end
