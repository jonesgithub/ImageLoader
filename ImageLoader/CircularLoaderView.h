//
//  CircularLoaderView.h
//  ImageLoader
//
//  Created by wuxueying on 6/12/15.
//  Copyright (c) 2015 wuxueying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularLoaderView : UIView {
    CAShapeLayer *circlePathLayer;
    CGFloat circleRadius;
}

- (void)addShaper;
- (void)setProgress:(CGFloat)progress;
- (void)reveal;

@end
