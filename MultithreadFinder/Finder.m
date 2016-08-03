//
//  Finder.m
//  MultithreadFinder
//
//  Created by Ray on 2016/7/6.
//  Copyright © 2016年 Ray. All rights reserved.
//  version
//

#import "Finder.h"

@implementation Finder{
    NSInteger mCount;
}

-(instancetype)initWithExecutorsCount:(NSInteger)count{
    if(self = [super init]){
        mCount = count;
    }
    return self;
}

-(BOOL)execute:(NSArray *)source withBlock:(BOOL (^)(NSUInteger idx, id findObj))block{
    
    __block BOOL isFind = NO;//是否找到物件
    
    NSUInteger count = 0;//找幾次
    NSUInteger n = 1;//每次找幾個
    
    if([source count] > mCount){
        n = [source count] / mCount;
    }else{
        n = [source count];
    }
    
    NSInteger m = [source count] % n;//取要被找的物件個數餘數，若除不盡要多找1次

    if(m > 0){
        count = mCount + 1;
    }else{
        count = mCount;
    }
    
//    NSLog(@"source count[%lu],mCount[%ld]", (unsigned long)[source count], (long)mCount);
//    NSLog(@"每次找幾個:%lu", (unsigned long)n);
//    NSLog(@"找幾次:%lu", (unsigned long)count);
    
    NSUInteger startIndex = 0;//每個job開始找的位置
    NSInteger endIndex = 0;//每個job要停止找的位置
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("finder_execute", DISPATCH_QUEUE_CONCURRENT);
    
    for(NSUInteger i = 0; i < count; i++){
        
        startIndex = i * n;
        endIndex = startIndex + n;
        
        //若此次job找的位置超過最後位置，以最後位置為最大
        if(endIndex > [source count]){
            endIndex = [source count];
        }
        
        //啟動非同步多緒方式比對物件
        dispatch_group_async(group, queue, ^{
            NSIndexSet *myIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, endIndex - startIndex)];
            [source enumerateObjectsAtIndexes:myIndexes options:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *  stop) {
                if(isFind){
                    *stop = YES;
                    return;
                }
                
                if(block(idx, obj)){
                    isFind = YES;
                }
            }];
        });
    }
    
    
    //此機制要讓此function為blocking，等比對有結果才return
    __block BOOL isFinish = NO;
    __block NSCondition *condition = [NSCondition new];
    
    dispatch_group_notify(group, queue, ^{
        [condition lock];
        isFinish = YES;
        [condition signal];
        [condition unlock];
    });
    
    [condition lock];
    if(!isFinish){
        [condition wait];
    }
    [condition unlock];
    
    return isFind;
}
@end
