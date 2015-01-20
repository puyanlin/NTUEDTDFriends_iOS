//
//  VoteValidationCell.h
//  friends
//
//  Created by Patrick@fuhu on 1/20/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ValidState{
    stateNormal,
    stateChecking,
    stateError,
    stateCorrect,
    stateCount,
}ValidState;

@interface VoteValidationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *txtfieldSeriel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorCheckSerial;

@end
