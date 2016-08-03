//
//  ViewController.m
//  MultithreadFinder
//
//  Created by Ray on 2016/7/6.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "ViewController.h"
#import "Finder.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testFindObj];//有找到
    
    [self testNotfoundObj];//沒找到
}

-(void)testFindObj{
    NSArray *ary = [self getTestSource];
    
    Finder *finder = [[Finder alloc]initWithExecutorsCount:5];
    BOOL ret = [finder execute:ary withBlock:^BOOL(NSUInteger idx, NSString *findObj) {
        //        NSLog(@"%@", findObj);
        
        if([findObj isEqualToString:@"500"]){
            NSLog(@"找到我要的物件,index[%d]",idx);
            return YES;
        }
        return NO;
    }];
    NSLog(@"是否有找到[%@]", ret ? @"true" : @"false");
}

-(void)testNotfoundObj{
    NSArray *ary = [self getTestSource];
    
    Finder *finder = [[Finder alloc]initWithExecutorsCount:5];
    BOOL ret = [finder execute:ary withBlock:^BOOL(NSUInteger idx, NSString *findObj) {
        //        NSLog(@"%@", findObj);
        
        if([findObj isEqualToString:@"4000"]){
            NSLog(@"找到我要的物件,index[%d]",idx);
            return YES;
        }
        return NO;
    }];
    NSLog(@"是否有找到[%@]", ret ? @"true" : @"false");
}

- (NSArray *)getTestSource{
    NSMutableArray *ary = [NSMutableArray new];
    
    for(int i = 0; i <= 4; i++){
        [ary addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    return ary;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
