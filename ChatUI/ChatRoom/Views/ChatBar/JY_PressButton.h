//
//  PressButton.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JY_PressButton : UIButton

@property (nonatomic, copy) void(^sendVoice)(NSString *);

@end
