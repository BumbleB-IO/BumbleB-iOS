//
//  HNHHEQVisualizer.m
//  HNHH
//
//  Created by Dobango on 9/17/13.
//  Copyright (c) 2013 RC. All rights reserved.
//

#import "PCSEQVisualizer.h"
#import "UIImage+GradientsMaker.h"


#define kWidth 4
#define kHeight 18
#define kPadding 0.8
#define kInterval 0.2


@implementation PCSEQVisualizer
{
    NSTimer* timer;
    NSArray* barArray;
}
- (id)initWithNumberOfBars:(int)numberOfBars withColot:(UIColor*) barColor;
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, kPadding*numberOfBars+(kWidth*numberOfBars), kHeight);
        
        NSMutableArray* tempBarArray = [[NSMutableArray alloc]initWithCapacity:numberOfBars];
        
        for(int i=0;i<numberOfBars;i++){
            
            UIImageView* bar = [[UIImageView alloc]initWithFrame:CGRectMake(i*kWidth+i*kPadding, 0, kWidth, 1)];
            UIColor *colorOfBar = barColor ? barColor : [UIColor blackColor];
            bar.image = [UIImage imageWithColor:colorOfBar];
            [self addSubview:bar];
            [tempBarArray addObject:bar];
            
        }

        barArray = [[NSArray alloc]initWithArray:tempBarArray];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2*2);
        self.transform = transform;
       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:@"stopTimer" object:nil];
  
    }
    return self;
}


-(void)start{
    
    self.hidden = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:kInterval target:self selector:@selector(ticker) userInfo:nil repeats:YES];
    
}


-(void)stop{
    
    [timer invalidate];
    timer = nil;
    
}

-(void)ticker{

    [UIView animateWithDuration:kInterval animations:^{
        
        for(UIImageView* bar in barArray){
            
            CGRect rect = bar.frame;
            rect.size.height = arc4random() % kHeight + 1;
            bar.frame = rect;
            
            
        }
    
    }];
}

@end
