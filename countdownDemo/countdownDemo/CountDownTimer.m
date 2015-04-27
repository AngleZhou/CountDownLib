//
//  CountDownTimer.m
//  countdownDemo
//
//  Created by Qian Zhou on 15/4/24.
//  Copyright (c) 2015年 Qian Zhou. All rights reserved.
//

#import "CountDownTimer.h"

@interface CountDownTimer ()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic) int minutes;
@property (nonatomic) int seconds;
@property (nonatomic) int secondsLeft;
@property (nonatomic) BOOL started;
@property (nonatomic) BOOL repeated;
@end

@implementation CountDownTimer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.timerLabel];
    NSLog(@"%@", self.timerLabel.text);
    [self startTimer];
    
}



- (UILabel *)timerLabel {
    if (!_timerLabel) {
        CGRect labelFrameRect = CGRectMake(10, 300, 60, 30);
        _timerLabel = [[UILabel alloc] initWithFrame:labelFrameRect];
        _timerLabel.textColor = [UIColor blackColor];
        _timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", self.totalTime, 0];

        _timerLabel.font = [UIFont systemFontOfSize:20];
    }
    
    return _timerLabel;
}



- (void)startTimer {
//    self.secondsLeft = self.totalTime * 60;
    self.secondsLeft = 15;
    [self countdownTimer];
    //save timeUserSet
    [[NSUserDefaults standardUserDefaults] setInteger:self.totalTime forKey:@"timeUserSet"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


- (void)countdownTimer {
    [self.timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(updateCounter:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)updateCounter:(NSTimer *)theTimer {
    if (self.secondsLeft > 0) {
        self.secondsLeft--;
        self.minutes = self.secondsLeft / 60;
        self.seconds = self.secondsLeft % 60;
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", self.minutes, self.seconds];
    } else if (self.secondsLeft == 0) {
        if (self.repeated) {
            self.secondsLeft = self.totalTime * 60;
        } else {
            self.secondsLeft--;
        }
        
    }
}



#pragma mark - Inactive and Active

- (void)saveTimerState {
    NSString *timeString = self.timerLabel.text;
    NSArray *timeComponents = [timeString componentsSeparatedByString:@":"];
    NSString *stopMinutes = timeComponents[0];
    NSString *stopSeconds = timeComponents[1];
    
    
    NSNumber *secondsLeft = [NSNumber numberWithInt:([stopMinutes intValue] * 60 + [stopSeconds intValue])];
    NSUserDefaults *timerDefault = [NSUserDefaults standardUserDefaults];
    [timerDefault setObject:secondsLeft forKey:@"stopSecondsLeft"];
    [timerDefault setObject:[NSDate date] forKey:@"stopSystemTime"];
    [timerDefault setBool:YES forKey:@"isStarted"];
    [timerDefault synchronize];
}

- (void)invokeTimer {
    NSUserDefaults *timerDefault = [NSUserDefaults standardUserDefaults];
    if ([timerDefault boolForKey:@"isStarted"]) {
        NSNumber *stopSecondsLeft = [timerDefault objectForKey:@"stopSecondsLeft"];
        long stopSecondsLeftInt = [stopSecondsLeft integerValue];
        NSDate *stopSystemTime= [timerDefault objectForKey:@"stopSystemTime"];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:stopSystemTime];
        int minutes;
        int seconds;
        if (stopSecondsLeftInt > timeInterval) {
            self.secondsLeft = stopSecondsLeftInt - timeInterval;
            minutes = self.secondsLeft / 60;
            seconds = self.secondsLeft % 60;
            [self countdownTimer];
        } else {
            minutes = 0;
            seconds = 0;
            self.secondsLeft = -1;
        }
        self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    
}



@end
