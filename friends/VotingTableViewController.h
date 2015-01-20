//
//  VotingTableViewController.h
//  friends
//
//  Created by Patrick@fuhu on 1/19/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CIRCLE_NUMERS @[@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨"]
#define VotedKey @"Voted"

@interface VotingTableViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) NSArray* arrayCandidates;

@end
