//
//  HomeTableController.m
//  HomeDemo
//
//  Created by dn210 on 16/11/16.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "HomeTableController.h"
#import "HomeTableViewCell.h"
#import "Masonry.h"


@interface HomeTableController ()

//上一次滑动的距离
@property (nonatomic,assign)CGFloat preDistance;

//headView的消失和显示判断
@property (nonatomic,assign)BOOL headViewDisappear;

//下拉刷新的菊花
@property (nonatomic,weak)UIActivityIndicatorView *indicatorView;

//下拉刷新的messageLabel
@property (nonatomic,weak)UILabel *messageLabel;

//上拉刷新的菊花
@property (nonatomic,weak)UIActivityIndicatorView *footIndicatorView;
//上拉刷新的message
@property (nonatomic,weak)UILabel *footMessageLabel;

@end

@implementation HomeTableController

static NSString *identify = @"homeTableCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化preDistance
    _preDistance = 0;
    
    //初始化headViewDisappear
    _headViewDisappear = NO;
    

    [self setUpHeaderView];
    
    [self setUpFooterView];
    
    
    [self.tableView registerClass:[HomeTableViewCell class] forCellReuseIdentifier:identify];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//1-组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//2-行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
}

//3-行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    cell.cellNum = indexPath.row + 1;
    
    
    return cell;
}

//4-cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
//6-滑动tableView时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat distance = scrollView.contentOffset.y;
    
    CGFloat deltaDistance = distance - _preDistance;
    
    //NSLog(@"distance = %f",scrollView.contentOffset.y);
    
    if (distance < -50 && scrollView.dragging == YES)
    {
        [_messageLabel setText:@"松开手刷新"];
    }
    else if (distance >= -50 && distance <0 && scrollView.dragging == YES)
    {
        [_messageLabel setText:@"下拉刷新"];
    }
    
    
    if (distance > 50)
    {
        
        //大于50且处于上拉阶段的时候才消失headView
        if (deltaDistance >= 0)
        {
            if (_headViewDisappear == NO)
            {
                //发通知给headView,headView消失
                [[NSNotificationCenter defaultCenter] postNotificationName:@"headViewChange" object:self userInfo:@{@"disAppear":@(1)}];
                
                //更新为消失
                _headViewDisappear = YES;
            }
                
        }
        //大于50但是处于下拉状态的时候显示headView
        else
        {
            if (_headViewDisappear == YES)
            {
                //发通知给headView,headView显示
                [[NSNotificationCenter defaultCenter] postNotificationName:@"headViewChange" object:self userInfo:@{@"disAppear":@(0)}];
                
                //更新为显示
                _headViewDisappear = NO;
            }

        }
    }
    else
    {
        if (_headViewDisappear == YES)
        {
            //发通知给headView,headView显示
            [[NSNotificationCenter defaultCenter] postNotificationName:@"headViewChange" object:self userInfo:@{@"disAppear":@(0)}];
            
            //更新为显示
            _headViewDisappear = NO;
        }
    }
    
    //更新preDistance
    _preDistance = scrollView.contentOffset.y;
}


