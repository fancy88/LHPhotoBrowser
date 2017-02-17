//
//  ViewController.m
//  LHPhotoBrowser
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"
#import "SDImageCache.h"

@interface ViewController ()<XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

/**
 * scrollView
 */
@property (nonatomic , strong) UIScrollView  *scrollView;
/**
 * 图片数组
 */
@property (nonatomic , strong) NSMutableArray  *images;
/**
 *  url strings
 */
@property (nonatomic , strong) NSArray  *urlStrings;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.images = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.xl_width = XLScreenW - 30;
    self.scrollView.xl_height = 100;
    self.scrollView.xl_x = 15;
    self.scrollView.xl_y = 100;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor grayColor];
    
    for (int i = 1 ; i < 11 ; i ++) {
        NSString *string = [NSString stringWithFormat:@"photo%zd.jpg",i];
        UIImage *image = [UIImage imageNamed:string];
        [self.images addObject:image];
    }
    
    [self resetScrollView];

}

- (void)clearImageCache
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)resetScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat imageWidth = 100;
    CGFloat margin = 10;
    for (int i = 0 ; i < self.images.count; i ++) {
        UIImageView *headerImageView = [[UIImageView alloc] init];
        headerImageView.tag = i;
        headerImageView.userInteractionEnabled = YES;
        [headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
        headerImageView.xl_x = (imageWidth + margin) * i;
        headerImageView.xl_y = 0;
        headerImageView.xl_width = imageWidth;
        headerImageView.xl_height = imageWidth;
        headerImageView.image = self.images[i];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.layer.masksToBounds = YES;
        [self.scrollView addSubview:headerImageView];
    }
    self.scrollView.contentSize = CGSizeMake((imageWidth + margin) * self.images.count, 0);
}


- (void)clickImage:(UITapGestureRecognizer *)tap
{
     UIImageView *imgView = (UIImageView *)tap.view;
     [XLPhotoBrowser showPhotoBrowserWithImages:self.images currentImageIndex:imgView.tag];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
