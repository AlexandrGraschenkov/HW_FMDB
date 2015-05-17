//
//  DetailController.h
//  ClassProjectFMDB
//
//  Created by Admin on 17.05.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "FruitModel.h"
#import "DatabaseManager.h"

@interface DetailController : UIViewController
@property(nonatomic, strong) FruitModel *fruit;

@end
