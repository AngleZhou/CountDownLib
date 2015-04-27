//
//  CountDownTimer.h
//  countdownDemo
//
//  Created by Qian Zhou on 15/4/24.
//  Copyright (c) 2015年 Qian Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownTimer : UIViewController

@property (nonatomic) int totalTime; //in minutes, user sets

- (void)startTimer;
@end