//下拉拖拽结束时
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat distance = scrollView.contentOffset.y;

    //NSLog(@"distance = %f",distance);
    
    //下拉拖拽结束时
    if (distance < -50)
    {
        
        [UIView animateWithDuration:2 animations:^{
            
            //隐藏下拉刷新信息
            [_messageLabel setText:@"刷新中"];
            
            //菊花开始转动
            [self.indicatorView startAnimating];
            
            //整个tableView向下移动50距离
            scrollView.contentInset = UIEdgeInsetsMake(50, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
            
        } completion:^(BOOL finished) {
            
            [_messageLabel setText:@"刷新出10条数据"];
            
            //菊花停止转动
            [self.indicatorView stopAnimating];
            
            [UIView animateWithDuration:1.5 animations:^{
                
                //整个tableView返回原来的位置
                scrollView.contentInset = UIEdgeInsetsMake(0, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
                
            } completion:^(BOOL finished) {
               
                [_messageLabel setText:@"下拉刷新"];
            }];
            
        }];
    }
    
    //上拉拖拽时
    CGFloat contentHeight = scrollView.contentSize.height;
    
    //NSLog(@"contentHeight = %f",contentHeight);
    
    //CGFloat contentInsetTop = scrollView.contentInset.bottom;
    
    //NSLog(@"contentInsetTop = %f",contentInsetTop);
    
    //得出屏幕的长度(固定值)
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    NSLog(@"%f",distance + screenHeight - 49 - 80 + 49);
    //49是tabBar的高度(通过获取得到)
    //NSLog(@"tabBar的高度=%f",[UITabBar appearance].bounds.size.height);
    
    //80是navigation的高度(自定义)
    //50是headView的高度
    if (distance + screenHeight - 49 - 80 + 49 > contentHeight + 25)
    {
        //NSLog(@"上拉刷新中");
        
        
        [UIView animateWithDuration:2 animations:^{
            
            _footMessageLabel.hidden = NO;
            
            //菊花开始转动
            [self.footIndicatorView startAnimating];
            
            //整个tableView向上移动49距离
            scrollView.contentInset = UIEdgeInsetsMake(-49, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
            
        } completion:^(BOOL finished) {
            
            //菊花停止转动
            [self.footIndicatorView stopAnimating];
            
            _footMessageLabel.hidden = YES;
            
            [UIView animateWithDuration:0.5 animations:^{
                
                //整个tableView返回原来的位置
                scrollView.contentInset = UIEdgeInsetsMake(0, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
                
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
        
    }
    
}

//7-设置删除或其他业务
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *rowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        NSLog(@"点击了删除");
        
        
    }];
    rowAction1.backgroundColor = [UIColor redColor];
    
    
    UITableViewRowAction *rowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        NSLog(@"点击了第%ld组第%ld行的内容",indexPath.section,indexPath.row);
        
    }];
    
    
    rowAction2.backgroundColor = [UIColor blueColor];
    
    return @[rowAction1,rowAction2];
}

//自定义tableView的headerView(添加下拉刷新控件)
-(void)setUpHeaderView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    headView.backgroundColor = [UIColor redColor];
    
    self.tableView.tableHeaderView = headView;
    
    
    
    //添加一个菊花到headerView上‘
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.indicatorView = indicatorView;
    
    [headView addSubview:indicatorView];
    
    
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(headView.mas_centerX);
        
        make.centerY.equalTo(headView.mas_centerY);
        
    }];
    
    
    
    //添加刷新messageLabel
    UILabel *messageLabel = [[UILabel alloc] init];
    
    self.messageLabel = messageLabel;

    messageLabel.text = @"下拉刷新";
    
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    
    [messageLabel setFont:[UIFont systemFontOfSize:10]];
    
    [headView addSubview:messageLabel];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(headView.mas_centerX);
        
        make.top.equalTo(indicatorView.mas_bottom).offset(2);
        
    }];
    
    
}

//添加上拉刷新的View作为footView
-(void)setUpFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
    
    footView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = footView;
    
    
    //添加刷新messageLabel
    UILabel *footMessageLabel = [[UILabel alloc] init];
    
    self.footMessageLabel = footMessageLabel;
    
    footMessageLabel.text = @"正在努力加载";
    
    [footMessageLabel setTextAlignment:NSTextAlignmentCenter];
    
    [footMessageLabel setFont:[UIFont systemFontOfSize:15]];
    
    [footView addSubview:footMessageLabel];
    
    //初始化隐藏
    footMessageLabel.hidden = YES;
    
    [footMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(footView.mas_centerY);
        
        make.centerX.equalTo(footView.mas_centerX);
        
    }];
    
    
    //添加上拉刷新菊花
    UIActivityIndicatorView *footIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.footIndicatorView = footIndicatorView;
    
    [footView addSubview:footIndicatorView];
    
    
    [footIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(footMessageLabel.mas_trailing).offset(10);
        
        make.centerY.equalTo(footView.mas_centerY);
        
    }];
    
    
}

 
@end
