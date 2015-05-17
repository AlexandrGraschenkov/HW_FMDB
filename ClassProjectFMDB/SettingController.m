//
//  SettingController.m
//  ClassProjectFMDB
//
//  Created by Admin on 22.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "SettingController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SettingController ()
@property (weak, nonatomic) IBOutlet UITextField *fruitText;
@property (weak, nonatomic) IBOutlet UITextView *fruitDescription;
@property (weak, nonatomic) IBOutlet UIImageView *fruitImg;
@property (weak, nonatomic) IBOutlet UIButton *toChange;

@end

@implementation SettingController
- (IBAction)toDoChange:(UIButton *)sender {
    
    NSString *nameFruit = self.fruitText.text;
    NSString *descriptionFruit = self.fruitDescription.text;
    self.fruit.name = nameFruit;
    self.fruit.descriptionA = descriptionFruit;
    [[DatabaseManager shared] updateFruit:self.fruit completion:^{
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fruitText.text = self.fruit.name;
    self.fruitDescription.text = self.fruit.descriptionA;
    [self.fruitImg sd_setImageWithURL:self.fruit.imageURL];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    NSString *nameFruit = self.fruitText.text;
    NSString *descriptionFruit = self.fruitDescription.text;
    self.fruit.name = nameFruit;
    self.fruit.descriptionA = descriptionFruit;
    [[DatabaseManager shared] updateFruit:self.fruit completion:^{
    }];
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
