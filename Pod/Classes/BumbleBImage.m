//
//  BumbleBImage.m
//  Pods
//
//  Created by Ram Greenberg on 10/8/15.
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
    
    self.url = [NSURL URLWithString:dictionary[kURLKey]];
    self.width = [dictionary[kWidthKey] floatValue];
    self.height = [dictionary[kHeightKey] floatValue];
    self.size = [dictionary[kSizeKey] integerValue];
    
    return self;
}

@end