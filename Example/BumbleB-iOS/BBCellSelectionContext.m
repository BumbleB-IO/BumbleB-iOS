//
//  CellSelectionContext.m
//  SoundyForMessenger
//
//  Created by BumbleB on 8/27/15.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//

#import "BBCellSelectionContext.h"

@implementation BBCellSelectionContext

-(id) initWithIndexPath:(NSIndexPath*)indexPath audioPlyer:(AVAudioPlayer*)player soundData:(NSData*)soundData soundId:(NSString *)soundId{
    self = [[BBCellSelectionContext alloc] init];
    if(self){
        self.indexPath = indexPath;
        self.player = player;
        self.soundData = soundData;
        self.soundId = soundId;
    }
    return self;
}

@end
