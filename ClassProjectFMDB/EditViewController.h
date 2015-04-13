//
//  EditViewController.h
//  ClassProjectFMDB
//
//  Created by Артур Сагидулин on 30.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FruitModel.h"
#import "ViewController.h"

@interface EditViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>
{
    ViewController *controller;
}

@property (nonatomic) IBOutlet UITextField *name;
@property (nonatomic) IBOutlet UITextView *descript;
@property (nonatomic) IBOutlet UIImageView *image;


-(id)initWithNibName:(NSString *)nibName withBundle:(NSBundle *)bundle withFruit:(FruitModel*)fruit;

@end
