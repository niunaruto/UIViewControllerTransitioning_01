//
//  ViewController.m
//  Dome01
//
//  Created by anlaiye on 16/5/26.
//  Copyright © 2016年 wangmingmin. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "NNPushTest.h"
@interface ViewController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *pan;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interaction;
@end

@implementation ViewController
- (UIScreenEdgePanGestureRecognizer *)pan{
    if (!_pan) {
        _pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlEdgeScreenPanGesture:)];
        _pan.edges = UIRectEdgeRight;

        
    }
    return _pan;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
    
    // 假如你得动画总时长是5秒钟，那么当你的手指从640 -》 0这个过程的时候
    // 每移动一个pixel的位置，你的动画就执行了5.0/640秒的时间
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addGestureRecognizer:self.pan];
}

- (void)handlEdgeScreenPanGesture:(UIScreenEdgePanGestureRecognizer *)sender
{
    NSLog(@"x position is %f",[sender translationInView:self.view].x);
    CGFloat progress = (-1 * [sender translationInView:self.view].x)/CGRectGetWidth(self.view.frame);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.interaction = [[UIPercentDrivenInteractiveTransition alloc] init];
            // [self.navigationController pushViewController:@"xxx" animated:YES];
            [self performSegueWithIdentifier:@"kPushToSecond" sender:nil];
            break;
        case UIGestureRecognizerStateChanged:
            [self.interaction updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (progress >= 0.5) {
                [self.interaction finishInteractiveTransition];
            }else {
                [self.interaction cancelInteractiveTransition];
                //[self.navigationController popViewControllerAnimated:YES];
            }
            self.interaction = nil;
        }
        default:
            break;
    }
}

- (IBAction)show:(id)sender {
    [self.navigationController pushViewController:[ViewController2 new] animated:YES];
}
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [[NNPushTest alloc] init];
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    return self.interaction;
}
@end
