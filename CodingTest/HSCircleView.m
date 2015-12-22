//
//  HSCircleView.m
//  CodingTest
//
//  Created by HuberySun on 15/12/18.
//  Copyright © 2015年 HuberySun. All rights reserved.
//

#import "HSCircleView.h"

@interface HSCircleView()
@property(strong, nonatomic)CAShapeLayer *shapeLayer;
@end

@implementation HSCircleView

+ (Class)layerClass{
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer{
    return (CAShapeLayer *)self.layer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _borderWidth=2.0;
        _lineWidth=2.0;
        _borderColor=[UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0];
        _strokeColor=[UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0];
        
        [self initializeView];
    }
    return self;
}

- (void)layoutSubviews{
    NSLog(@"circleView layout subviews");
    [self initializeView];
}

- (void)initializeView{
    //配置layer的边框
    CGFloat radiusWidth=self.frame.size.width/2.0;
    self.shapeLayer.cornerRadius=radiusWidth;
    self.shapeLayer.masksToBounds=YES;
    self.shapeLayer.fillColor=[UIColor clearColor].CGColor;
    self.shapeLayer.borderWidth=_borderWidth;
    self.shapeLayer.borderColor=_borderColor.CGColor;
    
    const double TWO_M_PI = 2.0 * M_PI;
    const double startAngle = -0.25 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI;
    //配置layer的路径
    CGFloat arcRadius=self.frame.size.width/2.0-_borderWidth-_lineWidth/2.0;
    UIBezierPath *circlePath=[UIBezierPath bezierPathWithArcCenter:CGPointMake(radiusWidth, radiusWidth) radius:arcRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.shapeLayer.path=circlePath.CGPath;
    self.shapeLayer.strokeColor=_strokeColor.CGColor;
    self.shapeLayer.lineWidth=_lineWidth;
    self.shapeLayer.strokeStart=0.0;
}

- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor=borderColor;
    self.shapeLayer.borderColor=borderColor.CGColor;
}

- (void)setStrokeColor:(UIColor *)strokeColor{
    _strokeColor=strokeColor;
    self.shapeLayer.strokeColor=strokeColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth=borderWidth;
    self.shapeLayer.borderWidth=borderWidth;
    [self setNeedsLayout];
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth=lineWidth;
    self.shapeLayer.lineWidth=lineWidth;
    [self setNeedsLayout];
}

// 更新layer的path图形的结尾点位置
- (void)updateProgress:(CGFloat)progress{
    progress=MAX(0, MIN(1, progress));
    self.shapeLayer.strokeEnd=progress;
}
@end
