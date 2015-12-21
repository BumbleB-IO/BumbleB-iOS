//
//  BumbleB.h
//  Pods
//
//  Created by BumbleB on 10/8/15.
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

/** BumbleB Id for this sound*/
@property (readonly, strong, nonatomic) NSString * soundId;
@property (readonly, strong, nonatomic) NSString * type;

/** page URL */
@property (readonly, strong, nonatomic) NSURL * pageUrl;

/** username who uploaded this sound */
@property (readonly, strong, nonatomic) NSString * username;

/** the source URL of this sound */
@property (readonly, strong, nonatomic) NSURL * sourceUrl;

/** rating of this sound */
@property (readonly, strong, nonatomic) NSString * rating;

/** title of this sound clip */
@property (readonly, strong, nonatomic) NSString * title;

/** transcription of this sound clip */
@property (readonly, strong, nonatomic) NSString * transcription;

/** duration of this sound clip */
@property (readonly, nonatomic) NSInteger duration;

/** import date to the platform */
@property (readonly, strong, nonatomic) NSDate * importDateTime;

/** release date of the original movie\series */
@property (readonly, strong, nonatomic) NSDate * releaseDateTime;

/** relevant image to this sound clip  */
@property (readonly, strong, nonatomic) BumbleBImage * image;

/** sounds formats  */
@property (readonly, strong, nonatomic) NSDictionary * sounds;


/** Set your BumbleB API Key.*/
+ (void) setBumbleBAPIKey:(NSString *) APIkey;

/** NSURLRequest */

/** NSURLRequest to search sounds with term. You can limit results, with a max of 100. Use offset with limit to paginate through results. */
+ (NSURLRequest *) bumbleBSearchRequestForTerm:(NSString *)term limit:(NSUInteger)limit offset:(NSInteger) offset;

/** NSURLRequest to search sounds with term. Returns 25 results by default. */
+ (NSURLRequest *) bumbleBSearchRequestForTerm:(NSString *)term;

/** NSURLRequest to fetch sound with Id. */
+ (NSURLRequest *) bumbleBRequestForSoundId:(NSString *) soundId;

/** NSURLRequest to fetch sounds with Ids. */
+ (NSURLRequest *) bumbleBRequestForSoundsWithIds:(NSArray *) soundIds;

/** NSURLRequest to trending sounds. You can limit results, with a max of 100. */
+ (NSURLRequest *) bumbleBTrendingRequestWithlimit:(NSUInteger)limit offset:(NSInteger) offset;

/** NSURLRequest to trending sounds items. Returns 25 results by default. */
+ (NSURLRequest *) bumbleBTrendingRequest;


/** ASYNC */

/** Search sounds with term. You can limit results, with a max of 100. Use offset with limit to paginate through results. Asynchronously returns either array of BumbleB objects or an error. */
+ (NSURLSessionDataTask *) bumbleBSearchWithTerm:(NSString *) searchTerm limit:(NSUInteger) limit offset:(NSUInteger) offset completion:(void (^) (NSArray * results, NSInteger totalCount, NSError * error)) block;

/** Search sounds with term. Returns 25 results by default. Asynchronously returns either array of BumbleB objects or an error. */
+ (NSURLSessionDataTask *) bumbleBSearchWithTerm:(NSString *) searchTerm completion:(void (^) (NSArray * results, NSInteger totalCount, NSError * error)) block;

/** Fetch sound with Id . Asynchronously returns either BumbleB object or an error.*/
+ (NSURLSessionDataTask *) bumbleBSoundForId:(NSString *) soundId completion:(void (^) (BumbleB * result, NSError * error)) block;

/** Fetch multiple sounds by Ids. Asynchronously returns either array of BumbleB objects or an error.*/
+ (NSURLSessionDataTask *) bumbleBSoundsForIds:(NSArray *) soundIds completion:(void (^) (NSArray * results, NSError * error)) block;

/** Trending sounds. You can limit results, with a max of 100. Asynchronously returns either array of BumbleB objects or an error. */
+ (NSURLSessionDataTask *) bumbleBTrendingWithLimit:(NSUInteger) limit offset:(NSInteger) offset completion:(void (^) (NSArray * results, NSError * error)) block;

/** Trending sounds. Returns 25 results by default. Asynchronously returns either array of BumbleB objects or an error. */
+ (NSURLSessionDataTask *) bumbleBTrendingWithCompletion:(void (^) (NSArray * results, NSError * error)) block;
@end
