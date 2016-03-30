//
//  ImageHandleView.h
//  20160329002-Quart2D-DrawingBoard
//
//  Created by Rainer on 16/3/30.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageHandleView : UIView

/** 图片 */
@property (nonatomic, strong) UIImage *image;

/** 回调返回新图片 */
@property (nonatomic, strong) void(^imageHandleCompletionBlock)(UIImage *image);

@end
