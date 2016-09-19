//
//  JY_ChatBubbleVIew.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatBubbleView.h"
#import "JYModel.h"
#import "JY_ChatBubbleTextView.h"
#import "JY_ChatBubblePictureView.h"
#import "JY_ChatBubbleVoiceView.h"

@interface JY_ChatBubbleView ()

//纯文本
@property (nonatomic, strong)JY_ChatBubbleTextView* textView;
////图片
@property (nonatomic, strong)JY_ChatBubblePictureView* pictureView;
//voice
@property (nonatomic, strong)JY_ChatBubbleVoiceView* voiceView;

@property (nonatomic, strong)NSMutableArray* subViewArray;

@end

@implementation JY_ChatBubbleView

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.pictureView];
        [self addSubview:self.textView];
        [self addSubview:self.voiceView];
        [self.subViewArray addObject:self.textView];
        [self.subViewArray addObject:self.pictureView];
        [self.subViewArray addObject:self.voiceView];
        [self updateViewConstraints];
    }
    return self;
}

- (void)updateViewConstraints
{
    if ([self.textView superview]) {
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    if ([self.pictureView superview]) {
        [self.pictureView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    if ([self.voiceView superview]) {
        [self.voiceView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (void)removeFromSuperviewWithOutView:(UIView *)subView
{
    [self.subViewArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![subView isEqual:obj]) {
            [obj removeFromSuperview];
        }
    }];
    
    if (![subView superview]) {
        [self addSubview:subView];
    }
}

#pragma mark - setter 赋值
- (void)setMsgModel:(JYModel *)msgModel
{
    
    _msgModel = msgModel;
    
    switch (msgModel.msg_Type) {
        case JY_ChatMessageTypeText:
        {
            [self removeFromSuperviewWithOutView:self.textView];
            [self updateViewConstraints];
            self.textView.model = msgModel;
        }
            break;
        case JY_ChatRoomTypePicture:
        {
            [self removeFromSuperviewWithOutView:self.pictureView];
            [self updateViewConstraints];
            self.pictureView.model = msgModel;
        }
            break;
        case JY_ChatRoomTypeVoice:
        {
            [self removeFromSuperviewWithOutView:self.voiceView];
            [self updateViewConstraints];
            self.voiceView.model = msgModel;
        }
        default:
            break;
    }
    
}

#pragma mark - getter

- (JY_ChatBubblePictureView *)pictureView
{
    if (!_pictureView) {
        _pictureView = [[JY_ChatBubblePictureView alloc] init];
    }
    return _pictureView;
}

- (JY_ChatBubbleTextView *)textView
{
    if (!_textView) {
        _textView = [[JY_ChatBubbleTextView alloc] init];
    }
    return _textView;
}

- (JY_ChatBubbleVoiceView *)voiceView {
    if (!_voiceView) {
        _voiceView = [[JY_ChatBubbleVoiceView alloc] init];
    }
    return _voiceView;
}

- (NSMutableArray *)subViewArray
{
    if (!_subViewArray) {
        _subViewArray = [NSMutableArray array];
    }
    return _subViewArray;
}

@end
