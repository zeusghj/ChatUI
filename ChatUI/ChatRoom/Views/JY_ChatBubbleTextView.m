//
//  JY_ChatBubbleTextView.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatBubbleTextView.h"

@interface JY_ChatBubbleTextView ()

@property (nonatomic,strong)UILabel *msgTextLabel;

@end

@implementation JY_ChatBubbleTextView

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.msgTextLabel];
        [self updateViewConstraint];
    }
    return self;
}

- (void)updateViewConstraint
{
    [self.msgTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    //label的抗被拉伸的优先级提高
    [self.msgTextLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.msgTextLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)setModel:(JYModel *)model {
    _model = model;
    
    NSString* msgText = model.msg;
    self.msgTextLabel.text = msgText;
    
    self.msgSources = model.msgSources;
}

- (UILabel *)msgTextLabel
{
    if (!_msgTextLabel) {
        _msgTextLabel = [[UILabel alloc] init];
        _msgTextLabel.font = [UIFont systemFontOfSize:15.];
        _msgTextLabel.numberOfLines = 0;
    }
    return _msgTextLabel;
}

@end
