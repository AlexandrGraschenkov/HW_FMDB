//
//  ViewController.h
//  ClassProjectFMDB
//
//  Created by Alexander on 12.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editDelegate;

@interface ViewController : UITableViewController{
    id<editDelegate> delegate;
}
@property (retain) id delegate;
@property (nonatomic) NSIndexPath *path;
-(void)setScrollable;
-(void)delegateClose;
@end

@protocol editDelegate
@required
-(void)saveChanges;

@end
