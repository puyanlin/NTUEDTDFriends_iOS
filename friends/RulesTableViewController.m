//
//  RulesTableViewController.m
//  friends
//
//  Created by Patrick@fuhu on 1/8/15.
//  Copyright (c) 2015 FUHU. All rights reserved.
//

#import "RulesTableViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

#define KEY_TITLE @"title"
#define KEY_DATE  @"date"
#define KEY_RULES @"rules"

#define TAG_RULETEXT 100


@interface RulesTableViewController ()
@property NSDictionary* dicRules;
@end

@implementation RulesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dicRules=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Rules" ofType:@"plist"]];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"RulesCell"];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"RulesTableViewController"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.dicRules objectForKey:KEY_RULES] count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section==0)
        return 0;
    return [[[[self.dicRules objectForKey:KEY_RULES] objectAtIndex:section-1] objectForKey:KEY_RULES] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RulesCell" forIndexPath:indexPath];
    
    
    UILabel* lblRuleText;
    if (![cell viewWithTag:TAG_RULETEXT])
    {
        
        lblRuleText = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, cell.contentView.frame.size.width-40, cell.contentView.frame.size.height)];
        lblRuleText.font = [UIFont fontWithName:@"BradleyHandITCTT" size: 20.0];
        lblRuleText.textColor = [UIColor blackColor];
        lblRuleText.textAlignment = NSTextAlignmentLeft;
        lblRuleText.numberOfLines = 0;
        lblRuleText.backgroundColor = [UIColor clearColor];
        
        lblRuleText.tag = TAG_RULETEXT;
    
        [cell.contentView addSubview:lblRuleText];
        
        
    }
    else
    {
        lblRuleText = (UILabel *) [cell viewWithTag:TAG_RULETEXT];
    }
    
    lblRuleText.text = [[[[[self.dicRules objectForKey:KEY_RULES] objectAtIndex:indexPath.section-1] objectForKey:KEY_RULES] objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    return cell;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0)
        return [self.dicRules objectForKey:KEY_DATE];
    return [[[self.dicRules objectForKey:KEY_RULES] objectAtIndex:section-1] objectForKey:KEY_TITLE];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

@end
