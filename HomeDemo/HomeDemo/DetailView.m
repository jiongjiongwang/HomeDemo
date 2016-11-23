//
//  DetailView.m
//  HomeDemo
//
//  Created by dn210 on 16/11/22.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "DetailView.h"
#import "DescriptionView.h"

//屏幕的长度(固定值)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface DetailView()

@property (nonatomic,weak)DescriptionView *descriptionView;


@end


@implementation DetailView

- (instancetype)initWithFrame:(CGRect)frame dataStr:(NSString *)strData index:(NSInteger)index andCellColor:(UIColor *)color
{
    self = [super initWithFrame:frame];

    
    if (self)
    {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES;
        
        //上
        ContentView *contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200) dataStr:strData collor:color];
        
        self.contentView = contentView;
        
        [self addSubview:contentView];
        
        
        
        //下
        DescriptionView *descriptionView = [[DescriptionView alloc] initWithFrame:CGRectMake(0,200, kScreenWidth, kScreenHeight - 264) dataStr:@"当前音乐是。。。。"];
        
        self.descriptionView = descriptionView;
        
        [self addSubview:descriptionView];
        
    }

    
    return self;
}

//转场动画
- (void)aminmationShow
{
    //上
    self.contentView.frame = CGRectMake(0, self.offsetY, kScreenWidth, 120);
    
    
    //下
    self.descriptionView.frame = CGRectMake(0, self.offsetY, kScreenWidth, 120);
    
    
    [UIView animateWithDuration:0.5 animations:^{

        //上
        self.contentView.frame = CGRectMake(0, 0, kScreenWidth, 200);
        
        
        //下
        self.descriptionView.frame = CGRectMake(0, 200, kScreenWidth, kScreenHeight - 200);
        
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
        //上
        self.contentView.frame = rec;
        
        //下
        self.descriptionView.frame = rec;
        
        
    } completion:^(BOOL finished) {
        
        
        
        [self.descriptionView removeFromSuperview];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            
            
        } completion:^(BOOL finished) {
            
            //DetailView移除并销毁
            [self removeFromSuperview];
            
            complete();
        }];
        
    }];
}


@end
