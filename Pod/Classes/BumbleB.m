//
//  BumbleB.m
//  Pods
//
//  Created by Ram Greenberg on 10/8/15.
//
//

#import "BumbleB.h"
#import <AFNetworking/AFURLRequestSerialization.h>

NSString * const kBumbleBPublicAPIKey = @"pl3tyKWdljSBr";

@interface BumbleB ()

@property (readwrite, strong, nonatomic) NSString * type;
@property (readwrite, strong, nonatomic) NSString * soundId;
@property (readwrite, strong, nonatomic) NSURL * pageUrl;
@property (readwrite, strong, nonatomic) NSString * username;
@property (readwrite, strong, nonatomic) NSURL * sourceUrl;
@property (readwrite, strong, nonatomic) NSString * rating;
@property (readwrite, strong, nonatomic) NSString * title;
@property (readwrite, strong, nonatomic) NSString * transcription;
@property (readwrite, nonatomic) NSInteger duration;
@property (readwrite, strong, nonatomic) NSDate * importDateTime;
@property (readwrite, strong, nonatomic) NSDate * releaseDateTime;
@property (readwrite, strong, nonatomic) BumbleBImage * image;
@property (readwrite, strong, nonatomic) NSDictionary * sounds;

@end

@implementation BumbleB

static NSString* const kTypeKey = @"type";
static NSString* const kBumbleBIdKey = @"id";
static NSString* const kPageUrlKey = @"pageUrl";
static NSString* const kUsernameKey = @"username";
static NSString* const kSourceUrlKey = @"source";
static NSString* const kRatingKey = @"rating";
static NSString* const kTitleKey = @"title";
static NSString* const kTranscriptionKey = @"transcription";
static NSString* const kDurationKey = @"duration";
static NSString* const kImportDateKey = @"import_datetime";
static NSString* const kReleaseDateKey = @"release_datetime";
static NSString* const kImageKey = @"image";
static NSString* const kSoundsKey = @"sounds";

static NSString* const kRespponseDataKey = @"data";
static NSString* const kRespponsePaginationKey = @"pagination";
static NSString* const kRespponseTotalCountKey = @"total_count";
static NSString* const kResponseMetKey = @"meta";

static NSString* const kBumbleBBasedURL =  @"http://api.bumbleb.io/v1/sounds";

static NSString* kBumbleBAPIKey;

- (instancetype) initWithDictionary: (NSDictionary *) dictionary
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.type = dictionary[kTypeKey];
    self.soundId = dictionary[kBumbleBIdKey];
    self.pageUrl = [NSURL URLWithString:dictionary[kPageUrlKey]];
    self.username = dictionary[kUsernameKey];
    self.sourceUrl = [NSURL URLWithString:dictionary[kSourceUrlKey]];
    self.rating = dictionary[kRatingKey];
    self.title = dictionary[kTitleKey];
    self.transcription = dictionary[kTranscriptionKey];
    self.duration = [dictionary[kDurationKey] integerValue];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    self.importDateTime = [dateFormatter dateFromString:dictionary[kImportDateKey]];
    self.releaseDateTime = [dateFormatter dateFromString:dictionary[kReleaseDateKey]];
    //Hack
    if(!self.releaseDateTime){
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.releaseDateTime = [dateFormatter dateFromString:dictionary[kReleaseDateKey]];
    }
    
    NSDictionary * imageJson = dictionary[kImageKey];
    self.image = [[BumbleBImage alloc] initWithDictionary:imageJson];
    
    __block NSDictionary * soundsJson = dictionary[kSoundsKey];
    NSMutableDictionary * parsedSounds = [NSMutableDictionary new];
    [soundsJson enumerateKeysAndObjectsUsingBlock:^(id format, id soundJson, BOOL *stop) {
        [parsedSounds setObject:[[BumbleBSound alloc] initWithDictionary:soundJson]  forKey:format];
    }];
    self.sounds = parsedSounds;
    
    return self;
}

+ (NSArray *) bumbleBArrayFromDictArray:(NSArray *) array
{
    __block NSMutableArray * bumbleBArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary * dict = obj;
        BumbleB * bumbleB = [[BumbleB alloc] initWithDictionary:dict];
        [bumbleBArray addObject:bumbleB];
    }];
    return bumbleBArray;
}

+ (void) setBumbleBAPIKey:(NSString *) APIKey
{
    kBumbleBAPIKey = APIKey;
}

+ (NSURLRequest *) bumbleBSearchRequestForTerm:(NSString *) term limit:(NSUInteger) limit offset:(NSInteger) offset
{
    return [self requestForEndPoint:@"/search" params:@{@"limit": @(limit), @"offset": @(offset), @"q": term}];
}

+ (NSURLRequest *) bumbleBSearchRequestForTerm:(NSString *)term{
    return [self requestForEndPoint:@"/search" params:@{@"q": term}];
}

+ (NSURLRequest *) bumbleBRequestForSoundId:(NSString *) soundId{
    return [self requestForEndPoint:[NSString stringWithFormat:@"/%@",soundId] params:nil];
}

+ (NSURLRequest *) bumbleBRequestForSoundsWithIds:(NSArray *) soundIds
{
    return [self requestForEndPoint:@"" params:@{@"ids": [soundIds componentsJoinedByString:@","]}];
}

+ (NSURLRequest *) bumbleBTrendingRequestWithlimit:(NSUInteger)limit offset:(NSInteger) offset{
    return [self requestForEndPoint:@"/trending" params:@{@"limit": @(limit), @"offset": @(offset)}];
}

