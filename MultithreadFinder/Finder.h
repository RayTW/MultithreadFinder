//
//  Finder.h
//  MultithreadFinder
//
//  Created by Ray on 2016/7/6.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Finder : NSObject

-(instancetype)initWithExecutorsCount:(NSInteger)count;

-(BOOL)execute:(NSArray *)source withBlock:(BOOL (^)(NSUInteger idx, id findObj))block;
@end
