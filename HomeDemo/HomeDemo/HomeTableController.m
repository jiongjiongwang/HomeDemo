//
//  HomeTableController.m
//  HomeDemo
//
//  Created by dn210 on 16/11/16.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "HomeTableController.h"
#import "HomeTableViewCell.h"


@interface HomeTableController ()

//上一次滑动的距离
@property (nonatomic,assign)CGFloat preDistance;

//headView的消失和显示判断
@property (nonatomic,assign)BOOL headViewDisappear;

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

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    
    headView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = headView;
    
    
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
    
    //NSLog(@"distance = %f",scrollView.contentOffset.y);
    
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

 
@end