+ (NSURLRequest *) bumbleBTrendingRequest{
    return [self requestForEndPoint:@"/trending" params:nil];
}

+ (NSURLRequest *) requestForEndPoint:(NSString *) endpoint params:(NSDictionary *) params
{
    NSString * withEndPoint = [NSString stringWithFormat:@"%@%@", kBumbleBBasedURL, endpoint];
    NSError * error;
    
    NSMutableDictionary * paramsWithAPIKey = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramsWithAPIKey setObject:kBumbleBAPIKey forKey:@"api_key"];
    NSURLRequest * request =  [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:withEndPoint parameters:paramsWithAPIKey error:&error];
    return request;
}

+ (NSURLSessionDataTask *) bumbleBSearchWithTerm:(NSString *) searchTerm limit:(NSUInteger) limit offset:(NSUInteger) offset completion:(void (^) (NSArray * results, NSInteger totalCount, NSError * error)) block
{
    NSURLRequest * request = [self bumbleBSearchRequestForTerm:searchTerm limit:limit offset:offset];
    NSURLSessionDataTask *task = [self bumbleBSearchWithURLRequset:request complition:block];
    return task;
}

+ (NSURLSessionDataTask *) bumbleBSearchWithTerm:(NSString *) searchTerm completion:(void (^) (NSArray * results, NSInteger totalCount, NSError * error)) block{
    NSURLRequest * request = [self bumbleBSearchRequestForTerm:searchTerm];
    NSURLSessionDataTask *task = [self bumbleBSearchWithURLRequset:request complition:block];
    return task;
}

+ (NSURLSessionDataTask *)bumbleBSearchWithURLRequset:(NSURLRequest *)request complition:(void (^)(NSArray *, NSInteger, NSError *))block
{
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // network error
        if (error) {
            block(nil, 0, error);
        } else {
            // json serialize error
            NSError * error;
            NSDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            error = error ?: [self customErrorFromResults:results];
            if (error) {
                block(nil, 0, error);
            } else {
                NSArray * BumbleBArray = [BumbleB bumbleBArrayFromDictArray:results[kRespponseDataKey]];
                NSInteger totalCount = [[results[kRespponsePaginationKey] objectForKey:kRespponseTotalCountKey] integerValue];
                block(BumbleBArray, totalCount, nil);
            }
        }
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *) bumbleBSoundForId:(NSString *) soundId completion:(void (^) (BumbleB * result, NSError * error)) block
{
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLRequest * request = [self bumbleBRequestForSoundId:soundId];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // network error
        if (error) {
            block(nil, error);
        } else {
            // json serialize error
            NSError * error;
            NSDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            error = error ?: [self customErrorFromResults:results];
            if (error) {
                block(nil, error);
            } else {
                BumbleB * result = [[BumbleB alloc] initWithDictionary:results[kRespponseDataKey]];
                block(result, nil);
            }
        }
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *) bumbleBSoundsForIds:(NSArray *) soundIds completion:(void (^) (NSArray * results, NSError * error)) block
{
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLRequest * request = [self bumbleBRequestForSoundsWithIds:soundIds];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // network error
        if (error) {
            block(nil, error);
        } else {
            // json serialize error
            NSError * error;
            NSDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            error = error ?: [self customErrorFromResults:results];
            if (error) {
                block(nil, error);
            } else {
                NSArray * bumbleBArray = [BumbleB bumbleBArrayFromDictArray:results[kRespponseDataKey]];
                block(bumbleBArray, nil);
            }
        }
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *) bumbleBTrendingWithLimit:(NSUInteger) limit offset:(NSInteger) offset completion:(void (^) (NSArray * results, NSError * error)) block{
    NSURLRequest * request = [self bumbleBTrendingRequestWithlimit:limit offset:offset];
    NSURLSessionDataTask *task = [self bumbleBTrendingWithURLRequset:request complition:block];
    return task;
    
}

+ (NSURLSessionDataTask *) bumbleBTrendingWithCompletion:(void (^) (NSArray * results, NSError * error)) block{
    NSURLRequest * request = [self bumbleBTrendingRequest];
    NSURLSessionDataTask *task = [self bumbleBTrendingWithURLRequset:request complition:block];
    return task;
}

+ (NSURLSessionDataTask *)bumbleBTrendingWithURLRequset:(NSURLRequest *)request complition:(void (^)(NSArray *,  NSError *))block
{
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // network error
        if (error) {
            block(nil, error);
        } else {
            // json serialize error
            NSError * error;
            NSDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            error = error ?: [self customErrorFromResults:results];
            if (error) {
                block(nil, error);
            } else {
                NSArray * bumbleBArray = [BumbleB bumbleBArrayFromDictArray:results[kRespponseDataKey]];
                block(bumbleBArray, nil);
            }
        }
    }];
    [task resume];
    return task;
}


+ (NSError *)customErrorFromResults:(NSDictionary *)results
{
    NSArray * resultsData = results[kRespponseDataKey];
    if ([resultsData count] == 0) {
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] initWithDictionary: @{@"error_message" : @"No results were found"}];
        [userInfo addEntriesFromDictionary:results[kResponseMetKey]];
        return [[NSError alloc] initWithDomain:@"io.bumbleb.ios" code:-1 userInfo:userInfo];
    }
    return nil;
}


@end