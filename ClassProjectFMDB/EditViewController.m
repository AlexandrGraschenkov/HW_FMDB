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

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



-(id)initWithNibName:(NSString *)nibName withBundle:(NSBundle *)bundle withFruit:(FruitModel*)fruit andFrame:(CGRect)frame{
    self= [self initWithNibName:nibName bundle:bundle];
    _fruit = fruit;
    _frame = &frame;
    _screenSize = frame.size;
    [self.view setFrame:frame];
    [self setComponents];
    [self setView];
    NSLog(@"W=%f  H=%f", self.view.frame.size.width,self.view.frame.size.height);
    return self;
}
-(void)setComponents{
    _name.borderStyle=UITextBorderStyleRoundedRect;
    _name.returnKeyType = UIReturnKeyDone;
    _name.clearButtonMode = UITextFieldViewModeWhileEditing;
    _name.delegate = self;
    _descript.allowsEditingTextAttributes = YES;
    _descript.delegate = self;
}

-(void)setView{
    [_name setText:_fruit.name];
    [_descript setText:_fruit.descript];
    [_image sd_setImageWithURL:_fruit.imageURL];
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    _fruit.descript = [textView text];
}
- (IBAction)fieldEnd:(id)sender {
    _fruit.name = [sender text];
}
-(void)saveChanges{
    [[DatabaseManager shared] saveModel:_fruit];
    NSLog(@"%@", @"saved");
}

- (void)dealloc {
    [self saveChanges];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
