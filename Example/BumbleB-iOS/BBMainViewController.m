//
//  BBMainViewController.m
//  BumbleB-iOS
//
//  Created by Ram Greenberg on 10/08/2015.
//  Copyright (c) 2015 Ram Greenberg. All rights reserved.
//

#import "BBMainViewController.h"
#import <BumbleB_iOS/BumbleB.h>
#import "BBCell.h"
#import "BBSearchBarWithActivity.h"

@interface BBMainViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray* sounds;
@property (weak, nonatomic) IBOutlet BBSearchBarWithActivity *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NSString *const kSoundyCellIdentifier = @"BBTableViewCell";
NSString *const kNoResultsCellIdentifier = @"BBNoResultsFound";


@implementation BBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BBCell" bundle:nil] forCellReuseIdentifier:kSoundyCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:kNoResultsCellIdentifier bundle:nil] forCellReuseIdentifier:kNoResultsCellIdentifier];
    
    [BumbleB setBumbleBAPIKey:kBumbleBPublicAPIKey];
    [BumbleB bumbleBTrendingWithCompletion:^(NSArray *results,NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sounds = results;
            [self.tableView reloadData];
        });
    }];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.searchBar startActivity];
    [BumbleB bumbleBSearchWithTerm:searchBar.text completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sounds = results;
            [self.tableView reloadData];
            // Dismiss
            [self.searchBar finishActivity];
        });
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([self searchWithNoResult]){
        return 1;
    }
    return self.sounds.count > 0 ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if([self searchWithNoResult]){
        return 1;
    }
    return self.sounds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.sounds.count == 0){
        BBCell *cell = [tableView dequeueReusableCellWithIdentifier:kNoResultsCellIdentifier];
        return cell;
    }
    
    BBCell *cell = [tableView dequeueReusableCellWithIdentifier:kSoundyCellIdentifier];
    
    // Configure the cell...
    [cell setSound:self.sounds[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.sounds.count == 0){
        return 44;
    }
    return  50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BBCell class]]) {
        BBCell* soundCell = (BBCell*)cell;
        [soundCell didTapOnCell];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL) searchWithNoResult{
    return (!self.sounds && self.searchBar.text.length > 0);
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
