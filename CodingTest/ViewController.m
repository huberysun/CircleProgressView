//
//  ViewController.m
//  CodingTest
//
//  Created by HuberySun on 15/12/13.
//  Copyright © 2015年 HuberySun. All rights reserved.
//

#import "ViewController.h"
#import "HSProgressCircleView.h"
#import "Masonry.h"

@interface ViewController ()<NSURLConnectionDataDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlTextfield;
@property(strong, nonatomic)HSProgressCircleView *hsProgressCircleView;

@property(nonatomic)CGFloat progress;

@property(strong, nonatomic)NSURLConnection *urlConnection;
@property(nonatomic)long long expectedContentLength;
@property(nonatomic)long long receivedContentLength;
@property(strong, nonatomic)NSString *suggestedFileName;
@property(strong, nonatomic)NSMutableData *receivedData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置网址输入框的代理
    self.view.backgroundColor=[UIColor yellowColor];
    self.urlTextfield.delegate=self;
    
    //给view添加单击手势事件监听，点击view的时候，隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //构建进度条
    HSProgressCircleView *hsProgressCircleView=[[HSProgressCircleView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    hsProgressCircleView.center=self.view.center;
    hsProgressCircleView.clipsToBounds=YES;
    hsProgressCircleView.borderColor=[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    hsProgressCircleView.borderWidth=3.0;
    self.hsProgressCircleView=hsProgressCircleView;
    
    //If this property’s value is YES, the system creates a set of constraints that duplicate the behavior specified by the view’s autoresizing mask. This also lets you modify the view’s size and location using the view’s frame, bounds, or center properties, allowing you to create a static, frame-based layout within Auto Layout.
   // Note that the autoresizing mask constraints fully specify the view’s size and position; therefore, you cannot add additional constraints to modify this size or position without introducing conflicts. If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to NO, and then provide a non ambiguous, nonconflicting set of constraints for the view.
    //translatesAutoresizingMaskIntoConstraints属性设置为YES，系统将会根据autoResizing mask指定行为创建一系列布局约束。当然，仍然可以通过frame／bounds／center等属性改变视图的尺寸和位置，但是，我们不能再为视图添加NSLayoutConstraint布局约束对象，因为，autoResizing Mask和 NSLayoutConstraint都属于自动布局机制，这样会产生冲突，所以，当我们想使用AutoLayout布局的时候，应该设置translatesAutoresizingMaskIntoConstaints为NO。
    UIImageView *imageView=[[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints=NO;
    imageView.image=[UIImage imageNamed:@"loading_bg2"];
    self.hsProgressCircleView.centralView=imageView;
    [self autoLayoutSubview:imageView];
}

- (void)autoLayoutSubview:(UIView *)subView{
    CGFloat inset=self.hsProgressCircleView.borderWidth+self.hsProgressCircleView.lineWidth;
    
    //Available in iOS 8.0 and later.
    //Note that only active constraints affect the calculated layout. For newly created constraints, the active property is NO by default.
    //When developing for iOS 8.0 or later, set the constraint’s active property to YES instead. This automatically adds the constraint to the correct view.
    NSLayoutConstraint *topConstraint=[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hsProgressCircleView attribute:NSLayoutAttributeTop multiplier:1.0 constant:inset];
    NSLayoutConstraint *leftConstraint=[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hsProgressCircleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:inset];
    NSLayoutConstraint *bottomConstraint=[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.hsProgressCircleView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-inset];
    NSLayoutConstraint *rightConstraint=[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.hsProgressCircleView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-inset];
    topConstraint.active=YES;
    leftConstraint.active=YES;
    bottomConstraint.active=YES;
    rightConstraint.active=YES;
    
    //ios8之前，需要使用addConstraints把NSLayoutConstraint添加到view中，ios 8之后，设置NSLayoutConstraint的属性active为YES，会直接将布局约束对象添加到相应的视图对象中。
    //[self.hsProgressCircleView addConstraints:@[topConstraint,leftConstraint,bottomConstraint,rightConstraint]];
}

- (void)layoutSubviewWithMesonry:(UIView *)subView{
    CGFloat boderWidth=self.hsProgressCircleView.borderWidth+self.hsProgressCircleView.lineWidth;
    UIEdgeInsets padding=UIEdgeInsetsMake(boderWidth, boderWidth, boderWidth, boderWidth);
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.hsProgressCircleView).with.insets(padding);
    }];
}

- (void)changeLoadingViewFrame{
    NSLog(@"change view property which is associated with frame");
    self.hsProgressCircleView.frame=CGRectMake(0, 0, 200, 200);
    self.hsProgressCircleView.center=self.view.center;
}

- (void)tapSuperView:(UITapGestureRecognizer *)gestureRecognier{
    [self.urlTextfield resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.urlTextfield resignFirstResponder];
    return YES;
}

- (IBAction)downloadFileAtPath:(id)sender {
    //    NSString *urlStr=@"https://codeload.github.com/rs/SDWebImage/zip/master";
    NSString *urlStr=self.urlTextfield.text;
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:url];
    NSURLConnection *urlConnection=[NSURLConnection connectionWithRequest:urlRequest delegate:self];
    self.urlConnection=urlConnection;
    [urlConnection start];
    
    // 验证添加自动布局之后，子视图imageView的frame是否会跟随父视图HSProgressCircleView 的frame改变而变化
    //[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeLoadingViewFrame) userInfo:nil repeats:NO];
}

//请求数据成功获取服务器的响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.receivedData=[NSMutableData data];
    self.receivedContentLength=0;
    self.expectedContentLength=response.expectedContentLength;
    self.suggestedFileName=response.suggestedFilename;
    [self.view addSubview:self.hsProgressCircleView];
}

//接受数据的过程，会不断调用这个委托方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    self.receivedContentLength+=data.length;
    [self.receivedData appendData:data];
    CGFloat progress=self.receivedContentLength*1.0/self.expectedContentLength;
    [self.hsProgressCircleView setProgress:progress];
}

//数据接收完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSString *documentPath= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedFilePath=[documentPath stringByAppendingPathComponent:self.suggestedFileName];
    [self.receivedData writeToFile:savedFilePath atomically:YES];
    NSLog(@"%@",@"did finish loading");
    
    [self.hsProgressCircleView removeFromSuperview];
}

//数据请求发生异常
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    
    [self.hsProgressCircleView removeFromSuperview];
}
@end
