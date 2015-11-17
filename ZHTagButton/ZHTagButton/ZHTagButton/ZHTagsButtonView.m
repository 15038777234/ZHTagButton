//
//  ZHTagsButtonView.m
//  TagButtonDemo
//
//  Created by joser on 15/10/29.
//  Copyright © 2015年 ZhangHang. All rights reserved.
//

#import "ZHTagsButtonView.h"
#import "UIButton+ZHCategory.h"
@implementation ZHTagsButtonView {

    NSMutableArray *_selectIndexArray __deprecated_msg("已经被抛弃");
}

-(instancetype)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        
        [self _init];
        
        
    }
    return self;
}

-(void)_init{

    
    _tagButtonHeight=40.f;
    
    _tagButtonWidthSpance=10.f;
    
    _tagButtonHeightSpance=10.f;
    
    _tagButtonArray=[NSMutableArray array];
    
    self.showLayerBound=YES;
    
    self.showLayerBoard=YES;
    
    self.layerBoardWidth=1;
    self.layerBoardColor=[UIColor grayColor];
    
    self.layerBoundWidth=5;
    
    self.nomalBackgroundColor=[UIColor clearColor];
    
    self.selectBackgroundColor=[UIColor blackColor];
    
    self.titleColor=self.layerBoardColor;
    
    _isShowAddButton=NO;
    
    _lineViewArray=[NSMutableArray array];
    
    _style=ZHTagsButtonStyleDefault;
    
    self.isSupportMutableSelect=YES;
    
    _mutableSelectTagNamesArray=[NSMutableArray array];
    
    self.titleFont = [UIFont systemFontOfSize:16];
    
    self.tagButtonUserInteractionEnabled = YES;
    
}

- (void)setSelectTitleArray:(NSArray<NSString *> *)selectTitleArray {

    _selectTitleArray = selectTitleArray;
    [_mutableSelectTagNamesArray removeAllObjects];
    [_mutableSelectTagNamesArray addObjectsFromArray:selectTitleArray];
}

-(void)setDelegate:(id<ZHTagsButtonViewDelegate>)delegate{

    _delegate=delegate;
    
    [self reloadTagButtonsWithCreat:YES];
}


- (void)reloadTagButtonsWithCreat:(BOOL)isCreat
{
    
    
    if (isCreat) {//是否需要重新绘制
        
        //移除所有的按钮 和试图
        
        [self removeArrayAllView:_tagButtonArray];
        [self removeArrayAllView:_lineViewArray];
        
        if (!self.delegate) {//如果代理对象为空，则停止绘制
            return;
        }
        
        
        _tagNamesArray=[self.delegate tagButtonViewTextWithView:self];
        
        
        //获取设置的按钮的高度
        if ([self.delegate respondsToSelector:@selector(tagButtonHeightWithView:)])
        {
            _tagButtonHeight=[self.delegate tagButtonHeightWithView:self];
            
        }
        //获取设置的按钮之间的左右间距
        if ([self.delegate respondsToSelector:@selector(tagButtonWidthSpanceWithView:)]) {
            
            _tagButtonWidthSpance=[self.delegate tagButtonWidthSpanceWithView:self];
        }
        //获取设置的按钮之间的上下间距
        if ([self.delegate respondsToSelector:@selector(tagButtonHeightSpanceWithView:)]) {
            
            _tagButtonHeightSpance=[self.delegate tagButtonHeightSpanceWithView:self];
        }
        
        
        if ([self.delegate respondsToSelector:@selector(tagButtonStyleWithView:)]) {
            _style=[self.delegate tagButtonStyleWithView:self];
        }
        
        
        
        //记录上一个按钮对象 用于界面的排版
        ZHButton *upButton=nil;
        
        //计算生成按钮的个数
        NSUInteger buttonNumbers=_tagNamesArray.count;
        
        //获取是否要展现添加按钮
        if ([self.delegate respondsToSelector:@selector(tagButtonAddButtonShowWithView:)]) {
            
            _isShowAddButton=[self.delegate tagButtonAddButtonShowWithView:self];
            
            if (_isShowAddButton) {
                buttonNumbers=buttonNumbers+1;
            }
        }
        
        for (NSUInteger i=0;i<buttonNumbers; i++) {
            
            CGRect frame=CGRectMake(0, _tagButtonHeightSpance, 0, 0);
            NSString *titleString=nil;
            
            if (upButton) {
                frame=upButton.frame;
            }
            if (i<_tagNamesArray.count) {
                
                titleString=_tagNamesArray[i];
            }
            
            ZHButton *button=[self creatTagButtonWithString:titleString
                                              upButtonFrame:frame
                                                      index:i];
            
            
//            if ([_mutableSelectTagNamesArray containsObject:titleString]) {
//                button.isTagSelect = YES;
//                [self setTagButtonBackgroundColor:button];
//            }
            
            //如果不是第一个按钮就要创建线条 并且属于ZHTagsButtonStyleLine才绘制
            
            if (CGRectGetMinX(button.frame)>_tagButtonWidthSpance && _style==ZHTagsButtonStyleLine) {
                
                
                CGRect lineViewFrame=CGRectMake(CGRectGetMinX(button.frame)-_tagButtonWidthSpance/2,
                                        CGRectGetMinY(button.frame)+(_tagButtonHeight-_lineViewHeight)/2, 1, _lineViewHeight);
                
                
                UIView *lineView=[self creatLineViewWithFrame:lineViewFrame
                                              backgroundColor:button.titleLabel.textColor];
                
                
                [self addSubview:lineView];
                
                [_lineViewArray addObject:lineView];
                
                
            }
            
            upButton=button;
            
            [self addSubview:button];
            
            [_tagButtonArray addObject:button];
        }
        
        
        self.frame=CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame),
                              CGRectGetMaxY(upButton.frame)+5);
        
        
        
    }
    
    [self resetTagButtonStyle];
    
    
    if (_isShowAddButton) {
        if ([self.delegate respondsToSelector:@selector(tagButtonAddButtonWithView:button:)]) {
            [self.delegate tagButtonAddButtonWithView:self
                                               button:_tagButtonArray[_tagButtonArray.count-1]];
        }
    }



    
    
}
/**
 *  创建Tag按钮
 *
 *  @param string 要设置的字符串
 *  @param frame  上一个按钮的Frame 如果没有则设置(0,_tagButtonHeightSpance,0,0)
 *  @param index  按钮的索引
 *
 *  @return 返回创建按钮的对象
 */
