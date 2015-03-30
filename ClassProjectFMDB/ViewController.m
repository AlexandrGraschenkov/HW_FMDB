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
    
}

@end

@implementation ViewController
@synthesize delegate;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _path = indexPath;
    [self newView:indexPath.row];
}


- (void)newView:(NSInteger)row
{
    screenSize = [self.view frame].size;
    NSLog(@"Screen Size W=%f  H=%f", screenSize.width,screenSize.height);
    table = self.tableView;
    CGSize barSize = self.navigationController.navigationBar.frame.size;
    screenSize.height-=barSize.height;
    scrollPostion = [table contentOffset];
    scrollPostion.x += screenSize.width/2;
    scrollPostion.y += (screenSize.height/2)+barSize.height;
    CGRect hiddenPosition = CGRectMake(scrollPostion.x+screenSize.width, scrollPostion.y+screenSize.height, screenSize.width, screenSize.height);
    editController = [[EditViewController alloc] initWithNibName:@"EditViewController" withBundle:[NSBundle mainBundle] withFruit:[fruits objectAtIndex:row] andFrame:hiddenPosition];
    edit = editController.view;
    [edit addSubview:[self createButton]];
    [self.view addSubview:edit];

    [self setScrollable];
    NSLog(@"SLIDED VIEW W=%f  H=%f",screenSize.width,screenSize.height);
    [UIView animateWithDuration:1.0
                    animations:^{
                        edit.center = scrollPostion;
                        
    }];
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
    [editController performSelectorOnMainThread:@selector(saveChanges) withObject:nil waitUntilDone:YES];
    CGRect was = edit.frame;
    CGPoint origin = was.origin;
    [UIView animateWithDuration:1.0
                     animations:^{
                         edit.frame = CGRectMake(origin.x+screenSize.width, origin.y-screenSize.height, screenSize.width, screenSize.height);
                     } completion:^(BOOL finished) {
                         [edit setAlpha:0];
                         [edit removeFromSuperview];
    }];
    editController=nil;
    edit=nil;
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:_path, nil];
    [table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];

    [self setScrollable];
    //[self reloadData];
}

-(void)setScrollable{
    [table setScrollEnabled:![table isScrollEnabled]];
}


@end
