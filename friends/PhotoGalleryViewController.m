//
//  PhotoGalleryViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/9/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "UIImageView+WebCache.h"
#import <Parse/Parse.h>

#define TAG_IMAGE 187

@interface PhotoGalleryViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;
@property (nonatomic,retain) NSMutableArray* arrayURLs;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorInit;
@property (strong,nonatomic) UIView* currentView;

-(void) saveCurrentPicture;
@end

@implementation PhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.horizontalScrollView.delegate=self;
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"存至「照片」" style:UIBarButtonItemStylePlain target:self action:@selector(saveCurrentPicture)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    PFQuery* qurey=[PFQuery queryWithClassName:@"DTDPhotos"];
    
    self.arrayURLs=[[NSMutableArray alloc] init];
    
    [qurey findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            for(PFObject* obj in objects){
                [self.arrayURLs addObject:obj[@"url"]];
            }
            
            [self.horizontalScrollView setContentSize:CGSizeMake(self.view.frame.size.width*[self.arrayURLs count], self.view.frame.size.height*(2/3))];
            
            [self.indicatorInit stopAnimating];
            int index=0;
            
            for(NSString * url in self.arrayURLs){
                
                UIImageView* imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width-10, self.view.frame.size.height/2)];
                [imgView sd_setImageWithURL:[NSURL URLWithString:url]];
                
                
                [imgView setFrame:CGRectMake(0, 100, self.view.frame.size.width-10, self.view.frame.size.height/2)];
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                
                UIActivityIndicatorView* loadingView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2-100, 20, 20)];
                [loadingView startAnimating];
                
                UIView* view=[[UIView alloc] initWithFrame:CGRectMake(index*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
                
                [view addSubview:loadingView];
                
                [imgView setTag:TAG_IMAGE];
                [view addSubview:imgView];
                
                [view setTag:index++];
                
                [self.horizontalScrollView addSubview:view];
            }
            self.currentView=[self.horizontalScrollView viewWithTag:0];
            
        }
    }];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"PhotoGalleryViewController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) saveCurrentPicture{
    UIImageView* imgView=(UIImageView*)[self.currentView viewWithTag:TAG_IMAGE];
    
    UIImageWriteToSavedPhotosAlbum(imgView.image,nil,nil,nil);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page=ceilf(scrollView.contentOffset.x/self.view.frame.size.width);
    if(page<[self.arrayURLs count]){
    
        [scrollView setContentOffset:CGPointMake(page*self.view.frame.size.width, scrollView.contentOffset.y)];
        
        self.currentView=[scrollView viewWithTag:page];
    }
}
@end
