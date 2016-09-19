//
//  DataManager.h
//  ChatUI
//
//  Created by 郭洪军 on 9/19/16.
//  Copyright © 2016 Guo Hongjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMTarget : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lastMessage;
@property (nonatomic, assign) NSInteger unread;
@property (nonatomic, assign) NSInteger time;

@end

@interface DataManager : NSObject

+ (instancetype)getInstance;

@property (nonatomic, assign)BOOL isVoicePlaying;

@end
