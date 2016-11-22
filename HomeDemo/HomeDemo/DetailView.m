//
//  DetailView.m
//  HomeDemo
//
//  Created by dn210 on 16/11/22.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "DetailView.h"


//屏幕的长度(固定值)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface DetailView()




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
        
        ContentView *contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 200) dataStr:strData collor:color];
        
        self.contentView = contentView;
        
        [self addSubview:contentView];
        
        
    }

    
    return self;
}

//转场动画
- (void)aminmationShow
{
    self.contentView.frame = CGRectMake(0, self.offsetY, kScreenWidth, 120);
    
    [UIView animateWithDuration:0.5 animations:^{

        self.contentView.frame = CGRectMake(0, 64, kScreenWidth, 200);
        
        
        
        
    } completion:^(BOOL finished) {
        
        
        
        
    }];
    
    
    
}


//结束转场动画，返回主界面
- (void)animationDismissUsingCompeteBlock:(void (^)(void))complete;
{
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect rec = self.contentView.frame;
        rec.origin.y = self.offsetY;
        rec.size.height = 120;
        self.contentView.frame = rec;
        
    } completion:^(BOOL finished) {
        
        
        //            _rilegoule
        //
        [self removeFromSuperview];
        
        complete();
        
    }];
}


@end
