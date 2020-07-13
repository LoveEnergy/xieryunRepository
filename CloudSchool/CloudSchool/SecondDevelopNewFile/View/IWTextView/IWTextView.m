//
//  IWTextView.m
//  ItcastWeibo
//
//  Created by apple on 14-5-19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && SCREEN_HEIGHT >= 812.0)
#define NAVI_HEIGHT (Is_Iphone_X ? 88 : 64)
#define BOTTOM_HEIGHT (Is_Iphone_X ? 34 : 0)
#define WIDTH_6_SCALE 375.0 * [UIScreen mainScreen].bounds.size.width
#define HEIGHT_6_SCALE 667.0 * [UIScreen mainScreen].bounds.size.height
//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "IWTextView.h"

@interface IWTextView()
@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation IWTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加提示文字
        UILabel *placeholderLabel = [[UILabel alloc] init];
//        placeholderLabel.textColor = getColor(@"cacaca");
        placeholderLabel.textColor = [UIColor redColor];
        
        placeholderLabel.hidden = YES;
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.font = self.font;
        [self insertSubview:placeholderLabel atIndex:0];
        self.placeholderLabel = placeholderLabel;
        
        // 2.监听textView文字改变的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    // 1.添加提示文字
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.textColor = [UIColor redColor];
    
    placeholderLabel.hidden = YES;
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.font = self.font;
    [self insertSubview:placeholderLabel atIndex:0];
    self.placeholderLabel = placeholderLabel;
    
    // 2.监听textView文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    if (placeholder.length) { // 需要显示
        self.placeholderLabel.hidden = NO;
        
        // 计算frame
        CGFloat placeholderX = 5/WIDTH_6_SCALE;
        CGFloat placeholderY = 9/WIDTH_6_SCALE;
        CGFloat maxW = self.frame.size.width - 2 * placeholderX;
        CGFloat maxH = self.frame.size.height - 2 * placeholderY;
        CGSize placeholderSize = [placeholder sizeWithFont:self.placeholderLabel.font constrainedToSize:CGSizeMake(maxW, maxH)];
        self.placeholderLabel.frame = CGRectMake(placeholderX, placeholderY, placeholderSize.width, placeholderSize.height);
    } else {
        self.placeholderLabel.hidden = YES;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.placeholder = self.placeholder;
}

- (void)textDidChange
{
    self.placeholderLabel.hidden = (self.text.length != 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
