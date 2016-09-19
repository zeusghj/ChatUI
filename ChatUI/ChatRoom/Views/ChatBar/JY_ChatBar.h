//
//  JY_ChatBar.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/30/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

@import UIKit;

static CGFloat const kChatBarBottomOffset = 8.f;
static CGFloat const kChatBarTextViewBottomOffset = 6;
static CGFloat const kJYChatBarTextViewFrameMinHeight = 37.f; //kJYChatBarMinHeight - 2*kChatBarTextViewBottomOffset;
static CGFloat const kJYChatBarTextViewFrameMaxHeight = 102.f; //kJYChatBarMaxHeight - 2*kChatBarTextViewBottomOffset;
static CGFloat const kJYChatBarMaxHeight = kJYChatBarTextViewFrameMaxHeight + 2*kChatBarTextViewBottomOffset; //114.0f;
static CGFloat const kJYChatBarMinHeight = kJYChatBarTextViewFrameMinHeight + 2*kChatBarTextViewBottomOffset; //49.0f;


typedef void (^resultBlock)(BOOL success);

#import <UIKit/UIKit.h>

@protocol JY_ChatBarDelegate;

/**
 *  信息输入框，支持语音，文字，表情，选择照片，拍照
 */
@interface JY_ChatBar : UIView

@property (weak, nonatomic) id<JY_ChatBarDelegate> delegate;
@property (nonatomic, weak) UIViewController* controllerRef;

/*!
 *
 缓存输入框文字，兼具内存缓存和本地数据库缓存的作用。同时也负责着输入框内容被清空时的监听，收缩键盘。内部重写了setter方法，self.cachedText 就相当于self.textView.text，使用最重要的场景：为了显示voiceButton，self.textView.text = nil;
 
 */
@property (copy, nonatomic) NSString* cachedText;

/**
 *  键盘取消第一响应
 */
- (void) dismiss;

@end

/**
 *  JY_ChatBar代理事件，发送图片，文字，语音信息等
 */
@protocol JY_ChatBarDelegate <NSObject>

@optional

/*!
 *  chatBarFrame改变回调
 *
 *  @param chatBar
 */
- (void)chatBarFrameDidChange:(JY_ChatBar *)chatBar shouldScrollToBottom:(BOOL)shouldScrollToBottom;

/*!
 *  发送图片信息，支持多张图片
 *
 *  @param chatBar
 *  @param pictures 需要发送的图片信息
 */
- (void)chatBar:(JY_ChatBar *)chatBar sendPictures:(NSArray *)pictures;

/*!
 *  发送普通的文字信息,可能带有表情
 *
 *  @param chatBar
 *  @param message 需要发送的文字信息
 */
- (void)chatBar:(JY_ChatBar *)chatBar sendMessage:(NSString *)message;

/*!
 *  发送语音信息
 *
 *  @param chatBar
 *  @param voiceData 语音data数据
 *  @param seconds   语音时长
 */
- (void)chatBar:(JY_ChatBar *)chatBar sendVoice:(NSString *)voiceFileName seconds:(NSString *)seconds;

@end
