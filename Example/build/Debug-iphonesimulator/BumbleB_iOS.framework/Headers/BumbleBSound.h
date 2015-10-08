//
//  BumbleBSound.h
//  Pods
//
//  Created by Ram Greenberg on 10/8/15.
//
//

#import <Foundation/Foundation.h>

@interface BumbleBSound : NSObject

/**
 URL of sound (audio file)
 */
@property (readonly, strong, nonatomic) NSURL * url;

/**
 size of sound
 */
@property (readonly, nonatomic) NSInteger size;

/**
 construct sound from json
 */
- (instancetype) initWithDictionary:(NSDictionary *) dictionary;

@end
