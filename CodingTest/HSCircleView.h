//
//  HSCircleView.h
//  CodingTest
//
//  Created by HuberySun on 15/12/18.
//  Copyright © 2015年 HuberySun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCircleView : UIView

@property(strong, nonatomic)UIColor *borderColor;//边框颜色
@property(strong, nonatomic)UIColor *strokeColor;//内圈颜色
@property(nonatomic)CGFloat borderWidth;//边框宽度
@property(nonatomic)CGFloat lineWidth;//内圈宽度

- (void)updateProgress:(CGFloat)progress;//改变进度条进度
@end
