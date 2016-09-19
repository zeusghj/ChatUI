//
//  JY_ChatRoomManager.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYModel;

@interface JY_ChatRoomManager : NSObject

+ (CGFloat)calculateCellHeightWithMsg:(JYModel *)msg;

@end
