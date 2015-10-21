//
//  UserLoginView.m
//  WeCommunity
//
//  Created by Harry on 7/31/15.
//  Copyright (c) 2015 Harry. All rights reserved.
//

#import "UserLoginView.h"

@implementation UserLoginView

//设置坐标
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat heignt = 50;
        CGFloat width = frame.size.width;
        
        self.tellField = [[UITextField alloc] init];
        self.tellField.frame = CGRectMake(0, 0, width, heignt);
        self.tellField.placeholder = @"请输入手机号";
        self.tellField.keyboardType = UIKeyboardTypeNumberPad;
        [self.tellField setBorderStyle:UITextBorderStyleRoundedRect];
        [self addSubview:self.tellField];
        
        self.passwordField1 = [[UITextField alloc] init];
        self.passwordField1.frame = CGRectMake(0, self.tellField.frame.size.height +self.tellField.frame.origin.y+5, width, heignt);
        self.passwordField1.placeholder = @"请输入密码";
        [self.passwordField1 setBorderStyle:UITextBorderStyleRoundedRect];
        self.passwordField1.secureTextEntry = YES;
        [self addSubview:self.passwordField1];
        
        self.passwordField2 = [[UITextField alloc] init];
        [self.passwordField2 setBorderStyle:UITextBorderStyleRoundedRect];
        self.passwordField2.secureTextEntry = YES;
        [self addSubview:self.passwordField2];
        
        self.captchaField = [[UITextField alloc] init];
        [self.captchaField setBorderStyle:UITextBorderStyleRoundedRect];
        self.captchaField.keyboardType = UIKeyboardTypeNumberPad;
        self.captchaField.placeholder = @"请输入验证码";
        [self addSubview:self.captchaField];
        
        self.captchaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.captchaBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.captchaBtn setBackgroundColor:[UIColor orangeColor]];
        [self.captchaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.captchaBtn];
        
        self.mainBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.mainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mainBtn setBackgroundColor:[UIColor orangeColor]];
        [self.mainBtn roundRect];
        [self addSubview:self.mainBtn];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.leftBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:self.leftBtn];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.rightBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:self.rightBtn];
    }
    return self;
}

-(void)setupcaptchaBtn{
    self.captchaBtn.frame = CGRectMake(self.captchaField.frame.size.width + 10, self.captchaField.frame.origin.y+10, 90, 30);
}


-(void)configureLoginView{
    
    self.leftBtn.frame = CGRectMake(0, self.passwordField1.frame.size.height+self.passwordField1.frame.origin.y+20, 60, 20);
    self.rightBtn.frame = CGRectMake(self.frame.size.width-80, self.passwordField1.frame.size.height+self.passwordField1.frame.origin.y+20, 80, 20);
    
    self.mainBtn.frame = CGRectMake(30, self.passwordField1.frame.size.height+self.passwordField1.frame.origin.y+60, self.frame.size.width-60, 40);
    [self.mainBtn setTitle:@"登陆" forState:UIControlStateNormal];

}

-(void)configureForgetView{
    self.passwordField1.placeholder = @"请输入新密码";
    
    self.captchaField.frame = CGRectMake(0,self.passwordField1.frame.size.height+self.passwordField1.frame.origin.y+5, self.passwordField1.frame.size.width-120, self.passwordField1.frame.size.height);
    [self setupcaptchaBtn];
    
    self.mainBtn.frame = CGRectMake(30, self.captchaField.frame.size.height+self.captchaField.frame.origin.y+15, self.frame.size.width-60, 40);
    [self.mainBtn setTitle:@"重置" forState:UIControlStateNormal];
}

-(void)configureRegisterView{
    self.passwordField2.frame = CGRectMake(0, self.passwordField1.frame.size.height+self.passwordField1.frame.origin.y+5, self.passwordField1.frame.size.width, self.passwordField1.frame.size.height);
    self.passwordField2.placeholder = @"请再次输入密码";
    
    self.captchaField.frame = CGRectMake(0,self.passwordField2.frame.size.height+self.passwordField2.frame.origin.y+5, self.passwordField2.frame.size.width-120, self.passwordField2.frame.size.height);
    [self setupcaptchaBtn];
    
    self.mainBtn.frame = CGRectMake(30, self.captchaField.frame.size.height+self.captchaField.frame.origin.y+15, self.frame.size.width-60, 40);
    [self.mainBtn setTitle:@"注册" forState:UIControlStateNormal];

}


@end