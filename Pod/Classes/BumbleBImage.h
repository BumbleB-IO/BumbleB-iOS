//
//  BumbleBImage.h
//  Pods
//
//  Created by BumbleB on 10/8/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BumbleBImage : NSObject

/** 
 URL of image
 */
@property (readonly, strong, nonatomic) NSURL * url;

/**
 width of image
 */
@property (readonly, nonatomic) CGFloat width;

/** 
 height of image
 */
@property (readonly, nonatomic) CGFloat height;

/**
 size of image
 */
@property (readonly, nonatomic) NSInteger size;

/**
 construct image from json
 */
- (instancetype) initWithDictionary:(NSDictionary *) dictionary;

@end
