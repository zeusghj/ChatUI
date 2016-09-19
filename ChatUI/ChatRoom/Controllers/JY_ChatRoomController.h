//
//  JY_ChatRoomController.h
//  ChatUI
//
//  Created by 郭洪军 on 9/14/16.
//  Copyright © 2016 Guo Hongjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMTarget;

@interface JY_ChatRoomController : UIViewController

- (void)scrollViewToBottom;

- (instancetype)initWithTarget:(DMTarget *)target;

@end
