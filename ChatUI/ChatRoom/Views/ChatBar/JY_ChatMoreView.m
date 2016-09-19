//
//  JY_ChatMoreView.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/30/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatMoreView.h"

@interface JY_ChatMoreView ()<UIScrollViewDelegate>

@property (copy, nonatomic) NSArray* titles;
@property (copy, nonatomic) NSArray* images;

@property (assign, nonatomic) CGSize itemSize;
@property (strong, nonatomic) UIColor* messageInputViewMorePanelBackgroundColor;

@end

@implementation JY_ChatMoreView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kMoreViewHeight)]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

#pragma mark - Public Methods

- (void)setup {
    UIImageView *topLine = [[UIImageView alloc] init];
    topLine.backgroundColor = RGBCOLOR(184, 184, 184, 1);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.mas_equalTo(.5f);
    }];

    self.backgroundColor = self.messageInputViewMorePanelBackgroundColor;
    [self setupItems];
}

- (void)setupItems {
    
    //相册
    UIButton* album = [[UIButton alloc] init];
    [album setBackgroundImage:[UIImage imageNamed:@"ABPMButtonAlbum"] forState:UIControlStateNormal];
    [album addTarget:self action:@selector(albumAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:album];
    
    [album mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(25);
        make.top.equalTo(18);
    }];
    
    UILabel* albumLb = [[UILabel alloc] init];
    albumLb.text = @"相册";
    albumLb.font = [UIFont systemFontOfSize:12];
    albumLb.textColor = [UIColor lightGrayColor];
    [self addSubview:albumLb];
    
    [albumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(album.mas_bottom).offset(7);
        make.centerX.equalTo(album);
    }];
    
    //拍照
    UIButton* capture = [[UIButton alloc] init];
    [capture setBackgroundImage:[UIImage imageNamed:@"ABPMButtonCapture"] forState:UIControlStateNormal];
    [capture addTarget:self action:@selector(captureAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:capture];
    
    [capture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(album.mas_right).offset(25);
        make.top.equalTo(18);
    }];
    
    UILabel* captureLb = [[UILabel alloc] init];
    captureLb.text = @"拍照";
    captureLb.font = [UIFont systemFontOfSize:12];
    captureLb.textColor = [UIColor lightGrayColor];
    [self addSubview:captureLb];
    
    [captureLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(capture.mas_bottom).offset(7);
        make.centerX.equalTo(capture);
    }];
}

#pragma mark - private methods.

- (void) albumAction {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        return;
    }
    
    if (self.delegate) {
        [self.delegate chatMoreView:self clickIndex:1];
    }
}

- (void) captureAction {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    if (self.delegate) {
        [self.delegate chatMoreView:self clickIndex:2];
    }
}

#pragma mark - Getters

- (UIColor *)messageInputViewMorePanelBackgroundColor {
    if (_messageInputViewMorePanelBackgroundColor) {
        return _messageInputViewMorePanelBackgroundColor;
    }
    _messageInputViewMorePanelBackgroundColor = RGBCOLOR(235, 236, 238, 1);
    return _messageInputViewMorePanelBackgroundColor;
}

@end

