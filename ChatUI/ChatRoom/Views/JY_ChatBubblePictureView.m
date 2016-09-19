//
//  JY_ChatBubblePictureView.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatBubblePictureView.h"
#import "JY_Constants.h"

@interface JY_ChatBubblePictureView  ()

@property (nonatomic, strong) UIImageView* pictureImageView;

@end

@implementation JY_ChatBubblePictureView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.pictureImageView];
        
        [self.pictureImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bubbleImageView);
        }];
    }
    return self;
}

- (void)updateConstraints1
{
    CGSize size = self.model.cachePicSize;
    
    [self.bubbleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(size.width , size.height ));
    }];
    
    [self.pictureImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bubbleImageView);
    }];
    
}

- (void)setModel:(JYModel *)model{
    _model = model;
    
    NSString* pictureUrl = model.msg;
    self.layer.mask = self.bubbleImageView.layer;
    self.pictureImageView.image = [UIImage imageWithContentsOfFile:pictureUrl];
    
    self.msgSources = model.msgSources;

    [self updateConstraints1];
}

- (UIImageView *)pictureImageView
{
    if (!_pictureImageView) {
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.clipsToBounds = YES;
    }
    return _pictureImageView;
}


@end
