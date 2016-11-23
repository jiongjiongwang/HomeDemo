//
//  DescriptionView.m
//  HomeDemo
//
//  Created by dn210 on 16/11/23.
//  Copyright © 2016年 dn210. All rights reserved.
//

#import "DescriptionView.h"
#import "Masonry.h"

@interface DescriptionView()

//介绍label
@property (nonatomic,weak)UILabel *descripLabel;


@end


@implementation DescriptionView

- (instancetype)initWithFrame:(CGRect)frame dataStr:(NSString *)strData
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.descripStr = strData;
        
        //设计Ui布局
        [self setUpUI];
    }
    
    return self;
}
//设计UI布局
-(void)setUpUI
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    //添加一个label到上面
    UILabel *descripLabel = [[UILabel alloc] init];
    
    self.descripLabel = descripLabel;
    
    [descripLabel setTextAlignment:NSTextAlignmentLeft];
    
    [descripLabel setFont:[UIFont systemFontOfSize:18]];
    
    [descripLabel setText:self.descripStr];
    
    [self addSubview:descripLabel];
    
    [descripLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.equalTo(self).offset(50);
        
        make.trailing.equalTo(self).offset(-50);
        
        make.top.equalTo(self).offset(10);
        
    }];
    


}


@end
