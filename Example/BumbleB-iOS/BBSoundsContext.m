//
//  TableSoundsContext.m
//  SoundyForMessenger
//
//  Created by BumbleB on 9/4/15.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//

#import "BBSoundsContext.h"

@implementation BBSoundsContext

-(id) initWithTotalNumber:(NSInteger)total offset:(NSInteger)offset limit:(NSInteger)limit{
    self = [[BBSoundsContext alloc] init];
    if(self){
        self.total = total;
        self.offset = offset;
        self.limit = limit;
    }
    return self;
}

@end
