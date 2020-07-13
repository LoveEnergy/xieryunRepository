//
//  DownListView.h
//  woleyi
//
//  Created by ENERGY on 2019/10/15.
//  Copyright © 2019 yushangai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownListView : UIView
- (void)showView;
- (void)closeView;
@property (nonatomic, strong)NSMutableArray * cellArray;
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, strong)void(^downListSelect)(void);//举报
@property (nonatomic, strong)void(^downListScreen)(void);//屏蔽

@end

NS_ASSUME_NONNULL_END
