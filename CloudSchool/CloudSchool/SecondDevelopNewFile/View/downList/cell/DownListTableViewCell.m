//
//  DownListTableViewCell.m
//  woleyi
//
//  Created by ENERGY on 2019/10/15.
//  Copyright © 2019 yushangai. All rights reserved.
//

#import "DownListTableViewCell.h"

@interface DownListTableViewCell ()
@property (nonatomic, strong)UILabel * titleLab;
@property (nonatomic, strong)UIView * lineView;
@end

@implementation DownListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.lineView];
    }return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - 1);
    self.lineView.frame = CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1);
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"举报";
    }return _titleLab;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }return _lineView;
}
- (void)setModel:(NSDictionary *)model{
    _model = model;
    self.titleLab.text = model[@"title"];
}
@end
