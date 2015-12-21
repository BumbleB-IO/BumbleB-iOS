//
//  CellSelectionContext.h
//  SoundyForMessenger
//
//  Created by BumbleB on 8/27/15.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface BBCellSelectionContext : NSObject

@property (nonatomic, strong) NSData* soundData;
@property (strong, nonatomic) AVAudioPlayer* player;
@property (strong, nonatomic) NSIndexPath* indexPath;
@property (strong, nonatomic) NSString* soundId;

-(id) initWithIndexPath:(NSIndexPath*)indexPath audioPlyer:(AVAudioPlayer*)player soundData:(NSData*)soundData soundId:(NSString*)soundId;

@end
