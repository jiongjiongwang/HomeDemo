//
//  MainController.m
//  HomeDemo
//
//  Created by dn210 on 16/11/16.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "MainController.h"
#import "HomeViewController.h"
#import "SecondController.h"
#import "MyInfoController.h"


@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置子控制器
    [self setUpControllers];
    
    //设置tabbar的颜色
    self.tabBar.backgroundColor = [UIColor blueColor];
    
    //设置半透明的tabBar
    self.tabBar.alpha = 0.5;
    
    
    
}

//设置子控制器
-(void)setUpControllers
{
    //1-home界面
    [self addChildController:[[HomeViewController alloc] init] WithTitle:@"音色" WithImageName:@"tab1"];
    
    //2-第二个界面
    [self addChildController:[[SecondController alloc] init] WithTitle:@"求谱" WithImageName:@"tab2"];
    
    //3-我的信息界面
    [self addChildController:[[MyInfoController alloc] init]WithTitle:@"我的" WithImageName:@"tab3"];
    
}

//根据图片和名来添加子控制器
-(void)addChildController:(UIViewController *)childVc WithTitle:(NSString *)title WithImageName:(NSString *)imageName
{
    childVc.title = title;
    
    //设置tabBar图片
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置点击图片
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置富文本文字颜色
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    
    //添加到tabbarVC上
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:childVc]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
