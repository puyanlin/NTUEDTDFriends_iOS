//
//  ViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/7/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import <Parse/Parse.h>
#import "MasterViewController.h"
#import "NewsTableViewController.h"
#import "SignUpViewController.h"
#import "DonationTableViewController.h"
#import "RulesTableViewController.h"
#import "PhotoGalleryViewController.h"


@interface MasterViewController ()<SKStoreProductViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *btnGoFB;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (retain,nonatomic) NSArray* arraySubject;
@property (nonatomic,strong) NSMutableArray* arrayPhotoUrls;
//@property (nonatomic,assign) BOOL isURLloaded;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"SubjectCell"];
    
    [self.btnGoFB.layer setCornerRadius:10.0f];
    self.title=@"DTD Alumni";
    
    self.arraySubject=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MainSubject" ofType:@"plist"]];
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"MasterViewController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goFacebook:(UIButton *)sender {
    
    NSURL *urlApp = [NSURL URLWithString:@"fb://profile/207809079397118"];
    
    BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    if (isInstalled) {
        [[UIApplication sharedApplication] openURL:urlApp];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/facebook"]];
        
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arraySubject count];
}
-(NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"歡迎各位在校學弟妹、系友協助維護、增進此系友會App。Source code已於Github上公開，Android與iOS版本並存，歡迎服務系友並添為個人履歷資歷。\n\n美術或資訊技術貢獻皆歡迎交流。";
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* reuseIdentifier=@"SubjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }

    cell.textLabel.text=[self.arraySubject objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    if(indexPath.row==0){
        NewsTableViewController* vc=[[NewsTableViewController alloc] initWithClassName:@"DTDNotification"];
        vc.title=[self.arraySubject objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:TRUE];
    }else if(indexPath.row==1){
        SignUpViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        vc.title=[self.arraySubject objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:TRUE];
    }else if(indexPath.row==2){
        PhotoGalleryViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"PhotoGalleryViewController"];
        vc.title=[self.arraySubject objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:true];
    }else if(indexPath.row==3){
        DonationTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"DonationTableViewController"];
        vc.title=[self.arraySubject objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:TRUE];
    }else if(indexPath.row==4){
        RulesTableViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"RulesTableViewController"];
        vc.title=[self.arraySubject objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:TRUE];
    }
}
@end
