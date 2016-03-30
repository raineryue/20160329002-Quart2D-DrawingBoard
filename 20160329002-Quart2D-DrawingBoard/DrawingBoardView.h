//
//  DrawingBoardView.h
//  20160329002-Quart2D-DrawingBoard
//
//  Created by Rainer on 16/3/29.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingBoardView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIImage *image;

- (void)cleanScreen;
- (void)cancleSomething;

@end
