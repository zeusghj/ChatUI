//
//  JY_ChatBubbleBaseView.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatBubbleBaseView.h"

@implementation JY_ChatBubbleBaseView

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.bubbleImageView];
        
        [self.bubbleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return self;
}

- (void)setMsgSources:(BOOL)msgSources
{
    _msgSources = msgSources;
    UIImage *img = nil;
    if (msgSources) {
        img = [UIImage imageNamed:@"bubble_right"];
    }else {
        img = [UIImage imageNamed:@"bubble_left"];
    }
    self.bubbleImageView.image = [img resizableImageWithCapInsets:UIEdgeInsetsMake(30, 13, 30, 13)
                                                    resizingMode:UIImageResizingModeStretch];
}

- (UIImageView *)bubbleImageView
{
    if (!_bubbleImageView) {
        _bubbleImageView = [[UIImageView alloc] init];
    }
    return _bubbleImageView;
}

@end
