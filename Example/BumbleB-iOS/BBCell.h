//
//  BBCell.h
//  BumbleB-iOS
//
//  Created by Ram Greenberg on 10/08/2015.
//  Copyright (c) 2015 Ram Greenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BumbleB_iOS/BumbleB.h>

@interface BBCell : UITableViewCell

-(void)setSound:(BumbleB *)sound;
-(void)didTapOnCell;
@end
