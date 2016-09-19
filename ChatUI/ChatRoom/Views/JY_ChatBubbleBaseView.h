//
//  JY_ChatBubbleBaseView.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JY_Constants.h"

@interface JY_ChatBubbleBaseView : UIView

//background bubble imageView
@property (nonatomic,strong)UIImageView *bubbleImageView;

//message from self or others
@property (nonatomic,assign)BOOL msgSources;

@end
