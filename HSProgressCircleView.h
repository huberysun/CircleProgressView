//
//  HSProgressCircleView.h
//  CodingTest
//
//  Created by HuberySun on 15/12/16.
//  Copyright © 2015年 HuberySun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSProgressCircleView : UIView
@property(strong, nonatomic)UIColor *borderColor;
@property(strong, nonatomic)UIColor *strokeColor;
@property(nonatomic)CGFloat borderWidth;
@property(nonatomic)CGFloat lineWidth;
@property(strong, nonatomic)UIView *centralView;

- (void)setProgress:(CGFloat)progress;
@end
