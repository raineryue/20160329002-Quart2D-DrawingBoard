//
//  DrawingBoardView.m
//  20160329002-Quart2D-DrawingBoard
//
//  Created by Rainer on 16/3/29.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "DrawingBoardView.h"
#import "DrawBoardBezierPath.h"

@interface DrawingBoardView ()

@property (nonatomic, strong) DrawBoardBezierPath *bezierPath;
@property (nonatomic, strong) NSMutableArray *bezierPathArray;

@end

@implementation DrawingBoardView

/**
 *  通过xib或者storyboard创建时
 *  解析完成时调用
 */
- (void)awakeFromNib {
    self.lineWidth = 1;
    
    // 设置手势
    [self setupGestureRecognizer];
}

/**
 *  通过纯代码创建时调用
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置手势
        [self setupGestureRecognizer];
    }
    
    return self;
}

/**
 *  设置手势
 */
- (void)setupGestureRecognizer {
    // 创建一个轻扫手势并添加代理事件
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    
    // 将手势添加到当前视图上
    [self addGestureRecognizer:panGestureRecognizer];
}

/**
 *  处理轻扫手势事件
 */
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 1.获取当前触摸到的点
    CGPoint currentPoint = [panGestureRecognizer locationInView:self];

    // 2.当触摸点开始时创建一个路径并把当前点作为路径的起点
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // 2.1.创建一个贝赛尔路径
        self.bezierPath = [[DrawBoardBezierPath alloc] init];
        
        // 2.2.设置属性
        // 设置线宽
        [self.bezierPath setLineWidth:self.lineWidth];
        // 设置线色
        self.bezierPath.bezierPathColor = self.lineColor;
        
        // 2.3.设置当前触摸点为路径起点
        [self.bezierPath moveToPoint:currentPoint];
        
        // 2.4.将当前路径存储到数组中
        [self.bezierPathArray addObject:self.bezierPath];
    }
    
    // 3.添加一条线到当前移动点上
    [self.bezierPath addLineToPoint:currentPoint];
    
    // 4.重绘
    [self setNeedsDisplay];
}

/**
 *  懒加载创建贝赛尔路径数组
 */
- (NSMutableArray *)bezierPathArray {
    if (nil == _bezierPathArray) {
        _bezierPathArray = [NSMutableArray array];
    }
    
    return _bezierPathArray;
}

/**
 *  复写画图方法
 */
- (void)drawRect:(CGRect)rect {
    // 循环取出路径画到视图上
    for (DrawBoardBezierPath *bezierPath in self.bezierPathArray) {
        if ([bezierPath isKindOfClass:[UIImage class]]) {
            UIImage *pathImage = (UIImage *)bezierPath;
            
            [pathImage drawInRect:rect];
        } else {
            [bezierPath.bezierPathColor set];
            [bezierPath stroke];
        }
    }
}

/**
 *  清屏功能处理
 */
- (void)cleanScreen {
    [self.bezierPathArray removeAllObjects];
    
    [self setNeedsDisplay];
}

/**
 *  取消功能处理
 */
- (void)cancleSomething {
    [self.bezierPathArray removeLastObject];
    
    [self setNeedsDisplay];
}

/**
 *  相册图片
 */
- (void)setImage:(UIImage *)image {
    _image = image;
    
    [self.bezierPathArray addObject:image];
    
    [self setNeedsDisplay];
}

@end
