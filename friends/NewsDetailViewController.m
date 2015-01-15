//
//  NewsDetailViewController.m
//  friends
//
//  Created by Puyan on 2015/1/9.
//  Copyright (c) 2015年 FUHU. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnLink;
@property (strong, nonatomic) IBOutlet UITextView *tvContent;


@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *btnLayer = [self.btnLink layer];
    [btnLayer setBorderWidth:0.5f];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:10.0f];
    [btnLayer setBorderColor:[UIColor blackColor].CGColor];
    
    [self.btnLink setHidden:!self.pfObj[@"link"]];
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"NewsDetailViewController";
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString* content= [[self.pfObj objectForKey:@"content"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [self.tvContent setFont:[UIFont systemFontOfSize:20]];
    self.tvContent.text=content;
    [self.tvContent setEditable:FALSE];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openLink:(UIButton *)sender {
    NSURL *urlApp = [NSURL URLWithString:self.pfObj[@"link"]];
    
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:urlApp];
    
    if (isInstalled) {
        [[UIApplication sharedApplication] openURL:urlApp];
    } else {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/facebook"]];
        
    }

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
