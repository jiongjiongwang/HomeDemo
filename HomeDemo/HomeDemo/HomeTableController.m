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
#import "NewController.h"
#import "DetailView.h"


//屏幕的长度(固定值)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kScreenWidth [UIScreen mainScreen].bounds.size.width


@interface HomeTableController ()

//上一次滑动的距离
@property (nonatomic,assign)CGFloat preDistance;

//headView的消失和显示判断
@property (nonatomic,assign)BOOL headViewDisappear;


//下拉时显示的图片
@property (nonatomic,weak)UIImageView *gifImages;


//下拉刷新的messageLabel
@property (nonatomic,weak)UILabel *messageLabel;

//上拉刷新的菊花
@property (nonatomic,weak)UIActivityIndicatorView *footIndicatorView;
//上拉刷新的message
@property (nonatomic,weak)UILabel *footMessageLabel;

//加载数据的数组
@property (nonatomic,strong)NSMutableArray<NSString *> *mDataArray;

//点击cell之后的生成新的View
@property (nonatomic,weak)DetailView *detailView;


@end

@implementation HomeTableController

static NSString *identify = @"homeTableCell";

-(NSMutableArray<NSString *> *)mDataArray
{
    if (_mDataArray == nil)
    {
        _mDataArray = [NSMutableArray array];
        
        for (NSUInteger i = 0; i < 20; i++)
        {
            NSString *str = [NSString stringWithFormat:@"音乐%ld",i+1];
            
            [_mDataArray addObject:str];
                             
        }
        
    }
    
    return _mDataArray;
}




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
    
    return self.mDataArray.count;
}

