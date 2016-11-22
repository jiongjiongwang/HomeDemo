//
//  DetailView.h
//  HomeDemo
//
//  Created by dn210 on 16/11/22.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailView : UIView


- (instancetype)initWithFrame:(CGRect)frame dataStr:(NSString *)strData index:(NSInteger)index andCellColor:(UIColor *)color;

//原来的所属的cell的y轴坐标值
@property (nonatomic ,assign) CGFloat offsetY;


//转场动画
- (void)aminmationShow;


@end
