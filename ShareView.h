//
//  ShareView.h
//  tefubao
//
//  Created by ah on 15/12/1.
//  Copyright © 2015年 hzc. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ShareViewDelegate <NSObject>

@required

- (void)ShareViewBtnDidiClickWithTag:(NSString *)snsName;

@end

@interface ShareView : UIView

@property (nonatomic ,weak)id <ShareViewDelegate>delegate;


- (void)appear;

- (void)hidden;

//- shareViewWithTarget:(id)target Selector:SEL;

@end
