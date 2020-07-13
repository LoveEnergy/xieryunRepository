//
//  CommentView.h
//  WJTheWishPro
//
//  Created by 杜文杰 on 2018/1/22.
//  Copyright © 2018年 dwj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReplyViewBlock)(NSString * str, UIView * sendView);
@interface ReplyView : UIView
//@property (nonatomic, strong) NSString *btnName;
//@property (nonatomic, strong) NSString *textFiledName;
@property (nonatomic, copy)ReplyViewBlock replyViewBlock;
@property (nonatomic,strong) UITextField *commentTextField;//评论输入框

@end
