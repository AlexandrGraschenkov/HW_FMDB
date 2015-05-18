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
#import "EditViewController.h"

@interface ViewController ()
{
    NSArray *fruits;
    NSInteger totalCount;
    UIView *edit;
    UIViewController *editController;
    UIButton *closeButton;
    UITableView *table;
    CGPoint scrollPostion;
    CGSize screenSize;
    NSIndexPath *tempPath;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!fruits) {
        [self reloadData];
    }
}

- (void)reloadData {
    [[DatabaseManager shared] getFruitsArrayWithLimit:10 offset:0 withBlock:^(DBResult *res) {
        dispatch_async(dispatch_get_main_queue(), ^{
            fruits = [res objects];
            totalCount = [res totalCount];
            [self.tableView reloadData];
        });
    }];
}

- (void)loadMore {
    if (totalCount == fruits.count) return;
    [[DatabaseManager shared] getFruitsArrayWithLimit:10 offset:0 withBlock:^(DBResult *res) {
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self newView:indexPath.row];
    tempPath = indexPath;
}


- (void)newView:(NSInteger)row
{
    screenSize = [self.view frame].size;
    table = self.tableView;
    [self setScrollable];
    editController = [[EditViewController alloc] initWithNibName:@"EditViewController" withBundle:[NSBundle mainBundle] withFruit:[fruits objectAtIndex:row]];
    edit = editController.view;
    [edit addSubview:[self createButton]];
    [self presentViewController:editController animated:YES completion:nil];
}

-(UIButton*)createButton{
    closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [closeButton addTarget:self
                    action:@selector(closeEdit:)
          forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(10, 25, 48, 48);
    UIImage *butt = [UIImage imageNamed:@"Close5"];
    [closeButton setBackgroundImage:butt forState:UIControlStateNormal];
    return closeButton;
}

-(IBAction)closeEdit:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [self setScrollable];
        [self reloadCell];
    }];
}

-(void)setScrollable{
    [table setScrollEnabled:![table isScrollEnabled]];
}
-(void)reloadCell{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:tempPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    tempPath = nil;
}


@end
