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
    NSIndexPath *path;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!fruits) {
        [self reloadData];
    }else{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

- (void)reloadData {
    self.navigationItem.backBarButtonItem.enabled = false;
    [[DatabaseManager shared] getFruitsArrayWithLimit:10 offset:0 completion:^(DBResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fruits = [res objects];
            totalCount = [res totalCount];
            [self.tableView reloadData];
        });
    }];
}

- (void)loadMore {
    if (totalCount == fruits.count) return;
    
    [[DatabaseManager shared] getFruitsArrayWithLimit:10 offset:0 completion:^(DBResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fruits = [fruits arrayByAddingObjectsFromArray:res.objects];
            totalCount = [res totalCount];
            [self.tableView reloadData];
        });
    }];
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
         path = indexPath;
    }
}

@end
