//
//  DatabaseManager.h
//  ClassProjectFMDB
//
//  Created by Alexander on 12.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FruitModel.h"

@interface DBResult : NSObject
@property (nonatomic, readonly) NSArray *objects;
@property (nonatomic, readonly) NSInteger totalCount;
@end


@interface DatabaseManager : NSObject

+ (instancetype)shared;
- (void)migrateDatabaseIfNescessary;

- (NSArray *)getFruitsArray;
- (DBResult *)getFruitsArrayWithLimit:(NSInteger)limit offset:(NSInteger)offset;
-(void)setDb:(FruitModel *)fruit;
@end
