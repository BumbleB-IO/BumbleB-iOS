//
//  BBMainViewController.m
//  BumbleB-iOS
//
//  Created by BumbleB on 10/08/2015.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//


#import "BBMainViewController.h"
#import <BumbleB_iOS/BumbleB.h>
#import "BBCell.h"
#import "BBSearchBarWithActivity.h"
#import "BBCellSelectionContext.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "BBSoundsContext.h"

#define UIColorRGB(rgb) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:1.0f])
#define UIColorRGBA(rgb,a) ([[UIColor alloc] initWithRed:(((rgb >> 16) & 0xff) / 255.0f) green:(((rgb >> 8) & 0xff) / 255.0f) blue:(((rgb) & 0xff) / 255.0f) alpha:a])

@interface BBMainViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>

@property (nonatomic,strong) NSMutableArray* trendingSounds;
@property (nonatomic,strong) NSMutableArray* searchedSounds;
@property (nonatomic,weak, getter=soundsToDiplay) NSArray* soundsToDisplay;
@property (nonatomic,strong) BBCellSelectionContext* selectedCellContext;
@property (weak, nonatomic) IBOutlet BBSearchBarWithActivity *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
@property (strong, nonatomic) BBSoundsContext* searchDataContext;
@property (strong, nonatomic) BBSoundsContext* trendingDataContext;

@end

NSString *const kBumbleBCellNibName = @"BBCell";


@implementation BBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:kBumbleBCellNibName bundle:nil] forCellReuseIdentifier:kBumbleBCellNibName];
    
    [BumbleB setBumbleBAPIKey:@"zOuEjzYiSL2DU"];
    
    //update status bar style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //add logo to navigator
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    //remove nav bar shadow
    [self removeNavBarShadow];
    
    self.searchBar.indicatorBgColor = UIColorRGB(0x4b4d60);
    
    self.searchBar.tintColor = [UIColor whiteColor];
    //update internal text field color
    for (UIView *subView in self.searchBar.subviews) {
        for(id field in subView.subviews){
            if ([field isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)field;
                [textField setBackgroundColor:UIColorRGBA(0xffffff, 0.2)];
                [textField setTextColor:[UIColor whiteColor]];
            }
        }
    }
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // append data to data source, insert new cells at the end of table view
        if([self searchMode]){
            [self loadMoreSearchSounds];
        }
        else{
            [self loadMoreTrendingSounds];
        }
    }];
    
    //load trending sounds
    self.loader.hidden = NO;
    [BumbleB  bumbleBTrendingWithCompletion:^(NSArray *results, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loader.hidden = YES;
            self.trendingSounds = [NSMutableArray arrayWithArray:results];
            self.trendingDataContext = [[BBSoundsContext alloc] initWithTotalNumber:100 offset:results.count limit:25];
            [self refresh];
        });
    }];
}

#pragma mark - search

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // The user clicked the [X] button or otherwise cleared the text.
    if([searchText length] == 0) {
        [self.searchBar finishActivity];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar finishActivity];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.searchBar.text = nil;
    self.searchedSounds = nil;
    [self resetSelectedCell];
    [self.searchBar resignFirstResponder];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    //scroll to top
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateInfiniteScrollingStateTo:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.loader.hidden = YES;
    [self updateInfiniteScrollingStateTo:YES];
    [self.searchBar resignFirstResponder];
    [self resetSelectedCell];
    [self enableCancelButton:searchBar];
    [self.searchBar startActivity];
    [BumbleB bumbleBSearchWithTerm:searchBar.text completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Dismiss
            [self.searchBar finishActivity];
            self.searchedSounds = [NSMutableArray arrayWithArray:results];
            self.searchDataContext = [[BBSoundsContext alloc] initWithTotalNumber:totalCount offset:results.count limit:25];
            [self.tableView reloadData];
            //scroll to top
            [self.tableView setContentOffset:CGPointZero animated:NO];
            
        });
    }];
    
}

-(void) loadMoreSearchSounds{
    __block NSInteger limit = MIN(self.searchDataContext.limit, self.searchDataContext.total - self.searchDataContext.offset);
    if(limit > 0){
        [BumbleB bumbleBSearchWithTerm:self.searchBar.text limit:limit offset:self.searchDataContext.offset completion:^(NSArray *results, NSInteger totalCount, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(results.count > 0){
                    [self.searchedSounds addObjectsFromArray:results];
                    self.searchDataContext.offset += results.count;
                    [self refresh];
                }
            });
        }];
    }
    else{
        //stop animation of infinite scroll
        [self noMoreDataToLoad];
    }
    
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([self searchWithNoResult]){
        self.tableView.hidden = YES;
    }
    else{
        self.tableView.hidden = NO;
    }
    
    
    return (self.soundsToDisplay.count > 0) ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.soundsToDisplay.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBCell *cell = [tableView dequeueReusableCellWithIdentifier:kBumbleBCellNibName];
    
    // Configure the cell...
    [cell setSound:self.soundsToDisplay[indexPath.row]];
    if([indexPath isEqual:self.selectedCellContext.indexPath] && [self.selectedCellContext.player isPlaying]){
        [cell playingLayout:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BBCell class]]) {
        BBCell* selectedSoundCell = (BBCell*)cell;
        
        //tap on a different cell
        if(![self.selectedCellContext.indexPath isEqual:indexPath]){
            //stop previos cell
            [self stopSoundOfSelectedCell];
            //update selection
            if(selectedSoundCell.player){
                self.selectedCellContext = [[BBCellSelectionContext alloc] initWithIndexPath:indexPath audioPlyer:selectedSoundCell.player soundData:selectedSoundCell.soundData soundId:selectedSoundCell.sound.soundId];
                self.selectedCellContext.player.delegate = self;
                [self playSoundOfSelectedCell:selectedSoundCell];
            }
            else{
                [self resetSelectedCell:selectedSoundCell];
            }
        }
        //tap on the same selected cell
        else{
            //if already playing
            if(self.selectedCellContext.player.playing){
                [self stopSoundOfSelectedCell:selectedSoundCell];
            }
            //not playing
            else{
                [self playSoundOfSelectedCell:selectedSoundCell];
                
            }
        }
        
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stopSoundOfSelectedCell];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self stopSoundOfSelectedCell];
}


