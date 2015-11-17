//
//  ZHtagButtonViewHeightManger.m
//  TagButtonDemo
//
//  Created by 张行 on 15/11/5.
//  Copyright © 2015年 ZhangHang. All rights reserved.
//

#import "ZHtagButtonViewHeightManger.h"
@implementation ZHtagButtonViewHeightManger {


    CGRect _oldFrame;
    
    NSArray *_tagnamesArray;
}


- (CGFloat )tagButtonHeightWithButtonOldFrame:(CGRect)frame {

    _oldFrame = frame;
    
    
    ZHTagsButtonView *tagButton = [[ZHTagsButtonView alloc]initWithFrame:frame];
    
    tagButton.delegate=self.delegate;
    
    [tagButton reloadTagButtonsWithCreat:YES];
    
    return CGRectGetMaxY(tagButton.frame)+20;
}



@end
