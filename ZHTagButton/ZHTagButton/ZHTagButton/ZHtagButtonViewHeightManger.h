//
//  ZHtagButtonViewHeightManger.h
//  TagButtonDemo
//
//  Created by 张行 on 15/11/5.
//  Copyright © 2015年 ZhangHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHTagsButtonView.h"


@interface ZHtagButtonViewHeightManger : NSObject


@property (nonatomic, weak) id<ZHTagsButtonViewDelegate> delegate;

- (CGFloat )tagButtonHeightWithButtonOldFrame:(CGRect)frame;

@end

