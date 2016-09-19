//
//  JY_ChatBubbleVoiceView.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/12/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatBubbleVoiceView.h"
#import <AVFoundation/AVFoundation.h>
#import "DataManager.h"

@interface JY_ChatBubbleVoiceView ()<AVAudioPlayerDelegate>

@property (nonatomic, weak) UILabel* secondsLabel;
@property (nonatomic, weak) UIImageView* voiceImageView;
@property (nonatomic, weak) UIButton* playButton;
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, copy) NSString* voiceUrl;

//image maker
@property (nonatomic, strong)MASConstraint* imageMaker;

@end

@implementation JY_ChatBubbleVoiceView

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;    
}

- (void)updateConstraints1 {
    
    [self.bubbleImageView updateConstraints:^(MASConstraintMaker *make) {
        if (self.msgSources) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 29, 0, 0));
        } else {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 29));
        }
    }];
    
    [self.secondsLabel updateConstraints:^(MASConstraintMaker *make) {
        if (self.msgSources) {
            make.edges.equalTo(UIEdgeInsetsMake(10, 0, 10, 10));
        } else {
            make.edges.equalTo(UIEdgeInsetsMake(10, 10, 10, 0));
        }
    }];
    
    [self.voiceImageView updateConstraints:^(MASConstraintMaker *make) {
        if (self.msgSources) {
            make.centerY.equalTo(0);
            
            [self.imageMaker uninstall];
            self.imageMaker = make.right.equalTo(-15);
        }else {
            make.centerY.equalTo(0);
            
            [self.imageMaker uninstall];
            self.imageMaker = make.left.equalTo(15);
        }
    }];
    
    [self.playButton updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bubbleImageView);
    }];
    
}

- (UILabel *)secondsLabel {
    if (!_secondsLabel) {
        UILabel *seLabel = [[UILabel alloc] init];
        seLabel.textColor = [UIColor darkGrayColor];
        seLabel.font = [UIFont systemFontOfSize:15.];
        [self addSubview:self.secondsLabel = seLabel];
    }
    
    return _secondsLabel;
}

- (UIImageView *)voiceImageView {
    if (!_voiceImageView) {
        
        UIImageView *voiceImageView = [[UIImageView alloc] init];
        voiceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.voiceImageView = voiceImageView];
        
        [self updateAnimationArrayWithMsgSource:self.msgSources];
    }
    
    return _voiceImageView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        
        UIButton* button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:(self.playButton = button)];
    }
    
    return _playButton;
}

- (void)updateAnimationArrayWithMsgSource:(BOOL)msgsource {
    NSArray *playArray ;
    if (msgsource) {
        playArray = @[[UIImage imageNamed:@"tra_voiceself"],
                      [UIImage imageNamed:@"tra_voiceself1"],
                      [UIImage imageNamed:@"tra_voiceself2"]];
    }else {
        playArray = @[[UIImage imageNamed:@"tra_voiceother"],
                      [UIImage imageNamed:@"tra_voiceother1"],
                      [UIImage imageNamed:@"tra_voiceother2"]];
    }
    
    _voiceImageView.image = playArray.firstObject;
    _voiceImageView.animationImages = playArray;
    _voiceImageView.animationDuration = 1;
    _voiceImageView.animationRepeatCount = 0;
}

- (void)playVoice:(id)sender {
    
    if (self.audioPlayer && ![self.audioPlayer isPlaying] && ![DataManager getInstance].isVoicePlaying) {
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        [self.voiceImageView startAnimating];
        
        //保存播放状态
        [DataManager getInstance].isVoicePlaying = YES;
    }
}

- (void)setModel:(JYModel *)model {
    _model = model;
    
    NSString* voiceUrl = _model.msg;
    NSArray* arr1 = [voiceUrl componentsSeparatedByString:@"+"];
    self.secondsLabel.text = arr1[0];
    self.voiceUrl = [NSHomeDirectory() stringByAppendingPathComponent:arr1[1]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.voiceUrl] error:nil];
    
    BOOL msgSources = model.msgSources;
    self.msgSources = msgSources;
    if (msgSources) {
        self.secondsLabel.textAlignment = NSTextAlignmentLeft;
    }else {
        self.secondsLabel.textAlignment = NSTextAlignmentRight;
    }
    
    [self updateAnimationArrayWithMsgSource:self.msgSources];

    [self updateConstraints1];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.voiceImageView stopAnimating];
    
    [DataManager getInstance].isVoicePlaying = NO;
}

@end
