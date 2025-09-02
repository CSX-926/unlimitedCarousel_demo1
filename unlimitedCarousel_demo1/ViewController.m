//
//  ViewController.m
//  unlimitedCarousel_demo1
//
//  Created by chensixin on 2025/9/1.
//


/*
 
 bug: 切换页面的时候又闪退
 
 */

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic, strong) NSTimer *timer;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置宽高
    const int scrollView_w = 300;
    const int scrollView_h = 150;
    
    // 创建一个 scrollview
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(50, 200, scrollView_w, scrollView_h);
    [self.view addSubview:self.scrollView];
    
    int imageCounts = 6;
    
    // 设置整个 contentsize 的大小
    self.scrollView.contentSize = CGSizeMake((imageCounts + 2) * scrollView_w, scrollView_h);
    
    
    // 创建一个装 imageview 的数组
    self.imageArray = [NSMutableArray array];
    
    
    for(int i = 0; i < imageCounts + 2; i++){
        
        NSString *image_name;
        
        if(i == 0){ // 在最前面装最后一张图片
//            UIImageView *lastImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_06"]];
            image_name  = [NSString stringWithFormat:@"image_06"];
        }else if (i == imageCounts + 1){ // 在最后面装第一张图片
//            UIImageView *lastImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"image_01"]];
            image_name  = [NSString stringWithFormat:@"image_01"];
        }else{
            image_name  = [NSString stringWithFormat:@"image_0%d", i];
        }
        
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image_name]];
        
        // 设置当前这个 imageview 的位置, x 是相对于 scrollview 左上角的位置，y 因为都在一条线上，所以 y 的相对位置是 0
        image.frame = CGRectMake(i*scrollView_w, 0, scrollView_w, scrollView_h);
        
        [self.imageArray addObject:image];
        [self.scrollView addSubview:image];
    }
    
    // 设置默认的开始页面，数组中的第2张，理论上的第1张
    [self.scrollView setContentOffset:CGPointMake(scrollView_w, 0)];
    
    
    // 设置分页功能
    self.scrollView.pagingEnabled = YES;
    
    // 不展示水平的索引条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置代理
    self.scrollView.delegate = self;
    
    
    // 初始化一个定时器，一秒钟执行一次
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(autoMovePage) userInfo:nil repeats:YES];
}


#pragma mark - 定时器
- (void)autoMovePage{
    // 根据当前滑动的位置，获取当前滑动到的图片
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    NSLog(@"定时器触发，滑动到下一张");
    
//    [self.scrollView setContentOffset:CGPointMake((index+1)*self.scrollView.frame.size.width, 0) animated:YES];
}


#pragma mark - delegate 行为

// 在执行滑动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 这个时候可以通过偏移的位置，获取当前的偏移量   再说废话🤣
//    NSLog(@"scrollViewDidScroll----");
//    [self scrollViewDidEndDecelerating:self.scrollView];
}


// 确定滑动的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    // 
//    NSLog(@"scrollViewDidEndDecelerating---");
    
    NSInteger imagesCount = self.imageArray.count;
    
    // 根据当前滑动的位置，获取当前滑动到的图片
    int index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    if(index == 0){ // 表示第一张还往前滑，就滑到了倒数第一张
        [self.scrollView setContentOffset:CGPointMake((imagesCount - 2) * self.scrollView.frame.size.width,
                                                      0)]; 
        NSLog(@"要滑倒最后一张");
    }
    else if(index == imagesCount - 1){ // 滑倒了最后一张，也就是咱们弄的虚假的最后一张，需要直接跳到真正的第一张
        // 也就是第二张
        [self.scrollView setContentOffset:CGPointMake( 1 * self.scrollView.frame.size.width,
                                                      0)];
        NSLog(@"要滑倒第一章");
    }else{
        // 但是会打印多次
        NSLog(@"正常的滑倒下一张");
    }
    
}


@end
