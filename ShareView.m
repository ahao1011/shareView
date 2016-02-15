//
//  ShareView.m
//  tefubao
//
//  Created by ah on 15/12/1.
//  Copyright © 2015年 hzc. All rights reserved.
//


#define K_matio .7f
#define K_Url @"http://dwz.cn/2hbCBD"

#import "ShareView.h"
#import "shareButton.h"
#import "UIView+Extension.h"
#import "UMSocial.h"

#import "UMSocialQQHandler.h"  //  qq以及qq空间
#import "UMSocialSinaHandler.h"  // 新浪
#import "UMSocialWechatHandler.h"  // 微信

@interface ShareView ()

@property (nonatomic,strong)UIScrollView *shareScrollView;
@property (nonatomic,strong)UIView *cancleView;
@property (nonatomic,strong)UIButton *cancleBtn;

/**
 *  m蒙板
 */
@property (nonatomic,strong)UIView *backView;




@end

@implementation ShareView

/**UM设置的一些基本信息*/
+ (void)registUMInfo{
    
  
        [UMSocialData setAppKey:@"5656f0b567e58ea178001a93"];
        //打开调试log的开关
        [UMSocialData openLog:YES];
        //  qq
        [UMSocialQQHandler setQQWithAppId:@"1104919337" appKey:@"9eeUUkEtVHbUAC4G" url:K_Url];
        //设置支持没有客户端情况下使用SSO授权
        [UMSocialQQHandler setSupportWebView:YES];
        // 新浪
        //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
        [UMSocialSinaHandler openSSOWithRedirectURL:K_Url];
        //设置微信AppId、appSecret，分享url
        [UMSocialWechatHandler setWXAppId:@"wx2d632b14a1e070bf" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:K_Url];
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor =[UIColor whiteColor];
        [self addsubViews];
        self.layer.cornerRadius = 13.5f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

/**
 *  添加子控件
 */
- (void)addsubViews{
    
   
    UIScrollView *shareScrollView = [[UIScrollView alloc]init];
    [self addSubview:shareScrollView];
    self.shareScrollView = shareScrollView;
    UIView *cancleView = [[UIView alloc]init];
    [self addSubview:cancleView];
    self.cancleView = cancleView;
    _backView = [[UIView alloc]init];
}

/**
 *  子控件frame
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //shareScrollView 的framg
    
    self.shareScrollView.frame = CGRectMake(0, 0, self.width, self.height * K_Matio);
    // 取消按钮面板
    self.cancleView.frame = CGRectMake(0, self.shareScrollView.height, self.width, self.height * (1-K_Matio));
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.cancleView.width, self.cancleView.height)];
    MYLog(@"%@",NSStringFromCGRect(btn.frame));
    [btn setTitleColor:AHColor(16, 129, 255) forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancleBtn = btn;
    [self.cancleView addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self configShare];

}

/**
 *  添加分享面板
 */
- (void)configShare{
    
    NSArray *imageArr = @[@"ic_share_weibo",@"ic_share_kongjian",@"ic_share_qq",@"ic_share_weixin",@"ic_share_pengyouquan",@"ic_share_tengxun"];
    NSArray *titleArr = @[@"新浪微博",@"QQ空间",@"QQ",@"微信",@"朋友圈",@"腾讯微博"];
    for (int i = 0; i<imageArr.count; i++) {
        int rank = i / 4;// 行
        int arrange = i%4; //列
        CGFloat w = K_ScreenWidth/4;
        CGFloat h = w;
        shareButton *btn = [[shareButton alloc]initWithFrame:CGRectMake(w*arrange,h*rank, w, h)];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.tag = 1000+1+i;
        [btn addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchDown];
        [self.shareScrollView addSubview:btn];
        if (i==imageArr.count-1) {
            
            self.shareScrollView.contentSize = CGSizeMake(0, btn.y + btn.height);
        }
    }
    
}

- (void)btnAction1:(shareButton *)btn{
    
    switch (btn.tag) {
            
        case 1001: { //新浪微博
            NSArray *arr = [NSArray arrayWithObject:UMShareToSina];
            [self Share:arr];
        }
            break;
        case 1002: { // qq空间
            NSArray *arr = [NSArray arrayWithObject:UMShareToQzone];
            [self Share:arr];            }
            break;
        case 1003:{ // qq
            NSArray *arr = [NSArray arrayWithObject:UMShareToQQ];
            [self Share:arr];
        }
            break;
        case 1004:{ //微信
            NSArray *arr = [NSArray arrayWithObject:UMShareToWechatSession];
            [self Share:arr];
        }
            break;
        case 1005: {// 微信朋友圈
            NSArray *arr = [NSArray arrayWithObject:UMShareToWechatTimeline];
            [self Share:arr];
        }
            break;
        case 1006:{ //腾讯微博l,
            NSArray *arr = [NSArray arrayWithObject:UMShareToTencent];
            [self Share:arr];
        }
            break;
    }
    
}

- (void)Share:(NSArray *)arr{
    [self text:arr.lastObject];
}
- (void)text:(NSString *)name{
    
    
    if ([self.delegate respondsToSelector:@selector(ShareViewBtnDidiClickWithTag:)]) {
        [self.delegate ShareViewBtnDidiClickWithTag:name];
    }
}

- (void)btnClick:(shareButton *)btn{
    
    
    [self hidden];
}

- (void)appear{
    self.backView = [self creatView];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self.backView];
    [window addSubview:self];
    [UIView animateWithDuration:.5f animations:^{
        self.y = K_ScreenHeight - self.height;
        _backView.alpha = 0.5;
    }];
}

- (UIView *)creatView{
    
    UIView *backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    MYLog(@"蒙板========%@",NSStringFromCGRect(_backView.frame));
    backView.alpha = 0;
    UITapGestureRecognizer *recongnizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
    [backView addGestureRecognizer:recongnizer];
    return backView;
}

- (void)hidden{
    [UIView animateWithDuration:.5f animations:^{
        self.y = K_ScreenHeight;
        _backView.alpha = 0;
    } completion:^(BOOL finished) {
        [_backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
