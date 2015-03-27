//
//  editView.m
//  ClassProjectFMDB
//
//  Created by Артур Сагидулин on 26.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "editView.h"
#import "DatabaseManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FMDB.h>

@implementation editView


- (id)initWithInt: (NSInteger)theInt Fruit:(FruitModel*)fruit andFrame: (CGRect)frame{
    _fruit = fruit;
    self = [super initWithFrame: CGRectZero];
    if (!self)
        return nil;
    _screenSize = frame.size;
    [self setFrame:frame];
    [self doInitSetup];
    [self bd:theInt];
    return self;
}

-(void)bd:(NSInteger)theInt{
    [_name setText:_fruit.name];
    [_descript setText:_fruit.descript];
    [_image sd_setImageWithURL:_fruit.imageURL];
}

- (void) doInitSetup;
{
    UIColor *myColor = [UIColor colorWithRed:(222/255.0) green:(222/255.0) blue:(222/255.0) alpha:1];
    [self setBackgroundColor:myColor];
    [self createComponents];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _fruit.name = [textField text];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _fruit.descript = [textView text];
}

-(void)saveChanges{
    [[DatabaseManager shared] saveModel:_fruit];
    NSLog(@"%@", @"saved");
}

//+ (void)performBlock:(void(^)())pBlock
//{
//    pBlock();
//}

- (void)dealloc {
    [self saveChanges];
}
-(void)createComponents{
    CGRect close = CGRectMake(10, 25, 48, 48);
    CGPoint originC=close.origin;
    CGSize sizeC=close.size;
    _name = [UITextField new];
    _descript = [UITextView new];
    _image = [UIImageView new];
    
    [_name setFrame:CGRectMake(originC.x, originC.y+sizeC.height+10,
                               self.frame.size.width-20, 40)];
    _name.borderStyle=UITextBorderStyleRoundedRect;
    _name.returnKeyType = UIReturnKeyDone;
    _name.clearButtonMode = UITextFieldViewModeWhileEditing;
    _name.delegate = self;
    [_name addTarget:self
                  action:@selector(textFieldDidEndEditing:)
        forControlEvents:UIControlEventEditingChanged];
    
    CGPoint originN = _name.frame.origin;
    CGSize sizeN = _name.frame.size;
    
    [_descript setFrame:CGRectMake(originN.x, originN.y+sizeN.height+10,
                                   sizeN.width, 150)];
    _descript.allowsEditingTextAttributes = YES;
    _descript.delegate = self;
    CGPoint originD = _descript.frame.origin;
    CGSize sizeD = _descript.frame.size;
    
    
    [_image setFrame:CGRectMake(originD.x, originD.y+sizeD.height+10,
                                sizeD.width, (_screenSize.height-150-40-48-65) )];
    UIColor *myColor = [UIColor colorWithRed:(242/255.0) green:(242/255.0) blue:(242/255.0) alpha:1];
    [_image setBackgroundColor:myColor];
    
    [self addSubview:_name];
    [self addSubview:_descript];
    [self addSubview:_image];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
