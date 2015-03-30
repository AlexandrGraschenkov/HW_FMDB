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

@interface EditViewController : UIViewController <UITextViewDelegate, editDelegate>
{
    ViewController *controller;
}

@property (nonatomic) IBOutlet UITextField *name;
@property (nonatomic) IBOutlet UITextView *descript;
@property (nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) CGSize screenSize;
@property (nonatomic) FruitModel *fruit;
@property (nonatomic) FMDatabase *db;
@property (nonatomic) CGRect *frame;

- (IBAction)fieldEnd:(id)sender;
-(id)initWithNibName:(NSString *)nibName withBundle:(NSBundle *)bundle withFruit:(FruitModel*)fruit andFrame:(CGRect)frame;

-(void)saveChanges;
@end
