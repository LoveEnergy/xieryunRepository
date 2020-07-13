//
//  BirthDayView.h
//  WideHelp
//
//  Created by ENERGY on 2018/8/22.
//  Copyright © 2018年 ENERGY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndDateView : UIView
- (void)show;
- (void)dismiss;
@property (nonatomic, copy)void(^getDateBlock)(NSString *);
@end
