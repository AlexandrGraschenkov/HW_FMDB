//
//  FruitModel.h
//  Test_FMDB
//
//  Created by Alexander on 11.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface FruitModel : NSObject

- (id)initWithFMDBSet:(FMResultSet *)set;

@property (nonatomic, readonly) NSInteger fruitId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSURL *thumbURL;
@property (nonatomic, strong) NSString *descriptionA;

@end
