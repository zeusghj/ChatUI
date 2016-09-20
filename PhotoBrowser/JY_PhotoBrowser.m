//
//  JY_PhotoBrowser.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/10/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

//屏幕宽 高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define JY_KEYWINDOW [UIApplication sharedApplication].keyWindow

#define bigScrollViewTag   101

#import "JY_PhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDProgressView.h"
#import "JY_Photo.h"

@interface JY_PhotoBrowser ()<UIScrollViewDelegate>

/**
 *  底层滑动的scrollview
 */
@property (nonatomic, weak) UIScrollView* bigScrollView;

/**
 *  黑色背景view
 */
@property (nonatomic, weak) UIView* blackView;

/**
 *  原始frame数组
 */
@property (nonatomic, strong) NSMutableArray* originRects;

/**
 *  是否放大状态
 */
@property (nonatomic, assign) BOOL isExpand;

@end

@implementation JY_PhotoBrowser

-(NSMutableArray *)originRects{
    
    if (!_originRects) {
        _originRects = [NSMutableArray array];
    }
    return _originRects;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self) {
        //1,创建黑色背景view
        [self setupBlackView];
        
        //2,创建bigScrollView
        [self setupBigScrollView];
    }
    return self;
}

#pragma mark - 创建黑色背景
- (void)setupBlackView{
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    [self addSubview:blackView];
    self.blackView = blackView;
}

#pragma mark - 创建背景bigScrollView
- (void)setupBigScrollView{
    UIScrollView* bigScrollView = [[UIScrollView alloc] init];
    bigScrollView.backgroundColor = [UIColor clearColor];
    bigScrollView.delegate = self;
    bigScrollView.tag = bigScrollViewTag;
    bigScrollView.pagingEnabled = YES;
    bigScrollView.bounces = YES;
    bigScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = ScreenWidth;
    CGFloat scrollViewH = ScreenHeight;
    bigScrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    [self addSubview:bigScrollView];
    self.bigScrollView = bigScrollView;
}

#pragma mark - 展示浏览图片视图
- (void)show{
    //1,添加photoBrowser
    [JY_KEYWINDOW addSubview:self];
    
    //2,获取原始的frame
    [self setupOriginRects];
    
    //3,设置滚动距离
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth*self.photos.count, 0);
    self.bigScrollView.contentOffset = CGPointMake(ScreenWidth*self.currentIndex, 0);
    
    //4,创建子视图
    [self setupSmallScrollViews];
}

#pragma mark - 获取原始的frame
- (void)setupOriginRects{
    for (JY_Photo* photo in self.photos) {
        UIImageView *sourceImageView = photo.sourceImageView;
        CGRect sourceF = [JY_KEYWINDOW convertRect:sourceImageView.frame fromView:sourceImageView.superview];
                
        [self.originRects addObject:[NSValue valueWithCGRect:sourceF]];
    }
}

