//
//  JY_ChatFaceView.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/30/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatFaceView.h"

@implementation EmojiCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel* emojiLabel = [[UILabel alloc] init];
        emojiLabel.userInteractionEnabled = YES;
        emojiLabel.font = [UIFont systemFontOfSize:30];
        [self.contentView addSubview:self.emojiLabel = emojiLabel];
        [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    
    return self;
}

@end

@interface JY_ChatFaceView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray* emojiArray;
@property (nonatomic, weak)   UICollectionView* collectionView;
@property (nonatomic, weak)   UIPageControl* pageControl;

@property (strong, nonatomic) UIView *bottomView;
@property (weak, nonatomic) UIButton *sendButton;

@property (weak, nonatomic) UIButton *recentButton /**< 显示最近表情的button */;
@property (weak, nonatomic) UIButton *emojiButton /**< 显示emoji表情Button */;

@end

@implementation JY_ChatFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2 + 40)]) {
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
        self.emojiArray = [NSArray arrayWithContentsOfFile:path];
        
        [self setup];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)setup{
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(40);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(_bottomView.mas_top).offset(-10);
        make.height.equalTo(10);
    }];
    
    UIImageView *topLine = [[UIImageView alloc] init];
    topLine.backgroundColor = RGBCOLOR(184, 184, 184, 1);
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
}

#pragma mark - Getter Methods

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH - 20)/6, (SCREEN_WIDTH/2 - 30)/3);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 20, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [collectionView registerClass:[EmojiCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:(_collectionView = collectionView)];
    }
    
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl* pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        pageControl.numberOfPages = self.emojiArray.count;
        pageControl.enabled = NO;
        [self addSubview:(_pageControl = pageControl)];
    }
    
    return _pageControl;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        UIImageView *topLine = [[UIImageView alloc] init];
        topLine.backgroundColor = RGBCOLOR(184, 184, 184, 1);
        [_bottomView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(0);
            make.height.equalTo(.5f);
            make.width.equalTo(_bottomView).offset(-70);
        }];
        
        UIButton *sendButton = [[UIButton alloc] init];
        sendButton.backgroundColor = RGBCOLOR(41, 172, 250, 1);
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.sendButton = sendButton];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(0);
            make.left.equalTo(_bottomView.mas_right).offset(-70);
        }];
        
        UIButton *recentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_normal"] forState:UIControlStateNormal];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_highlight"] forState:UIControlStateHighlighted];
        [recentButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_recent_highlight"] forState:UIControlStateSelected];
        recentButton.tag = 111;
        [recentButton addTarget:self action:@selector(changeFaceType:) forControlEvents:UIControlEventTouchUpInside];
        [recentButton sizeToFit];
        [_bottomView addSubview:self.recentButton = recentButton];
        [recentButton setFrame:CGRectMake(0, _bottomView.frame.size.height/2-recentButton.frame.size.height/2, recentButton.frame.size.width, recentButton.frame.size.height)];
        [recentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(80);
            make.centerY.equalTo(0);
        }];
        UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_normal"] forState:UIControlStateNormal];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_highlight"] forState:UIControlStateHighlighted];
        [emojiButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_emoji_highlight"] forState:UIControlStateSelected];
        emojiButton.tag = 112;
        [emojiButton addTarget:self action:@selector(changeFaceType:) forControlEvents:UIControlEventTouchUpInside];
        [emojiButton sizeToFit];
        emojiButton.selected = YES;
        [_bottomView addSubview:self.emojiButton = emojiButton];
        [emojiButton setFrame:CGRectMake(recentButton.frame.size.width, _bottomView.frame.size.height/2-emojiButton.frame.size.height/2, emojiButton.frame.size.width, emojiButton.frame.size.height)];
        [emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.centerY.equalTo(0);
        }];
        
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.emojiArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.emojiArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.emojiLabel.text = self.emojiArray[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.emojiArray[indexPath.section][indexPath.row];
    if ([text isEqualToString:@"🔙"]) {
        [self.inputDelegate deleteBackward];
    } else {
        [self.inputDelegate insertText:text];
    }
}

- (void)sendAction:(UIButton *)button {
    
    if (self.faceViewSendBlock) {
        self.faceViewSendBlock();
    }
}

- (void)changeFaceType:(UIButton *)button {
    
}

@end
