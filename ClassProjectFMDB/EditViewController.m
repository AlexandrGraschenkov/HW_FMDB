//
//  EditViewController.m
//  ClassProjectFMDB
//
//  Created by Артур Сагидулин on 30.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "EditViewController.h"
#import "DatabaseManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FMDB.h>

@interface EditViewController ()
@property (nonatomic) FruitModel *fruit;
@property (nonatomic) FMDatabase *db;
@end

@implementation EditViewController

-(id)initWithNibName:(NSString *)nibName withBundle:(NSBundle *)bundle withFruit:(FruitModel*)fruit{
    self= [self initWithNibName:nibName bundle:bundle];
    _fruit = fruit;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setComponents];
    [self setView];
}

-(void)setComponents{
    _name.borderStyle=UITextBorderStyleRoundedRect;
    _name.returnKeyType = UIReturnKeyDone;
    _name.clearButtonMode = UITextFieldViewModeWhileEditing;
    _name.delegate = self;
    _descript.delegate = self;
    _descript.allowsEditingTextAttributes = YES;
    
}

-(void)setView{
    [_name setText:_fruit.name];
    [_descript setText:_fruit.descript];
    [_image sd_setImageWithURL:_fruit.imageURL];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) [textView resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    _fruit.descript = _descript.text;
    _fruit.name = _name.text;
    [[DatabaseManager shared] saveModel:_fruit];
}

@end
