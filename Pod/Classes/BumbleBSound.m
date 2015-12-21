//
//  BumbleBSound.m
//  Pods
//
//  Created by BumbleB on 10/8/15.
//
//

#import "BumbleBSound.h"

@interface BumbleBSound ()

@property (strong, readwrite, nonatomic) NSURL * url;
@property (readwrite, nonatomic) NSInteger size;

@end

@implementation BumbleBSound

static NSString* const kURLKey = @"url";
static NSString* const kSizeKey = @"size";

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.url = [NSURL URLWithString:dictionary[kURLKey]];
    self.size = [dictionary[kSizeKey] integerValue];
    
    return self;
}

@end