//3-行内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    NSString *str = self.mDataArray[indexPath.row];
    
    cell.labelStr = str;
    
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
    
    
    if (distance < -55 && scrollView.dragging == YES)
    {
        //下拉到了极限了
        [_messageLabel setText:@"松开手刷新"];
    }
    else if (distance >= -55 && distance <0 && scrollView.dragging == YES)
    {
        //正在下拉过程中
        [_messageLabel setText:@"下拉刷新"];
        
        //得出索引的整数部分
        int index = 60 * -(distance) / 55;
        
        //NSLog(@"%d",index);
        
        //得出UIImage
        UIImage *getGifImage = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", index]];
        
        [self.gifImages setImage:getGifImage];
        
    }
    
    
    if (distance > 55)
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
    
    NSUInteger dataCount = self.mDataArray.count;
    
    //下拉拖拽结束时
    if (distance < -55)
    {
        
        [UIView animateWithDuration:2 animations:^{
            
            //隐藏下拉刷新信息
            [_messageLabel setText:@"刷新中"];
            
            
            [self ImageStartAnimate];
            
            
            //整个tableView向下移动60距离
            scrollView.contentInset = UIEdgeInsetsMake(55, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
            
        } completion:^(BOOL finished) {
            
            //[_messageLabel setText:@"刷新出10条数据"];
            
            [self ImageStopAnimate];
            
            
            [UIView animateWithDuration:0.2 animations:^{
                
                //整个tableView返回原来的位置
                scrollView.contentInset = UIEdgeInsetsMake(0, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
                
            } completion:^(BOOL finished) {
               
                [_messageLabel setText:@"下拉刷新"];
            }];
            
        }];
    }
    
    
    
    
    
    //上拉拖拽时
    CGFloat contentHeight = scrollView.contentSize.height;
    //49是tabBar的高度(通过获取得到)
    //NSLog(@"tabBar的高度=%f",[UITabBar appearance].bounds.size.height);
    //80是navigation的高度(自定义)
    //49是footView的高度
    if (distance + kScreenHeight - 49 - 80 + 68 > contentHeight + 19)
    {
        //NSLog(@"上拉刷新中");
        
        [UIView animateWithDuration:2 animations:^{
            
            _footMessageLabel.hidden = NO;
            
            //菊花开始转动
            [self.footIndicatorView startAnimating];
            
            //整个tableView向上移动49距离
            scrollView.contentInset = UIEdgeInsetsMake(-50, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
            
        } completion:^(BOOL finished) {
            
            //菊花停止转动
            [self.footIndicatorView stopAnimating];
            
            _footMessageLabel.hidden = YES;
            
            [UIView animateWithDuration:1 animations:^{
                
                //整个tableView返回原来的位置
                scrollView.contentInset = UIEdgeInsetsMake(0, scrollView.contentInset.left, scrollView.contentInset.bottom, scrollView.contentInset.right);
                
                
            } completion:^(BOOL finished) {
                
                
                //添加新的数据
                for (NSUInteger i = dataCount; i < dataCount + 5; i++)
                {
                    NSString *str = [NSString stringWithFormat:@"音乐%ld",i+1];
                    
                    [self.mDataArray addObject:str];
                }
                
                //刷新数据
                [self.tableView reloadData];
                
                
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
       
        //NSLog(@"点击了第%ld组第%ld行的内容",indexPath.section,indexPath.row);
        /*
        NewController *newViewController = [[NewController alloc] init];
        
        
        newViewController.title = [NSString stringWithFormat:@"%ld组第%ld行",indexPath.section,indexPath.row];
        
        UINavigationController *newNav = [[UINavigationController alloc] initWithRootViewController:newViewController];
        
        [self.navigationController pushViewController:newNav animated:YES];
        */
        
    }];
    
    
    rowAction2.backgroundColor = [UIColor blueColor];
    
    return @[rowAction1,rowAction2];
}
//8-点击cell的触发事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showImageAtIndexPath:indexPath];
}

//点击cell之后出现了新的View(是View,不是到了另一个Controller)
- (void)showImageAtIndexPath:(NSIndexPath *)indexPath
{
    //取cell
    HomeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //取cell得数据
    NSString *strData = self.mDataArray[indexPath.row];
    
    //取当前cell的y轴上的坐标
    CGRect rect = [cell convertRect:cell.bounds toView:nil];
    CGFloat y = rect.origin.y;
    
    DetailView *detailView = [[DetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) dataStr:strData index:indexPath.row andCellColor:cell.backgroundColor];
    
    self.detailView = detailView;
    
    detailView.offsetY = y;
    
    //NSLog(@"[[[self.tableView superview] superview] superview] = %@",[[[[self.tableView superview] superview] superview] superview]);
    
    [[[[[self.tableView superview] superview] superview] superview]    addSubview:detailView];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *Swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    
    detailView.contentView.userInteractionEnabled = YES;
    
    Swipe.direction = UISwipeGestureRecognizerDirectionDown;
    
    [detailView.contentView addGestureRecognizer:Swipe];
    
    
    //开启转场动画
    [detailView aminmationShow];
    
}


//手势触发
- (void)panAction:(UISwipeGestureRecognizer *)swipe
{
    
    [_detailView animationDismissUsingCompeteBlock:^{
        
        _detailView = nil;
    }];
}



//自定义tableView的headerView(添加下拉刷新控件)
-(void)setUpHeaderView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 55)];
    
    headView.backgroundColor = [UIColor redColor];
    
    self.tableView.tableHeaderView = headView;
    
    
    //添加刷新messageLabel
    UILabel *messageLabel = [[UILabel alloc] init];
    
    self.messageLabel = messageLabel;
    
    messageLabel.text = @"下拉刷新";
    
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    
    [messageLabel setFont:[UIFont systemFontOfSize:10]];
    
    [headView addSubview:messageLabel];
    
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headView.mas_centerX);
        
        make.bottom.equalTo(headView.mas_bottom).offset(0);
        
    }];
    
    
    
    //添加一个图片到headerView上
    UIImageView *gifImages = [[UIImageView alloc] init];
    
    self.gifImages = gifImages;
    
    [gifImages setImage:[UIImage imageNamed:@"dropdown_anim__0001"]];
    
    [gifImages sizeToFit];
    
    [headView addSubview:gifImages];
    
    [gifImages mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(headView.mas_centerX);
        
        make.bottom.equalTo(headView.mas_bottom).offset(-6);
        
    }];
    
    
}

//正在刷新：正在吃包子
-(void)ImageStartAnimate
{
    //设置图片数组
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (NSUInteger i = 1; i<=3; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        
        [imageArray addObject:image];
    }
    
    //开始转动
    [_gifImages stopAnimating];
    
    _gifImages.animationImages = imageArray;
    
    _gifImages.animationDuration = imageArray.count * 0.1;
    
    [_gifImages startAnimating];
}

//停止刷新
-(void)ImageStopAnimate
{
    [_gifImages stopAnimating];
}


//添加上拉刷新的View作为footView
-(void)setUpFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 68)];
    
    footView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = footView;
    
    
    //添加刷新messageLabel
    UILabel *footMessageLabel = [[UILabel alloc] init];
    
    self.footMessageLabel = footMessageLabel;
    
    footMessageLabel.text = @"正在努力加载";
    
    [footMessageLabel setTextAlignment:NSTextAlignmentCenter];
    
    [footMessageLabel setFont:[UIFont systemFontOfSize:13]];
    
    [footView addSubview:footMessageLabel];
    
    //初始化隐藏
    footMessageLabel.hidden = YES;
    
    [footMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(footView);
        
        make.centerX.equalTo(footView.mas_centerX);
        
    }];
    
    
    //添加上拉刷新菊花
    UIActivityIndicatorView *footIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.footIndicatorView = footIndicatorView;
    
    [footView addSubview:footIndicatorView];
    
    
    [footIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(footMessageLabel.mas_trailing).offset(10);
        
        make.top.equalTo(footView);
        
    }];
    
    
}

 
@end
