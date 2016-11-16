//
//  HomeViewCell.m
//  HomeDemo
//
//  Created by dn210 on 16/11/16.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "HomeViewCell.h"
#import "Masonry.h"


@interface HomeViewCell()

@property (nonatomic,weak)UIView *headView;

@end


@implementation HomeViewCell

//在此初始化方法内对cell进行设置
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUpUI];
    }
    return self;
}

//设置子控件
-(void)setUpUI
{
    self.contentView.backgroundColor = [UIColor blackColor];
    
    //1-先加载一个View在tableview头部
    UIView *headView = [[UIView alloc] init];
    
    self.headView = headView;
    
    headView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:headView];
    
    
    
    
    
    
    //2-加载一个tableView到cell中
    HomeTableController *tableVC = [[HomeTableController alloc] init];
    
    self.tableVC = tableVC;
    
    
    [self.contentView addSubview:tableVC.view];
}

//布局子界面，设置嵌入的tableView的大小
-(void)layoutSubviews
{
    [super layoutSubviews];
    

    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top).offset(0.5);
        
        make.leading.trailing.equalTo(self.contentView);
        
        make.height.equalTo(@40);
    }];
    
    [self.tableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_headView.mas_bottom).offset(0.5);
        
        make.leading.trailing.equalTo(self.contentView);
        
        make.bottom.equalTo(self.contentView);
    }];
    
    
    
    
    //self.tableVC.view.frame = self.bounds;
}




@end
