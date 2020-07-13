//
//  DownListView.m
//  woleyi
//
//  Created by ENERGY on 2019/10/15.
//  Copyright © 2019 yushangai. All rights reserved.
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

#import "DownListView.h"
#import "DownListTableViewCell.h"
@interface DownListView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *  tableView;
@property (nonatomic, assign)CGRect Fframe;

@end

@implementation DownListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.Fframe = frame;
        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
//        [self.cellArray removeAllObjects];
//        self.cellArray = array;
        [self addSubview:self.tableView];
        
    }return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.Fframe.size.width, self.Fframe.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 30/WIDTH_6_SCALE;
        [_tableView registerClass:[DownListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DownListTableViewCell class])];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
    }return _tableView;
}
- (void)showView{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:.15 animations:^{
        self.alpha = 1;
    }];
}
- (void)closeView{
    [UIView animateWithDuration:.15 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark  - UITabelViewDelegate和UItableViewDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DownListTableViewCell class]) forIndexPath:indexPath];
//    cell.model = self.cellArray[indexPath.row];
//    cell.layer.shouldRasterize = YES;
//    cell.layer.rasterizationScale = [UIScreen  mainScreen].scale;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.cellArray.count;
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (self.downListSelect) {
            self.downListSelect();
        }
    }
    if (indexPath.row == 1) {
        if (self.downListScreen) {
            self.downListScreen();
        }
    }
}
@end
