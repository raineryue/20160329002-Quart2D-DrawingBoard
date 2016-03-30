//
//  ImageHandleView.m
//  20160329002-Quart2D-DrawingBoard
//
//  Created by Rainer on 16/3/30.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ImageHandleView.h"

@interface ImageHandleView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation ImageHandleView

/**
 *  创建当前类对象
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加手势
        [self setupGestureRecognizers];
    }
    
    return self;
}

/**
 *  添加手势
 */
- (void)setupGestureRecognizers {
    // 添加拖动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    
    [self addGestureRecognizer:panGestureRecognizer];
    
    // 添加捏合手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizerAction:)];
    
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 添加旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureRecognizerAction:)];
    
    [self addGestureRecognizer:rotationGestureRecognizer];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerAction:)];
    
    [self addGestureRecognizer:longPressGestureRecognizer];
}

/**
 * 添加拖动手势
 */
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint currentPoint = [panGestureRecognizer translationInView:self.imageView];
    
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, currentPoint.x, currentPoint.y);
    
    // 复位：只要想要相对于上一次就必须复位
    [panGestureRecognizer setTranslation:CGPointZero inView:self.imageView];
}

/**
 *  添加捏合手势
 */
- (void)pinchGestureRecognizerAction:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
    
    pinchGestureRecognizer.delegate = self;
    
    // 复位：只要想要相对于上一次就必须复位
    [pinchGestureRecognizer setScale:1];
}

/**
 *  添加旋转手势
 */
- (void)rotationGestureRecognizerAction:(UIRotationGestureRecognizer *)rotationGestureRecognizer {
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotationGestureRecognizer.rotation);
    
    rotationGestureRecognizer.delegate = self;
    
    // 复位：只要想要相对于上一次就必须复位
    [rotationGestureRecognizer setRotation:0];
}

/**
 *  添加长按手势
 */
- (void)longPressGestureRecognizerAction:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // 设置高亮的动画
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                // 这里实现截屏的功能
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                [self.layer renderInContext:context];
                
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                
                // 回调block将截好的图片传出去
                if (self.imageHandleCompletionBlock) {
                    self.imageHandleCompletionBlock(newImage);
                }
                
                // 从父控件中移除本控件
                [self removeFromSuperview];
            }];
        }];
    }
}

/**
 *  手势代理事件处理：返回是否允许多种手势操作
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/**
 *  复写image set方法
 */
- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = image;
}

/**
 *  懒加载创建图片视图
 */
- (UIImageView *)imageView {
    if (nil == _imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        imageView.userInteractionEnabled = YES;
        
        _imageView = imageView;
        
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

@end
