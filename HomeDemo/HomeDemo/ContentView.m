//
//  ContentView.m
//  HomeDemo
//
//  Created by dn210 on 16/11/22.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "ContentView.h"
#import "Masonry.h"

@interface ContentView()

//1-图片
@property (nonatomic,weak)UIImageView *cellImage;

//2-标签
@property (nonatomic,weak)UILabel *cellLabel;


@end


@implementation ContentView

- (instancetype)initWithFrame:(CGRect)frame dataStr:(NSString *)strData collor:(UIColor *)collor
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = collor;
        
        self.labelStr = strData;
        
        //设计Ui布局
        [self setUpUI];
    }
    
    
    return self;
}
-(void)setUpUI
{
    //1-图片
    UIImageView *cellImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"game replay"]];
    
    [self addSubview:cellImage];
    
    [cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self).offset(30);
        
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    //2-label
    UILabel *cellLabel = [[UILabel alloc] init];
    
    self.cellLabel = cellLabel;
    
    [cellLabel setTextAlignment:NSTextAlignmentCenter];
    
    [cellLabel setFont:[UIFont systemFontOfSize:15]];
    
    [cellLabel setText:self.labelStr];
    
    [self addSubview:cellLabel];
    
    [cellLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        
        make.leading.equalTo(cellImage.mas_trailing).offset(20);
        
    }];
}


@end
