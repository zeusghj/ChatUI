//
//  JY_BaseChatRoomCell.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_BaseChatRoomCell.h"
#import "JYModel.h"
#import "JY_ChatBubbleVIew.h"

@interface JY_BaseChatRoomCell ()

//气泡
@property (nonatomic, strong)JY_ChatBubbleView* bubbleView;
//用户名
@property (nonatomic, strong)UILabel* userNameLabel;
//时间戳
@property (nonatomic, strong)UILabel* timeStampLabel;
//用户头像
@property (nonatomic,strong)UIButton *userImageBuuton;
//用户头像位置maker
@property (nonatomic, strong)MASConstraint *userImageMaker;
//msg maker
@property (nonatomic, strong)MASConstraint *msgMaker;
//pic maker
@property (nonatomic, strong)MASConstraint* picMaker;

@end


@implementation JY_BaseChatRoomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bubbleView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.timestampLabel];
        [self.contentView addSubview:self.userImageBuuton];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self updateCellConstraints];
    }
    return self;
}

- (void)updateCellConstraints
{
    [self.userImageBuuton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(35., 35.));
        if (self.msgModel.msgSources) {
            [self.userImageMaker uninstall];
            self.userImageMaker = make.right.equalTo(self.contentView).offset(-10);
        }else {
            [self.userImageMaker uninstall];
            self.userImageMaker = make.left.equalTo(self.contentView).offset(10);
        }
        if (!self.msgModel.showTimestamp) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
        }else {
            make.top.equalTo(self.contentView.mas_top).offset(28);
        }
    }];
    
    [self.timestampLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.width.equalTo(SCREEN_WIDTH);
        make.top.equalTo(0);
    }];
    
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImageBuuton.mas_top).offset(-1);
        make.left.equalTo(self.userImageBuuton.mas_right).offset(10);
        make.right.lessThanOrEqualTo(SCREEN_WIDTH *.5 - 50);
        make.height.equalTo(16);
    }];
    
    [self.bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if (self.msgModel.msgSources) {
            [self.msgMaker uninstall];
            self.msgMaker = make.right.equalTo(self.userImageBuuton.mas_left).offset(-10);
        }else {
            [self.msgMaker uninstall];
            self.msgMaker = make.left.equalTo(self.userImageBuuton.mas_right).offset(10);
        }
        
        if (self.msgModel.msgSources) {
            make.top.equalTo(self.userImageBuuton.mas_top).priorityHigh();
        }else {
            make.top.mas_equalTo(self.userImageBuuton.mas_top).offset(15).priorityHigh();
        }
        
        if (self.msgModel) {
            
            if (self.msgModel.msg_Type != JY_ChatRoomTypePicture) {
                [self.picMaker uninstall];
                self.picMaker = make.width.mas_equalTo(self.msgModel.cacheMsgSize.width + 30);
            }else {
                [self.picMaker uninstall];
            }
        }
        
    }];
}

#pragma mark - setter and getter
- (void)setMsgModel:(JYModel *)msgModel
{
    if (_msgModel == msgModel) {
        _msgModel = nil;
        return;
    }
    _msgModel = msgModel;
    
    [self.userImageBuuton setImage:[UIImage imageNamed:msgModel.userIcon] forState:UIControlStateNormal];
    self.userNameLabel.text = msgModel.userName;
    self.userNameLabel.hidden = msgModel.msgSources;
    self.timestampLabel.text = msgModel.timestamp;
    self.timestampLabel.hidden = !msgModel.showTimestamp;
    [self updateCellConstraints];
    self.bubbleView.msgModel = msgModel;
    
}

- (UIButton *)userImageBuuton
{
    if (!_userImageBuuton) {
        _userImageBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
        _userImageBuuton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    return _userImageBuuton;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont systemFontOfSize:13.];
    }
    return _userNameLabel;
}

- (JY_ChatBubbleView *)bubbleView
{
    if (!_bubbleView) {
        _bubbleView = [[JY_ChatBubbleView alloc] init];
    }
    return _bubbleView;
}

- (UILabel *)timestampLabel
{
    if (!_timeStampLabel) {
        _timeStampLabel = [[UILabel alloc] init];
        _timeStampLabel.textAlignment = NSTextAlignmentCenter;
        _timeStampLabel.textColor = RGBCOLOR(148, 148, 148, 1);
        _timeStampLabel.font = [UIFont systemFontOfSize:15.];
    }
    return _timeStampLabel;
}

@end
