//
//  JY_Photo.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/10/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//  放大展示的图片imageview

#import <UIKit/UIKit.h>

@interface JY_Photo : UIImageView

/**
 *  原始的iamgeView
 */
@property (nonatomic, strong) UIImageView* sourceImageView;

/**
 *  大图的URL地址
 */
@property (nonatomic, copy) NSString* bigImageUrl;


@end
