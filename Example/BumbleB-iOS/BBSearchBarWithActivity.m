//
//  SearchBarWithActivity.m
//
//  Created by BumbleB on 10/08/15.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//

#import "BBSearchBarWithActivity.h"

@interface BBSearchBarWithActivity()

@property(nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end


@implementation BBSearchBarWithActivity

- (void)layoutSubviews {
    UITextField *searchField = nil;
    
    for (UIView *subView in self.subviews){
        for (UIView *ndLeveSubView in subView.subviews){
            if ([ndLeveSubView isKindOfClass:[UITextField class]]){
                searchField= (UITextField *)ndLeveSubView;
                break;
            }
        }
    }
    
    if(searchField) {
        if (!self.activityIndicatorView) {
            UIActivityIndicatorView *taiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            taiv.center = CGPointMake(searchField.leftView.bounds.origin.x + searchField.leftView.bounds.size.width/2,
                                      searchField.leftView.bounds.origin.y + searchField.leftView.bounds.size.height/2);
            taiv.hidesWhenStopped = YES;
            taiv.backgroundColor = self.indicatorBgColor;
            self.activityIndicatorView = taiv;
            
            [searchField.leftView addSubview:self.activityIndicatorView];
        }
    }
    
    [super layoutSubviews];
}

- (void)startActivity  {
    [self.activityIndicatorView startAnimating];
}

- (void)finishActivity {
    [self.activityIndicatorView stopAnimating];
}

- (BOOL) isAnimating{
    return [self.activityIndicatorView isAnimating];
}

@end