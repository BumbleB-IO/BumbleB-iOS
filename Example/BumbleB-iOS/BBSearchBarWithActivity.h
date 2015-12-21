//
//  SearchBarWithActivity.h
//
//  Created by BumbleB on 10/08/15.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSearchBarWithActivity : UISearchBar

@property (nonatomic,strong) UIColor* indicatorBgColor;

- (void)startActivity;
- (void)finishActivity;
- (BOOL) isAnimating;

@end
