//
//  DrawingBoardView.m
//  20160329002-Quart2D-DrawingBoard
//
//  Created by Rainer on 16/3/29.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "DrawingBoardView.h"

@interface DrawingBoardView ()

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) NSMutableArray *bezierPathArray;

@end

@implementation DrawingBoardView

- (void)awakeFromNib {
    [self setupGestureRecognizer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupGestureRecognizer];
    }
    
    return self;
}

- (void)setupGestureRecognizer {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint currentPoint = [panGestureRecognizer locationInView:self];

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.bezierPath = [UIBezierPath bezierPath];
        
        [self.bezierPath moveToPoint:currentPoint];
        
        [self.bezierPathArray addObject:self.bezierPath];
    }
    
    [self.bezierPath addLineToPoint:currentPoint];
    
    [self setNeedsDisplay];
}

- (NSMutableArray *)bezierPathArray {
    if (nil == _bezierPathArray) {
        _bezierPathArray = [NSMutableArray array];
    }
    
    return _bezierPathArray;
}

- (void)drawRect:(CGRect)rect {
    for (UIBezierPath *bezierPath in self.bezierPathArray) {
        [bezierPath stroke];
    }
}

@end
