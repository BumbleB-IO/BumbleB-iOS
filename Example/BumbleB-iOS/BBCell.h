//
//  BBCell.h
//  BumbleB-iOS
//
//  Created by BumbleB on 10/08/2015.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BumbleB_iOS/BumbleB.h>
#import <AVFoundation/AVFoundation.h>

@class BBCell;

@interface BBCell : UITableViewCell

@property (nonatomic, weak) BumbleB* sound;
@property (nonatomic, strong) NSData* soundData;
@property (strong, nonatomic) AVAudioPlayer* player;

-(void)setSound:(BumbleB *)sound;
-(void)playingLayout:(BOOL)playing;

@end
