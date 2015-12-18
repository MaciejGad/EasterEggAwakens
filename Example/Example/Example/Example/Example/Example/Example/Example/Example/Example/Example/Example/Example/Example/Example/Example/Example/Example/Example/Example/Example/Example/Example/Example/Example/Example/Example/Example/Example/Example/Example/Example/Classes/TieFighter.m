//
//  TieFighter.m
//  Binary Attack
//
//  Created by Maciej Gad on 18.12.2015.
//  Copyright © 2015 All in Mobile. All rights reserved.
//

#import "TieFighter.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TieFighter ()
@property (assign, nonatomic) SystemSoundID audioEffect;
@property (assign, nonatomic) SystemSoundID blasterSound;
@property (strong, nonatomic) NSMutableArray *blasters;
@property (assign, nonatomic) BOOL mirror;
@property (assign, nonatomic) BOOL shouldFire;
@end

@implementation TieFighter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.image = [UIImage imageNamed:@"tie_fighter"];
        [self sizeToFit];
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"tie_fighter" ofType:@"m4a"];
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &_audioEffect);
        //blaster.m4a
        NSString *pathBlaster  = [[NSBundle mainBundle] pathForResource:@"blaster" ofType:@"m4a"];
        NSURL *pathURLBlaster = [NSURL fileURLWithPath : pathBlaster];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURLBlaster, &_blasterSound);
        self.blasters = [NSMutableArray new];
    }
    return self;
}


- (void)dealloc{
    AudioServicesDisposeSystemSoundID(_audioEffect);
    _audioEffect = 0;
    AudioServicesDisposeSystemSoundID(_blasterSound);
    _blasterSound = 0;
    for (CALayer *layer in self.blasters) {
        [layer removeFromSuperlayer];
    }
}

- (void)flight {

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.mirror = (BOOL) arc4random_uniform(2);
    self.shouldFire = (BOOL) arc4random_uniform(2);
    if (self.mirror) {
        self.center = CGPointMake(screenSize.width, 0);
        self.transform = CGAffineTransformMakeScale(-0.1, 0.1);
    } else {
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.center = CGPointMake(0, 0);
    }
    
    if (self.shouldFire) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fire];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self fire];
            });
        });
    }
    
    
    AudioServicesPlaySystemSound(_audioEffect);
    [UIView animateWithDuration:7.5 animations:^{
        if (self.mirror) {
            self.transform = CGAffineTransformMakeScale(-1, 1);
            self.center = CGPointMake(-CGRectGetWidth(self.bounds), screenSize.height+  CGRectGetHeight(self.bounds));
        } else {
            self.transform = CGAffineTransformIdentity;
            self.center = CGPointMake(screenSize.width + CGRectGetWidth(self.bounds), screenSize.height+  CGRectGetHeight(self.bounds));

        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

static inline CGPoint CGPointAddPoint(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

- (void)fire {
    CALayer *presentationLayer = self.layer.presentationLayer;
    AudioServicesPlaySystemSound(_blasterSound);
    CGPoint start = CGPointZero;
    CGPoint end = CGPointZero;
    if (self.mirror) {
        start = CGPointAddPoint(presentationLayer.position, CGPointMake(-20, 20));
        end = CGPointAddPoint(start, CGPointMake(-1000, 1000));
    } else {
        start = CGPointAddPoint(presentationLayer.position, CGPointMake(20, 20));
        end = CGPointAddPoint(start, CGPointMake(1000, 1000));

    }
    
    CAShapeLayer *shape = [self animatedLineFrom:start to:end];
    [self.blasters addObject:shape];
    [self.superview.layer addSublayer:shape];
}

- (CAShapeLayer *)animatedLineFrom:(CGPoint)from to:(CGPoint)to {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:from];
    [linePath addLineToPoint:to];
    CAShapeLayer *line = [CAShapeLayer layer];
    line.path = linePath.CGPath;
    line.lineCap = kCALineCapRound;
    line.strokeColor = [UIColor greenColor].CGColor;
    line.strokeEnd = 0;
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animation];
    strokeEndAnimation.fromValue = @0;
    strokeEndAnimation.toValue = @1;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    strokeEndAnimation.duration = 1;
    [line addAnimation:strokeEndAnimation forKey:@"strokeEnd"];
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animation];
    strokeStartAnimation.fromValue = @0;
    strokeStartAnimation.toValue = @1;
    strokeStartAnimation.duration = 1;
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
    strokeStartAnimation.beginTime = CACurrentMediaTime() +  0.05;
    strokeEndAnimation.delegate = self;
    [line addAnimation:strokeStartAnimation forKey:@"strokeStart"];
    return line;
}

@end
