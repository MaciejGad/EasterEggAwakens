//
//  Force.m
//  Binary Attack
//
//  Created by Maciej Gad on 18.12.2015.
//  Copyright © 2015 All in Mobile. All rights reserved.
//

#import "Force.h"
#import "TieFighter.h"
#import "AIMNotificationObserver.h"

@interface Force ()
@property (strong, nonatomic) AIMNotificationObserver *observer;
@end

@implementation Force

+ (void)load {
    [Force May_the_Force_be_with_you];
}

+ (instancetype)May_the_Force_be_with_you {
    static dispatch_once_t onceToken;
    static Force *darkSide;
    dispatch_once(&onceToken, ^{
        darkSide = [Force new];
    });
    return darkSide;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.observer = [AIMNotificationObserver observeName:UIApplicationDidFinishLaunchingNotification onChange:^(NSNotification *notification) {
            [Force awakens];
        }];
    }
    return self;
}

+ (void)awakens {
    NSInteger startTime = arc4random_uniform(5) + 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(startTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TieFighter *tieFighter = [TieFighter new];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:tieFighter];
        [tieFighter flight];
        NSInteger startTime = arc4random_uniform(10) + 5;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(startTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [Force awakens];
        });
    });
}



@end
