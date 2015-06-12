//
//  CustomImageView.m
//  ImageLoader
//
//  Created by wuxueying on 6/12/15.
//  Copyright (c) 2015 wuxueying. All rights reserved.
//

#import "CustomImageView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CircularLoaderView.h"

@implementation CustomImageView

- (void)awakeFromNib {
    CircularLoaderView *progressIndicatorView = [[CircularLoaderView alloc] initWithFrame:CGRectZero];
    [progressIndicatorView addShaper];
    [self addSubview:progressIndicatorView];
    progressIndicatorView.frame = self.bounds;
    progressIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSURL *url = [NSURL URLWithString:@"http://www.raywenderlich.com/wp-content/uploads/2015/02/mac-glasses.jpeg"];
    [self sd_setImageWithURL:url placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [progressIndicatorView setProgress:(float)receivedSize/(float)expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [progressIndicatorView reveal];
    }];
}

@end
