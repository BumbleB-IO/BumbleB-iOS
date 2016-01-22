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
@property (strong, readwrite, nonatomic) NSString * type;

@end

@implementation BumbleBSound

static NSString* const kURLKey = @"url";
static NSString* const kSizeKey = @"size";
static NSString* const kTypeKey = @"type";

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.url = (dictionary[kURLKey]) ? [NSURL URLWithString:dictionary[kURLKey]] : nil;
    self.size = (dictionary[kSizeKey]) ? [dictionary[kSizeKey] integerValue] : 0;
    self.type = dictionary[kTypeKey];
    
    return self;
}

@end