//
//  JY_PhotoBrowserTool.h
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/10/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JY_Photo.h"

@interface JY_PhotoBrowserTool : NSObject

+ (void)showPhotoWithPhotos:(NSArray<JY_Photo *> *)photos currentIndex:(NSUInteger)index;

@end
