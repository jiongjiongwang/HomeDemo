//
//  DetailView.m
//  HomeDemo
//
//  Created by dn210 on 16/11/22.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "DetailView.h"
#import "ContentView.h"

//屏幕的长度(固定值)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface DetailView()

@property (nonatomic,weak)ContentView *contentView;


@end


@implementation DetailView

- (instancetype)initWithFrame:(CGRect)frame dataStr:(NSString *)strData index:(NSInteger)index andCellColor:(UIColor *)color
{
    self = [super initWithFrame:frame];

    
    if (self)
    {
        
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES;
        
        ContentView *contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) dataStr:strData collor:color];
        
        self.contentView = contentView;
        
        [self addSubview:contentView];
        
        
    }

    
    return self;
}

//转场动画
- (void)aminmationShow
{
    
}


@end