-(BOOL) searchWithNoResult{
    //There is a corner case where during the loading of the trending sounds the user searches for a phrase. in order to prevent showing a no result message during the search process we need to check also if the searchBar is in animation satae
    return (self.searchedSounds.count == 0 && [self searchMode] && ![self.searchBar isAnimating]);
}

-(BOOL) searchMode{
    return (self.searchBar.text.length > 0 || [self.searchBar isFirstResponder]);
}

-(NSArray*) soundsToDiplay{
    if([self searchMode] && self.searchedSounds.count > 0){
        return self.searchedSounds;
    }
    return self.trendingSounds;
}

#pragma mark - private

-(void) loadMoreTrendingSounds{
    __block NSInteger limit = MIN(self.trendingDataContext.limit, self.trendingDataContext.total - self.trendingDataContext.offset);
    if(limit > 0){
        [BumbleB bumbleBTrendingWithLimit:limit offset:self.trendingDataContext.offset completion:^(NSArray *results, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(results.count > 0){
                    [self.trendingSounds addObjectsFromArray:results];
                    self.trendingDataContext.offset += results.count;
                    [self refresh];
                }
            });
        }];
    }
    else{
        //stop animation of infinite scroll
        [self noMoreDataToLoad];
    }
    
}

-(void) noMoreDataToLoad{
    [self.tableView.infiniteScrollingView stopAnimating];
    [self updateInfiniteScrollingStateTo:NO];
}

-(void) refresh{
    [self.tableView.infiniteScrollingView stopAnimating];
    [self.tableView reloadData];
}


- (void)enableCancelButton:(UISearchBar *)searchBar
{
    for (UIView *view in searchBar.subviews)
    {
        for (id subview in view.subviews)
        {
            if ( [subview isKindOfClass:[UIButton class]] )
            {
                [subview setEnabled:YES];
                return;
            }
        }
    }
}

- (void)resetSelectedCell {
    if(self.selectedCellContext){
        BBCell *cell = (BBCell*)[self.tableView cellForRowAtIndexPath:self.selectedCellContext.indexPath];
        [self resetSelectedCell:cell];
    }
}

- (void)resetSelectedCell:(BBCell*)cell{
    [self stopSoundOfSelectedCell:cell];
    cell.selected = NO;
    self.selectedCellContext = nil;
}


//source: http://stackoverflow.com/questions/18160173/how-to-remove-uinavigationbar-inner-shadow-in-ios-7/18180330#18180330
- (void)removeNavBarShadow {
    //update searchbar layout
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UIImageView class]]) {
                [view2 removeFromSuperview];
            }
        }
    }
}

-(void) playSoundOfSelectedCell{
    if(self.selectedCellContext){
        BBCell *cell = (BBCell*)[self.tableView cellForRowAtIndexPath:self.selectedCellContext.indexPath];
        [self playSoundOfSelectedCell:cell];
    }
}

-(void) playSoundOfSelectedCell:(BBCell*)cell{
    if(self.selectedCellContext && self.selectedCellContext.player){
        [self.selectedCellContext.player play];
        [cell playingLayout:YES];
    }
    
}

-(void) stopSoundOfSelectedCell:(BBCell*)cell{
    if(self.selectedCellContext){
        [self.selectedCellContext.player stop];
        [cell playingLayout:NO];
    }
}

-(void) stopSoundOfSelectedCell{
    if(self.selectedCellContext){
        BBCell *cell = (BBCell*)[self.tableView cellForRowAtIndexPath:self.selectedCellContext.indexPath];
        [self stopSoundOfSelectedCell:cell];
    }
}

-(void) updateInfiniteScrollingStateTo:(BOOL)active{
    if(active){
        BBSoundsContext* soundContext = ([self searchMode]) ? self.searchDataContext : self.trendingDataContext;
        NSInteger limit = MIN(soundContext.limit, soundContext.total - soundContext.offset);
        if(limit <= 0){
            //do nothing
            return;
        }
        self.tableView.showsInfiniteScrolling = active;
    }
    else{
        self.tableView.showsInfiniteScrolling = active;
    }
}

@end