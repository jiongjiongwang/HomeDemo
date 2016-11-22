//
//  ContentView.h
//  HomeDemo
//
//  Created by dn210 on 16/11/22.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import <UIKit/UIKit.h>

//类似于重新创建一个cell
@interface ContentView : UIView

//从外界获取label的标识
@property (nonatomic,copy)NSString *labelStr;

- (instancetype)initWithFrame:(CGRect)frame dataStr:(NSString *)strData collor:(UIColor *)collor;


@end
