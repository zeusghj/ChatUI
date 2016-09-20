//
//  JY_Photo.m
//  EveyoneLoveSocial
//
//  Created by 郭洪军 on 8/10/16.
//  Copyright © 2016 宋晓建. All rights reserved.
//

#import "JY_Photo.h"

@implementation JY_Photo

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

@end
