//
//  JY_PhotoBrowserTool.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/10/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_PhotoBrowserTool.h"
#import "JY_PhotoBrowser.h"

@implementation JY_PhotoBrowserTool

+ (void)showPhotoWithPhotos:(NSArray<JY_Photo *> *)photos currentIndex:(NSUInteger)index{
    JY_PhotoBrowser *photoBrowser = [[JY_PhotoBrowser alloc] init];
    photoBrowser.photos = photos;
    photoBrowser.currentIndex = index;
    [photoBrowser show];
}

@end
