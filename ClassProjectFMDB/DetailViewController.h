//
//  DetailViewController.h
//  ClassProjectFMDB
//
//  Created by Евгений Сергеев on 26.05.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FruitModel.h"
#import "DatabaseManager.h"

@interface DetailViewController : UIViewController
@property (nonatomic, strong) FruitModel *fruit;
@end
