//
//  TableSoundsContext.h
//  SoundyForMessenger
//
//  Created by BumbleB on 9/4/15.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSoundsContext : NSObject

@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger limit;

-(id) initWithTotalNumber:(NSInteger)total offset:(NSInteger)offset limit:(NSInteger)limit;

@end
