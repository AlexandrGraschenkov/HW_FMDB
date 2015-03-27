//
//  editView.h
//  ClassProjectFMDB
//
//  Created by Артур Сагидулин on 26.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FruitModel.h"



@interface editView : UIView <UITextFieldDelegate, UITextViewDelegate, editDelegate>{
    ViewController *controller;
    
}

@property (nonatomic) UITextField *name;
@property (nonatomic) UITextView *descript;
@property (nonatomic) UIImageView *image;
@property (nonatomic) CGSize screenSize;
@property (nonatomic) FruitModel *fruit;
@property (nonatomic) FMDatabase *db;

//+ (void)performBlock:(void(^)())pBlock;
- (id)initWithInt: (NSInteger)theInt Fruit:(FruitModel*)fruit andFrame: (CGRect)frame;

@end


