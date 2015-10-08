//
//  BumbleB.h
//  Pods
//
//  Created by Ram Greenberg on 10/8/15.
//
//

#import <Foundation/Foundation.h>
#import "BumbleBImage.h"
#import "BumbleBSound.h"

/** 
 public api key - DO NOT USE IN PRODUCTION
 */
extern NSString * const kBumbleBPublicAPIKey;

@interface BumbleB : NSObject

/** type of BumbleB */
@property (readonly, strong, nonatomic) NSString * type;

/** BumbleB Id */
@property (readonly, strong, nonatomic) NSString * bumbleBId;

/** BumbleB page URL */
@property (readonly, strong, nonatomic) NSURL * pageUrl;

/** username who uploaded this BumbleB item */
@property (readonly, strong, nonatomic) NSString * username;

/** the source URL of this BumbleB item */
@property (readonly, strong, nonatomic) NSURL * sourceUrl;

/** rating of this BumbleB item */
@property (readonly, strong, nonatomic) NSString * rating;

/** title of this BumbleB item */
@property (readonly, strong, nonatomic) NSString * title;

/** transcription of this BumbleB item */
@property (readonly, strong, nonatomic) NSString * transcription;

/** duration of this BumbleB item */
@property (readonly, nonatomic) NSInteger duration;

/** import date to the platform */
@property (readonly, strong, nonatomic) NSDate * importDateTime;

/** release date of the original movie\series */
@property (readonly, strong, nonatomic) NSDate * releaseDateTime;

/** relevant image to this BumbleB item  */
@property (readonly, strong, nonatomic) BumbleBImage * image;

/** sounds formats  */
@property (readonly, strong, nonatomic) NSDictionary * sounds;


/** Set your BumbleB API Key.*/
+ (void) setBumbleBAPIKey:(NSString *) APIkey;

/** NSURLRequest */

/** NSURLRequest to search BumbleB items with term. You can limit results, with a max of 100. Use offset with limit to paginate through results. */
+ (NSURLRequest *) bumbleBSearchRequestForTerm:(NSString *)term limit:(NSUInteger)limit offset:(NSInteger) offset;

/** NSURLRequest to search BumbleB items with term. Returns 25 results by default. */
+ (NSURLRequest *) bumbleBSearchRequestForTerm:(NSString *)term;

/** NSURLRequest to fetch BumbleB item with Id. */
+ (NSURLRequest *) bumbleBRequestForBumbleBId:(NSString *) bumbleBId;

/** NSURLRequest to fetch BumbleB items with Ids. */
+ (NSURLRequest *) bumbleBRequestForBumbleBWithIds:(NSArray *) bumbleBIds;

/** NSURLRequest to trending BumbleB items. You can limit results, with a max of 100. */
+ (NSURLRequest *) bumbleBTrendingRequestWithlimit:(NSUInteger)limit offset:(NSInteger) offset;

/** NSURLRequest to trending BumbleB items. Returns 25 results by default. */
+ (NSURLRequest *) bumbleBTrendingRequest;


/** ASYNC */

/** Search BumbleB items with term. You can limit results, with a max of 100. Use offset with limit to paginate through results. Asynchronously returns either array of BumbleB objects or an error. */
+ (NSURLSessionDataTask *) bumbleBSearchWithTerm:(NSString *) searchTerm limit:(NSUInteger) limit offset:(NSUInteger) offset completion:(void (^) (NSArray * results, NSInteger totalCount, NSError * error)) block;

/** Search BumbleB items with term. Returns 25 results by default. Asynchronously returns either array of BumbleB objects or an error. */
+ (NSURLSessionDataTask *) bumbleBSearchWithTerm:(NSString *) searchTerm completion:(void (^) (NSArray * results, NSInteger totalCount, NSError * error)) block;

/** Fetch BumbleB item with Id . Asynchronously returns either BumbleB object or an error.*/
+ (NSURLSessionDataTask *) bumbleBForId:(NSString *) bumbleBId completion:(void (^) (BumbleB * result, NSError * error)) block;

/** Fetch multiple BumbleB items by Ids. Asynchronously returns either array of BumbleB objects or an error.*/
+ (NSURLSessionDataTask *) bumbleBForIds:(NSArray *) bumbleBIds completion:(void (^) (NSArray * results, NSError * error)) block;

/** Trending BumbleB items. You can limit results, with a max of 100. Asynchronously returns either array of BumbleB objects or an error. */
+ (NSURLSessionDataTask *) bumbleBTrendingWithLimit:(NSUInteger) limit offset:(NSInteger) offset completion:(void (^) (NSArray * results, NSError * error)) block;

/** Trending BumbleB items. Returns 25 results by default. Asynchronously returns either array of BumbleB objects or an error. */
+ (NSURLSessionDataTask *) bumbleBTrendingWithCompletion:(void (^) (NSArray * results, NSError * error)) block;
@end
