//
//  BBCell.m
//  BumbleB-iOS
//
//  Created by Ram Greenberg on 10/08/2015.
//  Copyright (c) 2015 Ram Greenberg. All rights reserved.
//

#import "BBCell.h"
#import <AVFoundation/AVFoundation.h>
#import "PCSEQVisualizer.h"
#import <BumbleB_iOS/BumbleBSound.h>
#import "UIImage+GradientsMaker.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface BBCell() <AVAudioPlayerDelegate>

@property (strong, nonatomic) BumbleB* sound;
@property (strong, nonatomic) PCSEQVisualizer *visualizer;
@property (weak, nonatomic) IBOutlet UIView *visualizerContainer;
@property (weak, nonatomic) IBOutlet UILabel *soundTranscription;
@property (weak, nonatomic) IBOutlet UILabel *soundDescription;
@property (weak, nonatomic) IBOutlet UILabel *soundDuration;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;

@property (strong, nonatomic) AVAudioPlayer* player;

@end

@implementation BBCell

- (void)awakeFromNib {
    // Initialization code
    UIColor* pinkColor = [UIColor colorWithRed:(255/255.0) green:(20/255.0) blue:(147/255.0) alpha:1] ;
    self.visualizer = [[PCSEQVisualizer alloc] initWithNumberOfBars:3 withColot:pinkColor];
    self.visualizer.frame = self.visualizerContainer.bounds;
    [self.visualizerContainer addSubview:self.visualizer];
    
    [self updateLayoutWithState:NO];
    
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self updateLayoutWithState:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSound:(BumbleB *)sound{
    if([sound.soundId isEqualToString:self.sound.soundId]){
        return;
    }
    
    _sound = sound;
    self.soundTranscription.text = sound.transcription;
    self.soundDescription.text = [NSString stringWithFormat:@"%@%@",sound.title,[self dateFormatForDescription:sound.releaseDateTime]];
    self.soundDuration.text = [self formatDuration:sound.duration];
    
    BumbleBSound* bumbleBSound = (BumbleBSound*)[[sound.sounds allValues] firstObject];
    
    //set posterImage
    [self.posterImage setImageWithURL:sound.image.url];
    self.posterImage.layer.cornerRadius = 10;
    self.posterImage.clipsToBounds = YES;
    
    //load sound
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:bumbleBSound.url
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                // handle response
                if(error){
                    NSLog(@"ERROR (dataTaskWithURL) - %@",error.description);
                    return;
                }
                NSError *PlayerError;
                self.player = [[AVAudioPlayer alloc] initWithData:data error:&PlayerError];
                if (PlayerError){
                    NSLog(@"ERROR (initWithData) - %@",PlayerError.description);
                    return;
                }
                self.player.delegate = self;
            }] resume];
}
                        
-(NSString*) dateFormatForDescription:(NSDate*)date{
    if(!date){
        return @"";
    }
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy"];
    return [NSString stringWithFormat:@", (%@)",[dateFormater stringFromDate:date]];
}

-(NSString *)formatDuration:(NSInteger)duration
{
    if (duration >= 10){
        return [NSString stringWithFormat:@"0:%ld", (long)duration];
    }
    return [NSString stringWithFormat:@"0:0%ld", (long)duration];
}

-(void)didTapOnCell{
    if (self.player.playing){
        [self.player stop];
        [self updateLayoutWithState:NO];
        return;
    }
    
    [self.player play];
    [self updateLayoutWithState:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self updateLayoutWithState:NO];
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
     [self updateLayoutWithState:NO];
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
@end
