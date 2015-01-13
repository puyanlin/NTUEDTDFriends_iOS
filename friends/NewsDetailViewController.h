//
//  NewsDetailViewController.h
//  friends
//
//  Created by Puyan on 2015/1/9.
//  Copyright (c) 2015年 FUHU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GAI.h"

@interface NewsDetailViewController : GAITrackedViewController
@property (nonatomic,retain) PFObject* pfObj;
@end
