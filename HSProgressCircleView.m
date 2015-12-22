//
//  HSProgressCircleView.m
//  CodingTest
//
//  Created by HuberySun on 15/12/16.
//  Copyright © 2015年 HuberySun. All rights reserved.
//

#import "HSProgressCircleView.h"
#import "HSCircleView.h"

@interface HSProgressCircleView ()
@property(strong, nonatomic)HSCircleView *circleView;
@end

@implementation HSProgressCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (void)initializeView{
    
    HSCircleView *circleView=[[HSCircleView alloc] initWithFrame:self.bounds];
    self.circleView=circleView;
    [self addSubview:circleView];
    
    _borderWidth=self.circleView.borderWidth;
    _lineWidth=self.circleView.lineWidth;
    _borderColor=self.circleView.borderColor;
    _strokeColor=self.circleView.strokeColor;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor=borderColor;
    self.circleView.borderColor=borderColor;
}

- (void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor=strokeColor;
    self.circleView.strokeColor=strokeColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth=borderWidth;
    self.circleView.borderWidth=borderWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth=lineWidth;
    self.circleView.lineWidth=lineWidth;
}

- (void)setCentralView:(UIView *)centralView {
    if (_centralView != centralView) {
        [_centralView removeFromSuperview];
        _centralView = centralView;
        [self addSubview:_centralView];
    }
}

- (void)setProgress:(CGFloat)progress{
    [self.circleView updateProgress:progress];
}

- (void)layoutSubviews{
//    NSLog(@"HSProgressCircleView' s layoutSubviews has called");
    self.circleView.frame=self.bounds;
}
@end
