//
//  STDCardTransitionDelegate.m
//  STKitDemo
//
//  Created by SunJiangting on 15-4-3.
//  Copyright (c) 2015年 SunJiangting. All rights reserved.
//

#import "STDCardTransitionDelegate.h"

@implementation STDCardTransitionDelegate

- (BOOL)navigationController:(STNavigationController *)navigationController
shouldBeginTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    return YES;
}

- (void)navigationController:(STNavigationController *)navigationController
  willBeginTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView, *transitionView = transitionContext.transitionView;
    STViewControllerTransitionType transitionType = transitionContext.transitionType;
    [self _transformAppliedToFromView:fromView andToView:toView withTransitionView:transitionView completion:0 transitionType:transitionType];
}

- (void)navigationController:(STNavigationController *)navigationController
       transitingWithContext:(STNavigationControllerTransitionContext *)transitionContext {
    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView, *transitionView = transitionContext.transitionView;
    CGFloat completion = transitionContext.completion;
    STViewControllerTransitionType transitionType = transitionContext.transitionType;
    [self _transformAppliedToFromView:fromView andToView:toView withTransitionView:transitionView completion:completion transitionType:transitionType];
}

- (void)_transformAppliedToFromView:(UIView *)fromView
                          andToView:(UIView *)toView
                 withTransitionView:(UIView *)transitionView
                         completion:(CGFloat)completion
                     transitionType:(STViewControllerTransitionType)transitionType {
    
    UIView *leftView, *rightView;
    CGFloat width = CGRectGetWidth(transitionView.bounds);
    CGFloat leftAngel, leftHeight, leftX, rightAngel, rightHeight, rightX,currentPanOffset, leftPanOffset, rightPanOffset;
    BOOL leftXAxis, rightXAxis;
    CGFloat leftViewOffset = 0, rightViewOffset = width;
    if (transitionType == STViewControllerTransitionTypePush) {
        leftView = fromView, rightView = toView;
        currentPanOffset = width * completion;
        leftPanOffset = (currentPanOffset - leftViewOffset), rightPanOffset = (currentPanOffset - rightViewOffset);
        leftX = - completion * width;
        rightX = width - completion * width;
    } else {
        leftView = toView, rightView = fromView;
        currentPanOffset = width - width * completion;
        leftPanOffset = (currentPanOffset - leftViewOffset), rightPanOffset = (currentPanOffset - rightViewOffset);
        leftX = completion * width - width;
        rightX = completion * width;
    }
    leftAngel = leftPanOffset / width, rightAngel = rightPanOffset / width;
    CGFloat heightOffset = 80;
    leftHeight = heightOffset * (leftAngel < 0 ? -leftAngel : leftAngel), rightHeight = heightOffset * (rightAngel < 0 ? -rightAngel : rightAngel);
    leftXAxis = (currentPanOffset > leftViewOffset), rightXAxis = (currentPanOffset > rightViewOffset);
    
    
    leftView.layer.transform = CATransform3DIdentity;
    leftView.left = leftX;
    leftView.layer.transform = [self transformfromAngle:leftAngel height:leftHeight xAxis:leftXAxis];
    
    rightView.layer.transform = CATransform3DIdentity;
    rightView.left = rightX;
    rightView.layer.transform = [self transformfromAngle:rightAngel height:rightHeight xAxis:rightXAxis];
}

- (void)navigationController:(STNavigationController *)navigationController didEndTransitionContext:(STNavigationControllerTransitionContext *)transitionContext {
    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView, *transitionView = transitionContext.transitionView;
    fromView.layer.transform = toView.layer.transform = CATransform3DIdentity;
    toView.left = 0;
    if (transitionContext == STViewControllerTransitionTypePush) {
        fromView.left = -CGRectGetWidth(transitionView.bounds);
    } else {
        fromView.left = CGRectGetWidth(transitionView.bounds) * transitionContext.completion;
        toView.left = CGRectGetWidth(transitionView.bounds) * (transitionContext.completion - 1);
    }
//    UIView *fromView = transitionContext.fromView, *toView = transitionContext.toView, *transitionView = transitionContext.transitionView;
//    CGFloat completion = transitionContext.completion;
//    STViewControllerTransitionType transitionType = transitionContext.transitionType;
//    [self _transformAppliedToFromView:fromView andToView:toView withTransitionView:transitionView completion:completion transitionType:transitionType];
    
}

- (CATransform3D)transformfromAngle:(CGFloat)angle
                             height:(CGFloat)height
                              xAxis:(BOOL)axis {
    CATransform3D t = CATransform3DIdentity;
    t.m34  = 1.0/-500;
    if (axis) {
        t = CATransform3DRotate(t,angle, 1, 1, 0);
    } else {
        t = CATransform3DRotate(t,angle, -1, 1, 0);
    }
//    NSLog(@"%@", [NSValue valueWithCATransform3D:t]);
    return t;
}

@end
