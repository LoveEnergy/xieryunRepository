//
//  CommentView.m
//  WJTheWishPro
//
//  Created by 杜文杰 on 2018/1/22.
//  Copyright © 2018年 dwj. All rights reserved.
//

#import "ReplyView.h"

#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && SCREEN_HEIGHT >= 812.0)
#define NAVI_HEIGHT (Is_Iphone_X ? 88 : 64)
#define BOTTOM_HEIGHT (Is_Iphone_X ? 34 : 0)
#define WIDTH_6_SCALE 375.0 * [UIScreen mainScreen].bounds.size.width
#define HEIGHT_6_SCALE 667.0 * [UIScreen mainScreen].bounds.size.height
//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ReplyView()<UITextFieldDelegate>
//@property (nonatomic,strong) UITextField *commentTextField;//评论输入框
@property (nonatomic, strong)UIButton *sendBtn;
@property (nonatomic, strong)UIView * shadowView;
@end

@implementation ReplyView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        CALayer *lineLayer = [CALayer layer];
//        lineLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, .5);
//        lineLayer.backgroundColor =  [UIColor colorWithRed:(float)(225/255.0f) green:(float)(225/255.0f) blue:(float)(225/255.0f) alpha:1.0f].CGColor;
//        [self.layer addSublayer:lineLayer];
//
        [self addSubview:self.shadowView];
        [self addSubview:self.commentTextField];
        [self addSubview:self.sendBtn];
        
        //键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
#pragma mark -Event
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.commentTextField resignFirstResponder];//关闭键盘，拿到缩写内容
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self.commentTextField resignFirstResponder];//关闭键盘
    return YES;
}
/**
 评论点击事件
 */
- (void)sendCommentEvent{
    [self.commentTextField becomeFirstResponder];
    if ([self.commentTextField.text isEqualToString:@""] || !self.commentTextField.text) {
//        [self makeToast:@"请输入内容" duration:1 position:CSToastPositionCenter];
        return;
    }
    if (self.replyViewBlock) {
        self.replyViewBlock(self.commentTextField.text, self);
    }
    [self endEditing:YES];
}
/**
 监听键盘出现
 param aNotification
 */
- (void)keyboardWasShown:(NSNotification*)aNotification{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 51/WIDTH_6_SCALE - keyBoardFrame.size.height, SCREEN_WIDTH, 51/WIDTH_6_SCALE);
    }];
}
/**
 监听键盘消失
 param aNotification
 */
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    CGFloat duration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT - 51/WIDTH_6_SCALE, SCREEN_WIDTH, 51/WIDTH_6_SCALE);
    }];
    self.commentTextField.text = @"";
}
#pragma mark -init
- (UITextField *)commentTextField{
    if (!_commentTextField) {
        _commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.5/WIDTH_6_SCALE, 10/WIDTH_6_SCALE, SCREEN_WIDTH - 93.5/WIDTH_6_SCALE - 5/WIDTH_6_SCALE, 31/WIDTH_6_SCALE)];
//        _commentTextField.borderStyle = UITextBorderStyleRoundedRect;
        _commentTextField.placeholder = @"有问题，随时向讲师提问...";
        _commentTextField.font = [UIFont systemFontOfSize:12];
        _commentTextField.delegate = self;
        _commentTextField.returnKeyType = UIReturnKeyDone;
        _commentTextField.backgroundColor = [UIColor clearColor];
    }return _commentTextField;
}
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.commentTextField.frame) - 5/WIDTH_6_SCALE, CGRectGetMinY(self.commentTextField.frame), self.commentTextField.frame.size.width + 5/WIDTH_6_SCALE, self.commentTextField.frame.size.height)];
        _shadowView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _shadowView.layer.shadowColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:0.23].CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0,2);
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowRadius = 6;
        _shadowView.layer.cornerRadius = 14.5;
        _shadowView.backgroundColor = [UIColor whiteColor];
    }return _shadowView;
}
- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentTextField.frame)+19.5/WIDTH_6_SCALE, 10/WIDTH_6_SCALE, 46/WIDTH_6_SCALE, 31/WIDTH_6_SCALE)];
        _sendBtn.backgroundColor = [UIColor colorWithRed:3/255.0 green:120/255.0 blue:253/255.0 alpha:1.0];
        [_sendBtn addTarget:self action:@selector(sendCommentEvent) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setImage:[UIImage imageNamed:@"sendMSG"] forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 14/WIDTH_6_SCALE;
        _sendBtn.layer.masksToBounds = YES;
    }return _sendBtn;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end