#pragma mark - 创建子视图
- (void)setupSmallScrollViews{
    for (int i=0; i<self.photos.count; ++i) {
        UIScrollView* smallScrollView = [[UIScrollView alloc] init];
        smallScrollView.backgroundColor = [UIColor clearColor];
        smallScrollView.tag = i;
        smallScrollView.frame = CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight);
        smallScrollView.delegate = self;
        smallScrollView.maximumZoomScale = 3.0;
        smallScrollView.minimumZoomScale = 1;
        [self.bigScrollView addSubview:smallScrollView];
        
        JY_Photo* photo = self.photos[i];
        UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
        UITapGestureRecognizer *zoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomTap:)];
        zoomTap.numberOfTapsRequired = 2;
        [photo addGestureRecognizer:photoTap];
        [photo addGestureRecognizer:zoomTap];
        [photoTap requireGestureRecognizerToFail:zoomTap];
        [smallScrollView addSubview:photo];
        
        SDRotationLoopProgressView* loop = [SDRotationLoopProgressView progressView];
        loop.tag = i;
        loop.frame = CGRectMake(0, 0, 80, 80);
        loop.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
        loop.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        loop.hidden = YES;
        [smallScrollView addSubview:loop];
        
        NSString* urlStr = photo.bigImageUrl;
        
        if ([urlStr hasPrefix:@"http"]) {
            NSURL* bigImgUrl = [NSURL URLWithString:photo.bigImageUrl];
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:photo.bigImageUrl done:^(UIImage *image, SDImageCacheType cacheType) {
                if (image == nil) {
                    loop.hidden = NO;
                }
            }];
            
            [photo sd_setImageWithURL:bigImgUrl placeholderImage:[UIImage imageNamed:@"home_cell_avatar"] options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                //操作loop
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [loop removeFromSuperview];
                
                if (image != nil) {
                    photo.frame = [self.originRects[i] CGRectValue];
                    
                    if (cacheType == SDImageCacheTypeNone) {
                        photo.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/2);
                        photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                    }
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        self.blackView.alpha = 1.0;
                        
                        CGFloat ratio = (double)photo.image.size.height/(double)photo.image.size.width;
                        
                        CGFloat bigW = ScreenWidth;
                        CGFloat bigH = ScreenWidth*ratio;
                        
                        photo.bounds = CGRectMake(0, 0, bigW, bigH);
                        photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                    }];
                }else{
                    
                    UITapGestureRecognizer *loopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopTap)];
                    [loop addGestureRecognizer:loopTap];
                    
                }
            }];
        }else {
            photo.image = [UIImage imageWithContentsOfFile:urlStr];
            
            photo.frame = [self.originRects[i] CGRectValue];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.blackView.alpha = 1.0;
                
                CGFloat ratio = (double)photo.image.size.height/(double)photo.image.size.width;
                
                CGFloat bigW = ScreenWidth;
                CGFloat bigH = ScreenWidth*ratio;
                
                photo.bounds = CGRectMake(0, 0, bigW, bigH);
                photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
            }];
        }
        
    }
}

#pragma mark - gesture methods
- (void)photoTap:(UITapGestureRecognizer *)photoTap{
    JY_Photo *photo = (JY_Photo *)photoTap.view;
    UIScrollView *smallScrollView = (UIScrollView *)photo.superview;
    
    if (!_isExpand) {
        smallScrollView.zoomScale = 1.0;
        
        CGRect frame = [self.originRects[photo.tag] CGRectValue];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            photo.frame = frame;
            self.blackView.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            smallScrollView.zoomScale = 1.0;
            
            _isExpand = !_isExpand;
        }];
        
    }
}

- (void)zoomTap:(UITapGestureRecognizer *)zonmTap{
    [UIView animateWithDuration:0.3 animations:^{
        
        UIScrollView *smallScrollView = (UIScrollView *)zonmTap.view.superview;
        
        if (!_isExpand) {
            smallScrollView.zoomScale = 3.0;
        }else
        {
            smallScrollView.zoomScale = 1.0;
        }
        
        _isExpand = !_isExpand;
        
    }];
}

-(void)loopTap{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.blackView.alpha = 0;
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark - UIScrollViewDelegate

//告诉scrollView要缩放的是哪个子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (scrollView.tag == bigScrollViewTag) {
        return nil;
    }
    JY_Photo* photo = self.photos[scrollView.tag];
    
    return photo;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if (scrollView.tag==bigScrollViewTag) {
        return;
    }
    
    JY_Photo *photo = (JY_Photo *)self.photos[scrollView.tag];
    
    CGFloat photoY = (ScreenHeight-photo.frame.size.height)/2;
    CGRect photoF = photo.frame;
    
    if (photoY>0) {
        
        photoF.origin.y = photoY;
        
    }else{
        
        photoF.origin.y = 0;
        
    }
    
    photo.frame = photoF;
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int currentIndex = scrollView.contentOffset.x/ScreenWidth;
    
    if (self.currentIndex!=currentIndex && scrollView.tag==bigScrollViewTag) {
        
        self.currentIndex = currentIndex;
        
        for (UIView *view in scrollView.subviews) {
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                
                UIScrollView *scrollView = (UIScrollView *)view;
                scrollView.zoomScale = 1.0;
            }
            
        }
    }
}

#pragma mark 设置frame

-(void)setFrame:(CGRect)frame{
    
    frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [super setFrame:frame];
    
}

@end

