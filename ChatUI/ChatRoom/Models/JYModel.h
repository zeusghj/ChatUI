//
//  JYModel.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JY_Constants.h"


@interface JYModel : NSObject

//头像
@property (nonatomic, copy)NSString* userIcon;
//消息来源 yes 自己 NO 其他人
@property (nonatomic, assign) BOOL msgSources;
//用户名
@property (nonatomic, copy) NSString* userName;
//消息内容
@property (nonatomic, copy) NSString* msg;
//消息类型
@property (nonatomic, assign) JY_ChatMessageType msg_Type;
//时间戳
@property (nonatomic, copy) NSString* timestamp;
//是否需要显示时间戳
@property (nonatomic, assign) BOOL showTimestamp;
//聊天消息和用户Id绑定
@property (nonatomic, copy) NSString* chatMsgId;
//缓存消息尺寸size
@property (nonatomic, assign) CGSize cacheMsgSize;
//缓存图片尺寸
@property (nonatomic, assign) CGSize cachePicSize;

@end