-(ZHButton *)creatTagButtonWithString:(NSString *)string
                        upButtonFrame:(CGRect)frame
                                index:(NSUInteger)index{
    
    ZHButton *button=[ZHButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = self.titleFont;
    //获取字符串的宽度和高度
    CGSize size=ZHSizeFromString(string, button.titleLabel.font, YES, _tagButtonHeight);
    if (string) {
        
        _lineViewHeight=size.height;
    }
    
    
    button.tag=index;
    
    CGFloat buttonWidth=size.width+20;
    
    button.backgroundColor=self.nomalBackgroundColor;

    //如果是添加按钮 就设置固定的宽度
    if (index==_tagNamesArray.count) {
        
        buttonWidth=80;
        
        button.backgroundColor=[UIColor grayColor];
    }
    
    
    
    button.frame=CGRectMake(CGRectGetMaxX(frame)+_tagButtonWidthSpance, CGRectGetMinY(frame),
                            buttonWidth, _tagButtonHeight);
    
    if (CGRectGetMaxX(button.frame)>CGRectGetWidth(self.frame)-_tagButtonWidthSpance) {
        //判断是否超过屏幕的宽度
        button.frame=CGRectMake(0, CGRectGetMaxY(frame)+_tagButtonHeightSpance,
                                buttonWidth, _tagButtonHeight);
    }else if (CGRectGetMaxX(frame)<_tagButtonWidthSpance){
    
        button.frame=CGRectMake(0, 0,
                                buttonWidth, _tagButtonHeight);
    }
    
    [button setTitleColor:self.titleColor forState:UIControlStateNormal];
    
    
    [button setTitle:string forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(buttonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    
    button.isTagSelect = NO;
    
    for (NSString *tag in self.selectTitleArray) {
        if ([tag isEqualToString:string]) {
            
            button.isTagSelect = YES;
            [self setTagButtonBackgroundColor:button];
        }
    }
    
    return button;


}

/**
 *  创建分割线
 *
 *  @param frame 试图大小
 *  @param color 背景颜色
 *
 *  @return 线试图
 */
-(UIView *)creatLineViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color{

    UIView *view=[[UIView alloc]initWithFrame:frame];
    
    view.backgroundColor=color;
    
    return view;

}
/**
 *  重新设置标签按钮的风格
 */
- (void)resetTagButtonStyle{

    for (ZHButton *button in _tagButtonArray) {

        if (_style==ZHTagsButtonStyleDefault) {
            //设置默认的样式
            button.layer.masksToBounds=self.showLayerBound;
            button.layer.cornerRadius=self.showLayerBound?(self.layerBoundWidth):(0);
            if (self.showLayerBoard) {
                button.layer.borderWidth=self.layerBoardWidth;
                button.layer.borderColor=self.layerBoardColor.CGColor;
            }else{
                
                button.layer.borderWidth=0;
                button.layer.borderColor=[UIColor clearColor].CGColor;

            }

        }else if(_style==ZHTagsButtonStyleLine){
        
            button.backgroundColor=[UIColor clearColor];
            button.layer.masksToBounds=NO;
            button.layer.borderWidth=0;
            button.layer.borderColor=[UIColor clearColor].CGColor;
            
            
            
            
        
        }
        
        

    
    }

}

- (void)buttonClick:(id)sender{
    
    
    ZHButton *button = (ZHButton *)sender;
    if (!self.tagButtonUserInteractionEnabled) {
        return;
    }
    
    
    
    if (self.maxSelectCount>0 && _mutableSelectTagNamesArray.count==self.maxSelectCount &&!button.isTagSelect && self.isSupportMutableSelect)
    {
        ///如果设置了最大个数 并且选择的已经到了最大的个数 并且这个按钮之前没有选择
        [self.delegate tagButtonViewErrorWithView:ZHTagButtonErrorTypeOutMaxSelectCount];
        
        //NSLog(@"error");
        return;
    }
    
    if (button.tag==_tagNamesArray.count) {
        
        
        if (self.delegate && [self.delegate
                              respondsToSelector:@selector(tagButtonAddButtonDidSelectWithView:)])
        {
            [self.delegate tagButtonAddButtonDidSelectWithView:self];
        }
        
        return;
    }


    
    button.isTagSelect=!button.isTagSelect;
    
    [self setTagButtonBackgroundColor:button];
    
     NSString *tagName=button.titleLabel.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagButtonDidSelectWithTagName:tagView:)]) {
        [self.delegate tagButtonDidSelectWithTagName:tagName tagView:self];
    }
    
    
        if (self.isSupportMutableSelect) {
            
            if (button.isTagSelect) {
                [_mutableSelectTagNamesArray addObject:tagName];
                
            }else{
                
                for (NSUInteger i=0; i<_mutableSelectTagNamesArray.count; i++) {
                    NSString *tagNameCash=_mutableSelectTagNamesArray[i];
                    if ([tagNameCash isEqualToString:tagName]) {
                        [_mutableSelectTagNamesArray removeObjectAtIndex:i];
                        break;
                    }
                }
                
                
            
                
            }
            
            
            
            
        }else{
            
            [_mutableSelectTagNamesArray removeAllObjects];
            
            [_mutableSelectTagNamesArray addObject:tagName];
            
            for (ZHButton *bt in _tagButtonArray) {
                if (![bt isEqual:button]) {
                    
                    bt.isTagSelect=NO;
                    
                    [self setTagButtonBackgroundColor:bt];
                }
            }
            
        }
        
    
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagButonDidSelectWithTagNames:)]) {
        [self.delegate tagButonDidSelectWithTagNames:_mutableSelectTagNamesArray];
    }
    
}

- (void)setTagButtonBackgroundColor:(ZHButton *)button{

    
    if (button.isTagSelect) {
        
        if (_style==ZHTagsButtonStyleDefault) {
            button.backgroundColor=self.selectBackgroundColor;
            if (self.selectTitleColor) {
                [button setTitleColor:self.selectTitleColor forState:UIControlStateNormal];
            }

        }
        
    
    }else{
        
        button.backgroundColor=self.nomalBackgroundColor;
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
    }

}


/**
 *  移除数组所有的试图
 *
 *  @param array 界面数组对象
 */
- (void)removeArrayAllView:(NSMutableArray *)array{
    
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    
    [array removeAllObjects];

    
}


@end

FOUNDATION_EXPORT CGSize ZHSizeFromString(NSString *string,
                                          UIFont *font,
                                          BOOL isGetWidth,
                                          CGFloat maxWidthHeight){
    
    CGSize size=CGSizeMake(maxWidthHeight, MAXFLOAT);
    
    if (isGetWidth) {
        size=CGSizeMake(MAXFLOAT, maxWidthHeight);
    }
    
    CGRect rect=[string boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size;


}

@implementation ZHButton

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event{
    NSLog(@"beginTrackingWithTouch->>>>>>");
    return YES;
}

@end
