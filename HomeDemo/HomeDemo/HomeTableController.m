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

/*
//5-headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    
    headView.backgroundColor = [UIColor redColor];
    
    
    return headView;
}
*/
//6-滑动tableView时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat distance = scrollView.contentOffset.y;
    
    CGFloat deltaDistance = distance - _preDistance;
    
    NSLog(@"distance = %f",scrollView.contentOffset.y);
    
    //下拉刷新时
    if (distance < -50)
    {

        [UIView animateWithDuration:0.25 animations:^{
            
            //隐藏下拉刷新信息
            //_messageLabel.hidden = YES;
            [_messageLabel setText:@"刷新中"];
            
            //菊花开始转动
            [self.indicatorView startAnimating];
            
            //整个tableView向下移动50距离
            scrollView.contentInset = UIEdgeInsetsMake(50, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
            
        } completion:^(BOOL finished) {
            
            
        }];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

 
@end
