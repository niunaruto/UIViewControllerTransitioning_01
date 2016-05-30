//
//  NNPushTest.m
//  Dome01
//
//  Created by anlaiye on 16/5/30.
//  Copyright © 2016年 wangmingmin. All rights reserved.
//

#import "NNPushTest.h"

@implementation NNPushTest
/**
 *  返回动画的执行时间
 *
 *  @param transitionContext
 *
 *  @return
 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return  5.0;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    _transitionContext = transitionContext;
    /**
     *  来自哪个控制器
     */
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *container  = transitionContext.containerView;
    
    [container addSubview:fromViewController.view];
    [container addSubview:toViewController.view];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1/2000.0;//这个值是为了让动画的执行更加的接近真实的效果
    toViewController.view.layer.transform = transform;
    
    toViewController.view.layer.anchorPoint = CGPointMake(1.0, 0.5);//设置锚点
    toViewController.view.center = CGPointMake(CGRectGetMaxX(fromViewController.view.frame), CGRectGetMidY(fromViewController.view.frame));
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.duration = [self transitionDuration:transitionContext];
    animation.fromValue = @(M_PI_2);
    animation.toValue = @(0);
    animation.delegate = self;
    [toViewController.view.layer addAnimation:animation forKey:@"rotateAnimation"];
    
    
    
}
/**
 *  CABasicAnimation的代理方法,可以知道什么时候这个动画执行完毕
 *
 *  @param anim
 *  @param flag
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [_transitionContext completeTransition:YES];
    }
}

@end
