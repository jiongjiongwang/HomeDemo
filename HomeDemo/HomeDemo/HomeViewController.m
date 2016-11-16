//
//  HomeViewController.m
//  HomeDemo
//
//  Created by dn210 on 16/11/16.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "HomeViewController.h"
#import "Masonry.h"
#import "HomeViewCell.h"



@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

//1-navigation背景
@property (nonatomic,weak)UIView *naviBackView;


//2-音色按钮
@property (nonatomic,weak)UIButton *leftButton;

//3-友鼓按钮
@property (nonatomic,weak)UIButton *rightButton;

//4-按钮下面的横线
@property (nonatomic,weak)UIView *lineView;

//5-navigation下面的可以消失的view
@property (nonatomic,weak)UIView *drumView;

//6-collectionView的flowLayout
@property (nonatomic,weak)UICollectionViewFlowLayout *flowLayout;

//7-collectionView
@property (nonatomic,weak)UICollectionView *homeCollectionView;


@end

@implementation HomeViewController

static NSString *collectionIdentifier = @"collectCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //将系统的NavigationController隐藏掉
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    //NavigationController的触发事件取消掉
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    //自定义navigationController
    [self setNav];
    
    //设置navigationController下面的DrumView
    //[self setUpDrumView];
    
    //设置位于中下部的collectionView
    [self setUpCollectionView];
}

//自定义navigationController
-(void)setNav
{
    //1-主题背景(UIView)
    UIView *naviBackView = [[UIView alloc] init];
    
    self.naviBackView = naviBackView;
    
    naviBackView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:naviBackView];
    
    [naviBackView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.top.trailing.equalTo(self.view);
        
        make.height.equalTo(@80);
        
    }];
    
    
    
    //1-左右两个按钮
    //1.1-音色按钮
    UIButton *leftButton = [[UIButton alloc] init];
    
    self.leftButton = leftButton;
    
    [leftButton setTitle:@"音色" forState:UIControlStateNormal];
    
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    [naviBackView addSubview:leftButton];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(naviBackView.mas_bottom).offset(-10);
        make.leading.equalTo(naviBackView.mas_leading).offset(120);
    }];
    
    
    //1.2-友鼓按钮
    UIButton *rightButton = [[UIButton alloc] init];
    
    self.rightButton = rightButton;
    
    [rightButton setTitle:@"友鼓" forState:UIControlStateNormal];
    
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    [naviBackView addSubview:rightButton];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(naviBackView.mas_bottom).offset(-10);
        make.trailing.equalTo(naviBackView.mas_trailing).offset(-120);
    }];

    
    //2-按钮下面的横线
    UIView *lineView = [[UIView alloc] init];
    
    self.lineView = lineView;
    
    lineView.backgroundColor = [UIColor blackColor];
    
    [naviBackView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(leftButton.mas_bottom).offset(0.5);
        make.centerX.equalTo(leftButton.mas_centerX);
        make.height.equalTo(@2);
        make.left.equalTo(naviBackView).offset(110);
    }];
    
}

//设置DrumView
-(void)setUpDrumView
{
    UIView *drumView = [[UIView alloc] init];
    
    self.drumView = drumView;
    
    drumView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:drumView];
    
    [drumView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.naviBackView.mas_bottom).offset(1);
        
        make.leading.trailing.equalTo(self.view);
        
        make.height.equalTo(@40);
    }];
}

//设置位于中下部的collectionView
-(void)setUpCollectionView
{
    //(1)实例化一个流水型布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.flowLayout = flowLayout;
    
    
    //设置行间距
    flowLayout.minimumLineSpacing = 0;
    
    //设置列间距
    flowLayout.minimumInteritemSpacing = 0;
    
    
    //设置cell的滚动方向(默认为垂直方向)
    //滚动方向改变之后,行内距和列内距设置就相反了
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //(2)利用flowLayout来实例化一个collectionView
    //暂时把frame设置为zero，待会利用手动方式设置Auto Layout
    UICollectionView *homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    //设置背景
    homeCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.homeCollectionView = homeCollectionView;
    
    homeCollectionView.pagingEnabled = YES;
    homeCollectionView.bounces = NO;
    homeCollectionView.showsHorizontalScrollIndicator = NO;
    
    
    [self.view addSubview:homeCollectionView];

    
    //(3)设置collectionView的layout
    [homeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.naviBackView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    //设置代理
    homeCollectionView.dataSource = self;
    
    homeCollectionView.delegate = self;
    
    
    //必须使用注册的方式来使用collection的cell
    [homeCollectionView registerClass:[HomeViewCell class] forCellWithReuseIdentifier:collectionIdentifier];
    
}

//布局子控件时设置flowLayout
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.flowLayout.itemSize = self.homeCollectionView.frame.size;
}

//实现collectionView的数据源方法
//1-组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//2-item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

//3-item内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
