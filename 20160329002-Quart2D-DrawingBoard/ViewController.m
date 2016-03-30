//
//  ViewController.m
//  20160329002-Quart2D-DrawingBoard
//
//  Created by Rainer on 16/3/29.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"
#import "DrawingBoardView.h"
#import "ImageHandleView.h"
#import "MBProgressHUD+XMG.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet DrawingBoardView *drawingBoardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  改变线宽处理事件
 */
- (IBAction)lineWeithSliderValueChanged:(UISlider *)sender {
    self.drawingBoardView.lineWidth = sender.value;
}

/**
 *  设置画笔颜色处理事件
 */
- (IBAction)lineColorButtonClickAction:(UIButton *)sender {
    self.drawingBoardView.lineColor = sender.backgroundColor;
}

/**
 *  顶部工具条按钮处理事件
 */
- (IBAction)toolBarButtonItemClickAction:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1: // 清屏
            [self.drawingBoardView cleanScreen];
            
            break;
        case 2: // 撤销
            [self.drawingBoardView cancleSomething];
            
            break;
        case 3: // 擦除
            self.drawingBoardView.lineColor = [UIColor whiteColor];
            
            break;
        case 4: // 相册
            [self selectPictureFromImagePicker];
            
            break;
        case 10: // 保存
            [self saveDrawBoardToPhotosAlbum];
            break;
        default:
            break;
    }
}

/**
 *  从相册中选取图片
 */
- (void)selectPictureFromImagePicker {
    // 创建一个相册选择控制器
    UIImagePickerController *imagePickerController  = [[UIImagePickerController alloc] init];
    
    // 设置相片来源
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 设置代理
    imagePickerController.delegate = self;
    
    // 以modal的形势弹出控制器视图
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

/**
 *  相册选择照片完成代理事件
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 1.取得选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    // 2.图片处理
    // 2.1.创建一个图片处理视图
    ImageHandleView *imageHandleView = [[ImageHandleView alloc] initWithFrame:self.drawingBoardView.bounds];
    
    // 2.2.设置图片视图中的图片
    imageHandleView.image = image;
    
    // 2.3.将图片视图添加到画板视图上
    [self.drawingBoardView addSubview:imageHandleView];
    
    // 2.4.回调设置画板的图片
    imageHandleView.imageHandleCompletionBlock = ^(UIImage *image) {
        self.drawingBoardView.image = image;
    };
    
    // 3.关闭modal控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  将画板保存到相册
 */
- (void)saveDrawBoardToPhotosAlbum {
    // 1.创建一个和画板同等大小的位图上下文
    UIGraphicsBeginImageContextWithOptions(self.drawingBoardView.frame.size, NO, 0.0);
    
    // 2.获取当前上下文，并将当前画板的图层渲染到上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.drawingBoardView.layer renderInContext:context];
    
    // 3.从当前上下文中生成一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    // 5.将图片保存到相册中
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

/**
 *  这个是将图片保存到相册中是否成功的唯一指定通知方法
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (nil == error) {
        [MBProgressHUD showSuccess:@"保存成功"];
    } else {
        [MBProgressHUD showSuccess:@"保存失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
