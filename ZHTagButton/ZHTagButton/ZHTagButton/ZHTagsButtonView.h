//
//  ZHTagsButtonView.h
//  TagButtonDemo
//
//  Created by joser on 15/10/29.
//  Copyright © 2015年 ZhangHang. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define ISDEBUG

typedef NS_ENUM(NSUInteger,ZHTagsButtonStyle){

    
    ZHTagsButtonStyleDefault,//带边框
    ZHTagsButtonStyleLine//没有带边框加分割线的

};
///返回的错误的类型
typedef NS_ENUM(NSUInteger, ZHTagButtonErrorType) {

    ///选择已经超过了最大值
    ZHTagButtonErrorTypeOutMaxSelectCount

};


@protocol ZHTagsButtonViewDelegate;


@interface ZHTagsButtonView : UIView{
    
    

    
@private
    
    NSArray *_tagNamesArray;
    
    CGFloat _tagButtonHeight;
    
    CGFloat _tagButtonWidthSpance;
    
    CGFloat _tagButtonHeightSpance;
    
    NSMutableArray *_tagButtonArray;
    
    BOOL _isShowAddButton;
    
    NSMutableArray *_lineViewArray;
    
    ZHTagsButtonStyle _style;
    
    CGFloat _lineViewHeight;
    
    NSMutableArray *_mutableSelectTagNamesArray;


}
/**
 *  初始化 高度会随着设置的Tag自动的增加
 *
 *  @param frame 起初的Frame大小
 *
 *  @return 对象
 */
-(instancetype)initWithFrame:(CGRect)frame;
/**
 *  用于xib初始化变量
 */
-(void)_init;
/**
 *  代理对象
 */
@property (nonatomic, weak) id<ZHTagsButtonViewDelegate> delegate;
///显示圆角 默认为yes
@property (nonatomic, assign) BOOL showLayerBound;
///显示描边 默认为yes
@property (nonatomic, assign) BOOL showLayerBoard;
///圆角的大小 默认为5
@property (nonatomic, assign) CGFloat layerBoundWidth;
///边宽度 默认为1
@property (nonatomic, assign) CGFloat layerBoardWidth;
///边颜色 默认为灰色
@property (nonatomic, assign) UIColor *layerBoardColor;
/**
 *  选中的颜色 默认为黑色
 */
@property (nonatomic, strong) UIColor *selectBackgroundColor;
/**
 *  默认的背景颜色 默认为透明
 */
@property (nonatomic, strong) UIColor *nomalBackgroundColor;

/**
 *  标题的颜色 默认和边框一样的颜色
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  设置是否支持多选 默认为yes
 */
@property (nonatomic, assign) BOOL isSupportMutableSelect;

///设置最大支持的选择个数 默认为0 没有限制
@property (nonatomic, assign) NSUInteger maxSelectCount;
///已经选中的字符串 默认为nil 如果赋值
@property (nonatomic, strong) NSArray <NSString *> *selectTitleArray;

///选中标题的颜色 默认为  nil
@property (nonatomic, strong) UIColor *selectTitleColor;
///字体大小 默认为16
@property (nonatomic, strong) UIFont *titleFont;
//按钮是否可以点击 默认为yes
@property (nonatomic, assign) BOOL tagButtonUserInteractionEnabled;


/**
 *  刷新控件
 *
 *  @param isCreat 如果只是改变按钮的样式 传NO
 */
- (void)reloadTagButtonsWithCreat:(BOOL)isCreat;

@end


@protocol ZHTagsButtonViewDelegate < NSObject>

@required
/**
 *  tag标签需要的字符串的数组
 *
 *  @param view 设置的对象
 *
 *  @return 字符串数组
 */
- (NSArray *)tagButtonViewTextWithView:(ZHTagsButtonView *)view;

/**
 *  @author ZhangHang, 15-11-04 14:11:31
 *
 *  返回的错误信息
 *
 *  @param errorType 错误的类型
 */
- (void)tagButtonViewErrorWithView:(ZHTagButtonErrorType)errorType;

@optional
/**
 *  设置标签的按钮的高度
 *
 *  @param view 设置的对象
 *
 *  @return 按钮的高度 默认为40.f
 */
- (CGFloat)tagButtonHeightWithView:(ZHTagsButtonView *)view;
/**
 *  设置标签的左右间距
 *
 *  @param view 设置的对象
 *
 *  @return 左右间距 默认为10.f
 */
- (CGFloat)tagButtonWidthSpanceWithView:(ZHTagsButtonView *)view;
/**
 *  设置标签的上下间距
 *
 *  @param view 设置的对象
 *
 *  @return 上下间距 默认为10.f
 */
- (CGFloat)tagButtonHeightSpanceWithView:(ZHTagsButtonView *)view;

/**
 *  设置是否添加增加按钮 默认不显示
 *
 *  @param view 设置的对象
 *
 *  @return 如果显示设置为YES 如果不不显示设置为NO
 */
- (BOOL)tagButtonAddButtonShowWithView:(ZHTagsButtonView *)view;
/**
 *  增加按钮点击的回调
 *
 *  @param view 设置的对象
 */
- (void)tagButtonAddButtonDidSelectWithView:(ZHTagsButtonView *)view;
/**
 *  自定义增加按钮的样式
 *
 *  @param view   设置的对象
 *  @param button 增加的按钮
 */
- (void)tagButtonAddButtonWithView:(ZHTagsButtonView *)view button:(UIButton *)button;

/**
 *  设置标签按钮的样式 默认为 ZHTagsButtonStyleDefault
 *
 *  @param view 设置的对象
 *
 *  @return 需要设置的样式
 */
- (ZHTagsButtonStyle)tagButtonStyleWithView:(ZHTagsButtonView *)view;

/**
 *  返回已经选择的标签 单选的数组一直为一个 多选会调用很多次
 *
 *  @param tagNames 已经选择的标签的数组
 */
- (void)tagButonDidSelectWithTagNames:(NSArray *)tagNames;

/**
 *  @author ZhangHang, 15-11-06 09:11:14
 *
 *  点击按钮回调函数
 *
 *  @param tagName 按钮的标题
 *  @param view    标签控件
 */
- (void)tagButtonDidSelectWithTagName:(NSString *)tagName tagView:(ZHTagsButtonView *)view;




@end
/**
 *  求字符串的宽度和高度
 *
 *  @param string     字符串
 *  @param font       设置的字符串的大小
 *  @param isGetWidth 是求高度还是高度
 *  @param maxWidthHeight 最大限制的宽度和高度
 *  @return 返回宽度和高度
 */

//FIXME:如果需要支持IOS7以下,请修改下面的方法

FOUNDATION_EXPORT CGSize ZHSizeFromString(NSString *string,
                                          UIFont *font,
                                          BOOL isGetWidth,
                                          CGFloat maxWidthHeight) NS_AVAILABLE_IOS(7_0);

@interface ZHButton :UIButton



@end


