//
//  FruitModel.m
//  Test_FMDB
//
//  Created by Alexander on 11.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "FruitModel.h"

@implementation FruitModel

- (id)initWithFMDBSet:(FMResultSet *)set {
    self = [super init];
    if (self) {
        _fruitId = [set longForColumn:@"id"];
        self.name = [set stringForColumn:@"name"];
        self.thumbURL = [NSURL URLWithString:[set stringForColumn:@"thumb_url"]];
        self.imageURL = [NSURL URLWithString:[set stringForColumn:@"image_url"]];
        self.descriptionA = [set stringForColumn:@"description"];
    }
    return self;
}

@end
