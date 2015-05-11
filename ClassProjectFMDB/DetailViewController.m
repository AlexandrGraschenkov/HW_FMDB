//
//  DetailViewController.m
//  ClassProjectFMDB
//
//  Created by Евгений Сергеев on 09.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fruitText;
@property (weak, nonatomic) IBOutlet UITextView *fruitDescription;
@property (weak, nonatomic) IBOutlet UIImageView *fruitImg;
@property (weak, nonatomic) IBOutlet UIButton *toChange;

@end

@implementation DetailViewController
- (IBAction)toDoChange:(UIButton *)sender {
    
    NSString *nameFruit = self.fruitText.text;
    NSString *descriptionFruit = self.fruitDescription.text;
    self.fruit.name = nameFruit;
    self.fruit.descript = descriptionFruit;
    [[DatabaseManager shared] updateFruit:self.fruit completion:^{
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fruitText.text = self.fruit.name;
    self.fruitDescription.text = self.fruit.descript;
    [self.fruitImg sd_setImageWithURL:self.fruit.imageURL];
    
    
}

@end

