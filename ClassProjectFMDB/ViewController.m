//
//  ViewController.m
//  ClassProjectFMDB
//
//  Created by Alexander on 12.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "FruitCell.h"
#import "DatabaseManager.h"
#import "FruitModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SettingController.h"

@interface ViewController ()
{
    NSArray *fruits;
    NSInteger totalCount;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!fruits) {
        [self reloadData];
    }
}

- (void)reloadData {
    DBResult *result = [[DatabaseManager shared] getFruitsArrayWithLimit:10 offset:0];
    fruits = result.objects;
    totalCount = result.totalCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)loadMore {
    if (totalCount == fruits.count) return;
    
    DBResult *result = [[DatabaseManager shared] getFruitsArrayWithLimit:10 offset:0];
    fruits = [fruits arrayByAddingObjectsFromArray:result.objects];
    totalCount = result.totalCount;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalCount;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FruitModel *fruit = fruits[indexPath.row];
    FruitCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FruitCell"];
    
    cell.nameLabel.text = fruit.name;
    [cell.fruitImageView sd_setImageWithURL:fruit.thumbURL];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == fruits.count - 1) {
        [self loadMore];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"push"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SettingController *setting = segue.destinationViewController;
        FruitModel *fruit = fruits[indexPath.row];
        setting.fruit = fruit;
    }
}

@end
