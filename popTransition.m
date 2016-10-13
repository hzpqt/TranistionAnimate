//
//  popTransition.m
//  TranistionAnimate
//
//  Created by peng_qitao on 16/10/11.
//  Copyright © 2016年 peng_qitao. All rights reserved.
//

#import "popTransition.h"
#import "RootViewController.h"
#import "DetailViewController.h"

@implementation popTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7f;
}


- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    [self doPopAnimation:transitionContext];
}

- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    DetailViewController *fromVC = (DetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    RootViewController *toVC = (RootViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    
    //获取详情页截图
    UIView *snapShotView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    snapShotView.frame = finalFrameForVC;
    
    //详情页、列表页加入到containerView
    UIView *containerView = [transitionContext containerView];
    toVC.view.frame = finalFrameForVC;
    toVC.view.alpha = 1.0f;
    
    [containerView insertSubview:toVC.view atIndex:0];
    
    [containerView addSubview:snapShotView];
    
    [fromVC.view removeFromSuperview];
    
    //关键帧动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    void (^anima)() = ^() {
        
        for (int i = 0; i < 5; i++) {
            [UIView addKeyframeWithRelativeStartTime:((i/5.f) * duration)  //每帧开始的时间
                                    relativeDuration:0.2 * duration      //每帧持续的时间
                                          animations:^{
                snapShotView.transform = CGAffineTransformMakeScale(1, 1 - (i+1)/5.f); //y轴每帧缩小到最开始的几分之几  4/5 3/5 2/5 1/5 0
                snapShotView.alpha = 1 - (i+1)/5.f;
            }];
        }
    };
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:anima
                              completion:^(BOOL finished) {
        
        if (finished) {
            
            [snapShotView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
    }];
}
@end
