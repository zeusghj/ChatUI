//
//  JY_ChatFaceView.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/30/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - CLASS:EmojiCell
@interface EmojiCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *emojiLabel;

@end

@interface JY_ChatFaceView : UIView

@property (nonatomic, assign) id<UITextInput> inputDelegate;

@property (nonatomic, copy) void(^faceViewSendBlock)(void);

@end
