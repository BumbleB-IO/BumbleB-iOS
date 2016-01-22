//
//  BumbleBImage.m
//  Pods
//
//  Created by BumbleB on 10/8/15.
//
//

#import "BumbleBImage.h"

@interface BumbleBImage ()

@property (strong, readwrite, nonatomic) NSURL * url;
@property (readwrite, nonatomic) CGFloat width;
@property (readwrite, nonatomic) CGFloat height;
@property (readwrite, nonatomic) NSInteger size;

@end

@implementation BumbleBImage

static NSString* const kURLKey = @"url";
static NSString* const kWidthKey = @"width";
static NSString* const kHeightKey = @"height";
static NSString* const kSizeKey = @"size";

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.url = (dictionary[kURLKey]) ? [NSURL URLWithString:dictionary[kURLKey]] : nil;
    self.width = (dictionary[kWidthKey]) ? [dictionary[kWidthKey] floatValue] : 0;
    self.height = (dictionary[kHeightKey]) ? [dictionary[kHeightKey] floatValue] : 0;
    self.size = (dictionary[kSizeKey]) ? [dictionary[kSizeKey] integerValue] : 0;
    
    return self;
}

@end