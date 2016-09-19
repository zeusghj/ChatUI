//
//  JY_ChatMoreView.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/30/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JY_ChatMoreView;

static CGFloat const kMoreViewHeight = 124.f;



@protocol JY_ChatMoreViewDelegate <NSObject>

@optional

- (void)chatMoreView:(JY_ChatMoreView *)moreView clickIndex:(NSUInteger)index;  //1, 相册；2，拍照

@end

@interface JY_ChatMoreView : UIView

@property (nonatomic, weak) id <JY_ChatMoreViewDelegate>delegate;

@end
