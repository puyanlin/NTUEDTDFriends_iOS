//
//  CadidateDetailTableViewController.h
//  friends
//
//  Created by Patrick@fuhu on 1/16/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CadidateDetailTableViewController : UITableViewController

@property (nonatomic,retain) PFObject* cadidateObj;

@end
