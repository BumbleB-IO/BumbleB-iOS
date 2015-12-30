//
//  BBCell.m
//
//  Created by BumbleB on 7/14/15.
//  Copyright (c) 2015 BumbleB. All rights reserved.
//

#import "BBCell.h"
#import "PCSEQVisualizer.h"
#import <BumbleB_iOS/BumbleBSound.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface BBCell()

@property (strong, nonatomic) PCSEQVisualizer *visualizer;
@property (weak, nonatomic) IBOutlet UIView *visualizerContainer;
@property (weak, nonatomic) IBOutlet UILabel *soundTranscription;
@property (weak, nonatomic) IBOutlet UILabel *soundDescription;
@property (weak, nonatomic) IBOutlet UILabel *soundDuration;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textWrapperHeightConstraints;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageIndicator;

@property (strong, nonatomic) NSURLSessionDataTask* audioDataTask;

@end

@implementation BBCell

- (void)awakeFromNib {
    // Initialization code
    self.visualizer = [[PCSEQVisualizer alloc] initWithNumberOfBars:3 withColot:[UIColor colorWithRed:38/255.0 green:47/255.0 blue:80/255.0 alpha:0.5]];
    self.visualizer.frame = self.visualizerContainer.bounds;
    [self.visualizerContainer addSubview:self.visualizer];
    
    //set bg color of selected cell
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:225/255.0 green:237/255.0 blue:255/255.0 alpha:1];
    [self setSelectedBackgroundView:bgColorView];
    
    
    self.soundTranscription.numberOfLines = 0;
    
    [self updateLayoutWithState:NO];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.textWrapperHeightConstraints.constant = 36;
    [self updateLayoutWithState:NO];
    [self.audioDataTask cancel];
    self.posterImage.image = nil;
    self.soundData = nil;
    self.player = nil;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    [self updateTextWrapperLayout];
}

-(void)setSound:(BumbleB *)sound{
    _sound = sound;
    self.soundTranscription.text = sound.transcription;
    self.soundDescription.text = [NSString stringWithFormat:@"%@%@",sound.title,[self dateFormatForDescription:sound.releaseDateTime]];
    self.soundDuration.text = [self formatDuration:sound.duration];
    
    BumbleBSound* soundParams = sound.firstSound;
    
    //start animation and hide image to make sure the indicator is stopped only when the sound was download
    [self.imageIndicator startAnimating];
    self.posterImage.hidden = YES;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    //load sound
    [self loadSoundForUrl:soundParams.url completion:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    //set posterImage
    [self loadPosterImageForSound:sound completion:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        // handle response
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.posterImage.hidden = NO;
            [self.imageIndicator stopAnimating];
        });
    });

}

-(void) loadPosterImageForSound:(BumbleB *)sound completion:(void (^)(void))callbackBlock{
    self.posterImage.layer.cornerRadius = 1;
    self.posterImage.clipsToBounds = YES;
    
    if(!sound.image.url){
        self.posterImage.image = [UIImage imageNamed:@"Fallback"];
        callbackBlock();
    }
    else{
        [self.imageIndicator startAnimating];
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:sound.image.url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        [self.posterImage setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, UIImage * _Nonnull image) {
            self.posterImage.image = image;
            callbackBlock();
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nonnull response, NSError * _Nonnull error) {
            self.posterImage.image = [UIImage imageNamed:@"Fallback"];
            callbackBlock();
        }];
    }
    
    
}

-(void) loadSoundForUrl:(NSURL*)url completion:(void (^)(void))callbackBlock{
    NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    self.audioDataTask = [session dataTaskWithURL:url
                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                    if(!error){
                                        self.soundData = data;
                                        NSError *PlayerError;
                                        self.player = [[AVAudioPlayer alloc] initWithData:data error:&PlayerError];
                                        if (PlayerError){
                                            NSLog(@"ERROR (initWithData) - %@ for sound transcript %@",PlayerError.description,self.soundTranscription.text);
                                        }
                                    }
                                    else if (![error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"cancelled"]){
                                        NSLog(@"ERROR (dataTaskWithURL) - %@ for sound transcript %@",error.description, self.soundTranscription.text);
                                    }
                                    callbackBlock();
                                }];
    [self.audioDataTask resume];
}

-(NSString*) dateFormatForDescription:(NSDate*)date{
    if(!date){
        return @"";
    }
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy"];
    return [NSString stringWithFormat:@", %@",[dateFormater stringFromDate:date]];
}

-(NSString *)formatDuration:(NSInteger)duration
{
    if (duration >= 10){
        return [NSString stringWithFormat:@"0:%ld", (long)duration];
    }
    return [NSString stringWithFormat:@"0:0%ld", (long)duration];
}

-(void)playingLayout:(BOOL)playing{
    [self updateLayoutWithState:playing];
}

-(void)updateLayoutWithState:(BOOL)playOn{
    
    [self fadeTransitionOnView:self.soundDuration hidden:playOn];
    [self fadeTransitionOnView:self.visualizer hidden:!playOn];
    
    if (playOn) {
        [self.visualizer start];
    }
    else{
        [self.visualizer stop];
    }
}

- (void)fadeTransitionOnView:(UIView*)view hidden:(BOOL)hidden {
    [UIView transitionWithView:view
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    
    view.hidden = hidden;
}

-(void) updateTextWrapperLayout{
    NSDictionary *attributes = @{NSFontAttributeName: self.soundTranscription.font};
    //we do not use self.soundTranscription.frame.size.width because the autolayout is not completed eventhough this method is being called from layoutSubviews.
    CGFloat widthConstrint = self.frame.size.width - 109;
    CGSize size = [self.soundTranscription.text boundingRectWithSize:CGSizeMake(widthConstrint, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:attributes
                                                             context:nil].size;
    if (self.soundTranscription.font.lineHeight < size.height) {
        self.textWrapperHeightConstraints.constant = 53;
    }
    
}
@end
