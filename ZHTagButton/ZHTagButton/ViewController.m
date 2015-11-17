//
//  ViewController.m
//  ZHTagButton
//
//  Created by 张行 on 15/11/17.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHTagsButtonView.h"
@interface ViewController () <ZHTagsButtonViewDelegate>
@property (weak, nonatomic) IBOutlet ZHTagsButtonView *tabButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabButton _init];
    self.tabButton.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)tagButtonViewTextWithView:(ZHTagsButtonView *)view {
    return @[@"IOS满级",@"代码狂",@"热爱学技术",@"IOS满级",@"代码狂",@"热爱学技术",@"IOS满级",@"代码狂",@"热爱学技术",@"IOS满级",@"代码狂",@"热爱学技术"];
}

- (void)tagButtonViewErrorWithView:(ZHTagButtonErrorType)errorType {

}


@end
