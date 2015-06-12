//
//  CircularLoaderView.m
//  ImageLoader
//
//  Created by wuxueying on 6/12/15.
//  Copyright (c) 2015 wuxueying. All rights reserved.
//

#import "CircularLoaderView.h"

@implementation CircularLoaderView

- (void)addShaper {
    circlePathLayer = [CAShapeLayer new];
    circleRadius = 20.0;
    circlePathLayer.frame = self.bounds;
    circlePathLayer.lineWidth = 2;
    circlePathLayer.fillColor = [UIColor clearColor].CGColor;
    circlePathLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:circlePathLayer];
    self.backgroundColor = [UIColor whiteColor];
    [self setProgress:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    circlePathLayer.frame = self.bounds;
    circlePathLayer.path = [self circlePath].CGPath;
}

- (CGRect)circleFrame1 {
    CGRect circleFrame = CGRectMake(0, 0, 2*circleRadius, 2*circleRadius);
    circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame);
    circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame);
    return circleFrame;
}

- (UIBezierPath *)circlePath {
    return [UIBezierPath bezierPathWithOvalInRect:[self circleFrame1]];
}

- (void)setProgress:(CGFloat)progress {
    if (progress > 1) {
        circlePathLayer.strokeEnd = 1;
    } else if (progress < 0) {
        circlePathLayer.strokeEnd = 0;
    } else {
        circlePathLayer.strokeEnd = progress;
    }
}

- (void)reveal {
    self.backgroundColor = [UIColor clearColor];
    [self setProgress:1];
    [circlePathLayer removeAnimationForKey:@"strokeEnd"];
    [circlePathLayer removeFromSuperlayer];
    self.superview.layer.mask = circlePathLayer;
    
    // 1
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    float finalRadius = sqrtf((center.x * center.x) + (center.y * center.y));
    float radiusInset = finalRadius - circleRadius;
    CGRect outerRect = CGRectInset([self circleFrame1], -radiusInset, -radiusInset);
    CGPathRef toPath = [UIBezierPath bezierPathWithOvalInRect:outerRect].CGPath;
    
    // 2
    CGPathRef fromPath = circlePathLayer.path;
    CGFloat fromLineWidth = circlePathLayer.lineWidth;
    
    // 3
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    circlePathLayer.lineWidth = 2 * finalRadius;
    circlePathLayer.path = toPath;
    [CATransaction commit];
    
    // 4
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.fromValue = @(fromLineWidth);
    lineWidthAnimation.toValue = @(2 * finalRadius);
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)fromPath;
    pathAnimation.toValue = (__bridge id)toPath;
    
    // 5
    CAAnimationGroup *groupAnimation = [CAAnimationGroup new];
    groupAnimation.duration = 1;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.animations = @[pathAnimation,lineWidthAnimation];
    groupAnimation.delegate = self;
    [circlePathLayer addAnimation:groupAnimation forKey:@"strokeWidth"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.superview.layer.mask = nil;
}

@end
