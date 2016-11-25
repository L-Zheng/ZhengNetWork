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
    
#warning  使用时注意 请求参数中的字段是否对应  ParameterFieldConst.m
    [self requestJsonDicData];
    
//    [self requestJsonArrayData];
    
//    [self requestPageDataSQLite];
    
//    [self requestPageDataCoding];
}

#warning 请求数据（带有缓存）  不是分页数据  单纯Json字典或者数组   只能用Coding
- (void)requestJsonDicData{
    
    NSString *url = @"https://itunes.apple.com/lookup";
    NSDictionary *dic = @{@"id":@"444934666"};
    
    //读取缓存    请求的数据是个字典  读取缓存获得的是个对应的模型
    //  如果请求的数据是个数组  数组里面是字典  返回的数据是个数组模型
    id readJson = [ZhengCacheTool readJsonClass:[JsonDicModel class] parameters:dic cacheMethod:CacheMethodCoding];
    NSLog(@"--------------cache----------------------");
    NSLog(@"%@",readJson);
//    JsonDicModel *jsonDicModel = (JsonDicModel *)readJson;
//    NSLog(@"--------------cache----------------------");
//    NSLog(@"%@",jsonDicModel.mj_keyValues);
    
    //请求数据
    [ZhengHttpCacheTool postRequestJsonUrlStr:url parameters:dic class:[JsonDicModel class] cacheMethod:CacheMethodCoding success:^(id responseModel) {
        JsonDicModel *jsonDicModel = (JsonDicModel *)responseModel;
        NSLog(@"--------------success----------------------");
        NSLog(@"%@",jsonDicModel.mj_keyValues);
        
    } failure:^(NSError *error) {
        NSLog(@"--------------failure----------------------");
    }];
}

- (void)requestJsonArrayData{
    
    NSString *url = @"https://itunes.apple.com/lookup";
    NSDictionary *dic = @{@"id":@"444934666"};
    
    //读取缓存    请求的数据是个字典  读取缓存获得的是个对应的模型
    //  如果请求的数据是个数组  数组里面是字典  返回的数据是个数组模型
    id readJson = [ZhengCacheTool readJsonClass:[JsonArrayModel class] parameters:dic cacheMethod:CacheMethodCoding];
    NSLog(@"--------------cache----------------------");
    NSLog(@"%@",readJson);
    
//    NSArray *arrayModel = (NSArray *)readJson;
//    NSLog(@"--------------cache----------------------");
//    for (JsonArrayModel *tempModel in arrayModel) {
//        NSLog(@"%@",tempModel.mj_keyValues);
//    }
    
    //请求数据
    [ZhengHttpCacheTool postRequestJsonUrlStr:url parameters:dic class:[JsonArrayModel class] cacheMethod:CacheMethodCoding success:^(id responseModel) {
        NSArray *arrayModel = (NSArray *)responseModel;
        NSLog(@"--------------success----------------------");
        for (JsonArrayModel *tempModel in arrayModel) {
            NSLog(@"%@",tempModel.mj_keyValues);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"--------------failure----------------------");
    }];
}

#warning 缓存读取方法 列表数据（数据类型数组） 最好用SQLite也可用Coding
- (void)requestPageDataSQLite{
    
//    http://api.goldtoutiao.com:80/v2/mobile-articles?limit=5&device=ios&channel=global-carousel&page=1
    
    NSString *url = @"http://api.goldtoutiao.com/v2/mobile-articles";
    NSDictionary *dic = @{@"limit":@"1",@"device":@"ios",@"channel":@"global-carouse",@"page":@"1"};
    
    //读取缓存
    NSArray *cacheArray = [ZhengCacheTool readArrayFromClass:[PageModel class] parameters:dic cacheMethod:CacheMethodSQLite];
    NSLog(@"--------------cache----------------------");
    NSLog(@"%@",cacheArray);
//    for (id model in cacheArrayModel) {
//        PageModel *myModel = (PageModel *)model;
//        NSLog(@"%@",myModel.mj_keyValues);
//    }
    
    //请求数据
    [ZhengHttpCacheTool getRequestListUrlStr:url parameters:dic cacheArrayField:@"results" class:[PageModel class] cacheMethod:CacheMethodSQLite success:^(id responseModelArray) {
        NSLog(@"--------------success----------------------");
        for (id model in responseModelArray) {
            PageModel *myModel = (PageModel *)model;
            NSLog(@"%@",myModel.mj_keyValues);
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"--------------failure----------------------");
    }];
    
}

- (void)requestPageDataCoding{
    
    //    http://api.goldtoutiao.com:80/v2/mobile-articles?limit=5&device=ios&channel=global-carousel&page=1
    
    NSString *url = @"http://api.goldtoutiao.com/v2/mobile-articles";
    NSDictionary *dic = @{@"limit":@"4",@"device":@"ios",@"channel":@"global-carouse",@"page":@"1"};
    
    //读取缓存
    NSArray *cacheArray = [ZhengCacheTool readArrayFromClass:[PageModel class] parameters:dic cacheMethod:CacheMethodCoding];
    NSLog(@"--------------cache----------------------");
    NSLog(@"%@",cacheArray);
//    for (id model in cacheArrayModel) {
//        PageModel *myModel = (PageModel *)model;
//        NSLog(@"%@",myModel.mj_keyValues);
//    }
    
    //请求数据
    
    [ZhengHttpCacheTool getRequestListUrlStr:url parameters:dic cacheArrayField:@"results" class:[PageModel class] cacheMethod:CacheMethodCoding success:^(id responseModelArray) {
        NSLog(@"--------------success----------------------");
        for (id model in responseModelArray) {
            PageModel *myModel = (PageModel *)model;
            NSLog(@"%@",myModel.mj_keyValues);
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"--------------failure----------------------");
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
