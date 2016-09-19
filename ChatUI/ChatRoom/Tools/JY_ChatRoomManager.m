//
//  JY_ChatRoomManager.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 9/5/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_ChatRoomManager.h"
#import "JYModel.h"

@implementation JY_ChatRoomManager

#pragma mark - public funs
+ (CGFloat)calculateCellHeightWithMsg:(JYModel *)msg
{
    CGSize size = CGSizeMake(0, 0);
    switch (msg.msg_Type) {
            //文字
        case JY_ChatMessageTypeText:
            size = [JY_ChatRoomManager msgTextHeight:msg.msg];
            break;
        case JY_ChatRoomTypePicture:
            size = [JY_ChatRoomManager msgPictureHeight:msg];
            break;
        case JY_ChatRoomTypeVoice:
        case JY_ChatRoomTypeVoiceRead:
            size = [JY_ChatRoomManager msgVoiceHeight:msg.msg];
            break;
            
        default:
            break;
    }
    return [JY_ChatRoomManager caculateCellHight:msg withSize:size];
}

#pragma mark - pravite funs
+ (CGFloat)caculateCellHight:(JYModel *)msg withSize:(CGSize)size
{
    // top and bottom margin
    CGFloat timetampHeight = 35.f;
    if (msg.showTimestamp) {
        timetampHeight += 23;
    }
    if (!msg.msgSources) {
        timetampHeight += 16;
    }
    if (msg.msg_Type == JY_ChatMessageTypeText) {
        timetampHeight += size.height>35.f?size.height:35.;
    }else if (msg.msg_Type == JY_ChatRoomTypePicture){
        timetampHeight += size.height -10;
    }else if (msg.msg_Type == JY_ChatRoomTypeVoice) {
        timetampHeight += size.height -5;
    }
    
    msg.cacheMsgSize = CGSizeMake(ceil(size.width), ceil(timetampHeight));
    
    return timetampHeight;
}

//纯文字
+ (CGSize)msgTextHeight:(NSString *)msg
{
    CGRect rect = [msg boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-165, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.]} context:nil];
    return rect.size;
}

//图片
+ (CGSize)msgPictureHeight:(JYModel *)msg
{
    CGSize resSize = CGSizeZero;
    CGFloat width = 0.f;
    
    UIImage* image = [UIImage imageWithContentsOfFile:msg.msg];
    CGSize size = image.size;
    
    if (size.width > size.height) {
        width = SCREEN_WIDTH * 155.f / 320.f;
    }else {
        width = SCREEN_WIDTH * 115.f / 320.f;
    }
    CGFloat height = width * size.height / size.width;
    resSize = CGSizeMake(ceil(width), ceil(height));
        
    msg.cachePicSize = resSize;
    
    return resSize;
}

//语音
+ (CGSize)msgVoiceHeight:(NSString *)msg
{
    return CGSizeMake(65, 35);
}

@end
