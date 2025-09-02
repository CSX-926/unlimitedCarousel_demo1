//
//  ViewController.m
//  unlimitedCarousel_demo1
//
//  Created by chensixin on 2025/9/1.
//


#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) UIPageControl *pageControl;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置宽高
    const int scrollView_w = 300;
    const int scrollView_h = 150;
    
    int imageCounts = 6;
    
    
    // 创建一个 scrollview
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(50, 200, scrollView_w, scrollView_h);
    [self.view addSubview:self.scrollView];
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
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(autoMovePage) userInfo:nil repeats:YES];
    
    
    // 初始化一个 pageControl
    self.pageControl = [[UIPageControl alloc] init];
//    NSLog(@"X %ld", (long)CGRectGetMaxX(self.scrollView.frame));
    NSInteger pageControlWidth = 140;
    // scrollview 的 y 值 作为参照
    self.pageControl.frame = CGRectMake(CGRectGetMaxX(self.scrollView.frame) - pageControlWidth,
                                        CGRectGetMaxY(self.scrollView.frame) - 20,
                                        pageControlWidth,
                                        20);
    
    self.pageControl.numberOfPages = imageCounts;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.pageControl];
}


#pragma mark - 定时器
- (void)autoMovePage{
    // 根据当前滑动的位置，获取当前滑动到的图片
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    NSLog(@"定时器触发，滑动到下一张");
    
    [self.scrollView setContentOffset:CGPointMake((index+1)*self.scrollView.frame.size.width, 0) animated:YES];
}


#pragma mark - delegate 行为

// 用户在滑动的时候，更新 pagecontrol 页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    // 计算出下页的滑动
    NSInteger nextIndex = self.scrollView.contentOffset.x / pageWidth + 0.5;
    
    // 实现滑动到一半的时候，底下的索引就变化
    self.pageControl.currentPage = nextIndex - 1; // -1 是因为前面有一个最后一页的虚拟页，在上面计算出来的是包含虚拟页的，这个值是指包含这个虚拟页是的第几页；但是 currentPage 是不包含虚拟页的，也就是只有 6 页。
    
    // 更新 curpage 索引
    if(nextIndex == 0){ // 当前的索引在虚假的最后一页
        self.pageControl.currentPage = self.imageArray.count - 2 - 1; // 设置为真正的最后一页
    }else if(nextIndex == self.imageArray.count - 1){ // 当前的索引在虚假的第一页
        self.pageControl.currentPage = 0; // 设置为真正的第一页，对于 pageControl 来说就是 0
    }
}



// 滑动结束的时候，确定最终停在哪一页，根据 curpage 的值来实现偏移
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger nextpage = self.pageControl.currentPage + 1; // 这里设置的是偏移，所以要加上前面的虚拟页 + 1
    
     // 根据当前 pagecontrol 的页码，设置偏移
    [self.scrollView setContentOffset:CGPointMake(nextpage * pageWidth,
                                                  0)];
}





//// 用户在滑动的时候，更新 pagecontrol 页码
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    
//    NSInteger curIndex = self.scrollView.contentOffset.x / pageWidth;
//    
//    // 更新 curpage 索引
//    if(curIndex == 0){ // 当前的索引在虚假的最后一页
//        self.pageControl.currentPage = self.imageArray.count - 2 - 1; // 设置为真正的最后一页
//    }else if(curIndex == self.imageArray.count - 1){ // 当前的索引在虚假的第一页
//        self.pageControl.currentPage = 0; // 设置为真正的第一页，对于 pageControl 来说就是 0
//    }else{
//        self.pageControl.currentPage = curIndex - 1;
//    }
//}

//// 判断当前页是否是虚拟页然后执行跳转
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSInteger imagesCount = self.imageArray.count;
//    
//    // 根据当前滑动的位置，获取当前滑动到的图片
//    int pageIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
//    
//    if(pageIndex == 0){ // 表示第一张还往前滑，就滑到了倒数第一张
//        [self.scrollView setContentOffset:CGPointMake((imagesCount - 2) * self.scrollView.frame.size.width, 0)]; 
//    }
//    else if(pageIndex == imagesCount - 1){ // 滑倒了最后一张，也就是咱们弄的虚假的最后一张，需要直接跳到真正的第一张
//        // 也就是第二张
//        [self.scrollView setContentOffset:CGPointMake( 1 * self.scrollView.frame.size.width, 0)];
//        
//    }
////    else{
////        NSLog(@"正常的滑倒下一张");
////        
////    }
//}



@end
