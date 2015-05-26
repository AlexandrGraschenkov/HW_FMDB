//
//  DetailViewController.m
//  ClassProjectFMDB
//
//  Created by Евгений Сергеев on 26.05.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fruitName;
@property (weak, nonatomic) IBOutlet UITextView *fruitDescript;
@property (weak, nonatomic) IBOutlet UIImageView *fruitImage;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fruitName.text = self.fruit.name;
    self.fruitDescript.text = self.fruit.descript;
    [self.fruitImage sd_setImageWithURL:self.fruit.imageURL];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSString *nameFruit = self.fruitName.text;
    NSString *descriptFruit = self.fruitDescript.text;
    self.fruit.name = nameFruit;
    self.fruit.descript = descriptFruit;
    
    [[DatabaseManager shared] saveChanges:self.fruit completion:^{ }];
}

@end
