//
//  UIButton+ZHCategory.m
//  TagButtonDemo
//
//  Created by joser on 15/10/29.
//  Copyright © 2015年 ZhangHang. All rights reserved.
//

#import "UIButton+ZHCategory.h"
#import <objc/runtime.h>
@implementation UIButton (ZHCategory)

-(void)setIsTagSelect:(BOOL)isTagSelect{

    objc_setAssociatedObject(self, @selector(isTagSelect), [NSNumber numberWithBool:isTagSelect], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isTagSelect{

    return [objc_getAssociatedObject(self, @selector(isTagSelect)) boolValue];
}


@end
