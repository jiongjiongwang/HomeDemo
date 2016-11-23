//
//  SecondViewCell.m
//  HomeDemo
//
//  Created by dn210 on 16/11/18.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "SecondViewCell.h"
#import "JSDownloadView.h"
#import "Masonry.h"
#import "JSDownLoadManager.h"


@interface SecondViewCell()<JSDownloadAnimationDelegate>

//3-下载的动画View
@property (nonatomic,weak)JSDownloadView *downLoadView;

@property (nonatomic, strong) JSDownLoadManager *manager;

//设置定时器
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)NSUInteger count;

@end


@implementation SecondViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUpUI];
        
    }
    return self;
}


-(void)setUpUI
{
    self.backgroundColor = [UIColor blueColor];
    
    
    //3-下载的动画View
    JSDownloadView *downLoadView = [[JSDownloadView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50,self.frame.size.height/2 - 50, 100, 100)];
    
    
    self.downLoadView = downLoadView;
    
    downLoadView.progressWidth = 4;
    
    downLoadView.delegate = self;
    
    [self.contentView addSubview:downLoadView];
    
    //设置约束不管用??
    /*
    [downLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView.mas_centerY);
        //make.trailing.equalTo(self.contentView.mas_trailing).offset(-70);
        make.centerX.equalTo(self.contentView.mas_centerX);        //make.height.width.equalTo(@100);
    }];
    */
    
}

- (void)downTask
{
    
    _count = 0;
    
    //设置定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(labelUpdate) userInfo:nil repeats:YES];
    
    /*
    [self.manager downloadProgress:^(NSUInteger hasDownload) {
     
                             //根据下载信息更新下载界面
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                 NSString *progressString  = [NSString stringWithFormat:@"%ld",hasDownload];
                                 
                                 self.downLoadView.progress = progressString.floatValue;
                                 
                                 if (hasDownload == 100)
                                 {
                                     //此时已在主线程
                                     self.downLoadView.isSuccess = YES;
                                 }
                                 
                             });
                             
                         }];
     */
    
    
}

//定时器方法
-(void)labelUpdate
{
    //1-取数字
    NSString *progressString  = [NSString stringWithFormat:@"%ld",_count];
    
    self.downLoadView.progress = progressString.integerValue;
    
    if (_count == 100)
    {
        self.downLoadView.isSuccess = YES;
        
        [_timer invalidate];
    }
    
    
    _count+= 1;
    
}



- (void)animationStart
{
    [self downTask];
}


@end
