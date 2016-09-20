//
//  JY_PhotoBrowser.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/10/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//  展示图片放大的浏览

#import <UIKit/UIKit.h>

@interface JY_PhotoBrowser : UIView

/**
 *  存放图片的数组
 */
@property (nonatomic, strong) NSArray* photos;

/**
 *  当前图片的index
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  显示图片浏览器
 */
- (void)show;

@end
