//
//  LauchADViewController.m
//  ZiPeiYi
//
//  Created by 刘成利 on 16/11/18.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

#import "LauchADViewController.h"
#import "UIImageView+WebCache.h"


#define mainWidth       [[UIScreen mainScreen] bounds].size.width

/**
 *  未检测到广告数据,启动页默认停留时间3秒
 */
static NSInteger const noDataDefaultDuration = 3;
/**
 *  广告页默认展示时长，默认2秒
 */
static NSInteger const displayADDuration = 3;

@interface LauchADViewController ()

@property (nonatomic, strong) UIImageView      *launchImgView;        // 启动图
@property (nonatomic, strong) UIImageView      *ADImgView;            // 广告图
@property (nonatomic, strong) UIButton         *skipButton;           // 跳过按钮,可自定义替换
@property (nonatomic, strong) UIView           *skipWebView;          // 点击跳转的网页
//@property (nonatomic, strong) LauchADModel     *ADModel;            // 广告模型
//@property (nonatomic, strong) V_2_X_Networking *launchADNetworking; // 广告网络请求

@property (nonatomic, copy)dispatch_source_t     networkDurationTimer;      // 网络延迟时长
@property (nonatomic, copy)dispatch_source_t     displayDurationTimer;      // 广告展示时长

@property (nonatomic, assign) BOOL               isNetworkDelay;
@property (nonatomic, strong) NSString           *ADImageUrl;// 网络请求下来的广告图片地址
@end



@implementation LauchADViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 广告跳过按钮请自行在添加，每个公司的跳过按钮样式不一样；
    
    // 1.设置启动页为背景图
    [self.view addSubview:self.launchImgView];
    
    
    
    // 给定图片地址则直接用SDWebImage  直接加载图片
    if(self.imgUrl){
     
        [self.view addSubview:self.ADImgView];


    
    }else {
    
    
        // 2.子线程计时网络延时
        [self startNetworkingTimer];
        
        // 3.网络请求获取广告图片地址
        [self getLauchADNetworking];

    
    
    }
    
    
    
    
}

#pragma mark - 页面、数据初始化
#pragma mark - 计时器
// 网络延时计时
- (void)startNetworkingTimer{
    
    if (self.noDataDuration == 0) {
        self.noDataDuration = noDataDefaultDuration;
    }else if (self.noDataDuration <1){
        
        self.noDataDuration = 1;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _networkDurationTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_networkDurationTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    
    __block NSInteger duration = self.noDataDuration;
    dispatch_source_set_event_handler(_networkDurationTimer, ^{
        
        
        if(duration==0)
        {
            dispatch_source_cancel(_networkDurationTimer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 网络延时退出
                [self exitADController:3];
                self.isNetworkDelay = YES;
                
                
            });
        }
        
        duration--;
    });
    dispatch_resume(_networkDurationTimer);
    
    
    
}


// 广告展示计时
- (void)startDisplayTimer{
    
    if (self.showDuration == 0) {
        self.showDuration = displayADDuration;
    }else if (self.showDuration <1){
        
        self.showDuration = 1;
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _displayDurationTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_displayDurationTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    
    __block NSInteger duration = self.showDuration;
    dispatch_source_set_event_handler(_displayDurationTimer, ^{
        
        
        if(duration==0)
        {
            dispatch_source_cancel(_displayDurationTimer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 展示完毕
                [self exitADController:2];
                
            });
        }
        
        duration--;
    });
    dispatch_resume(_displayDurationTimer);
    
    
    
}

#pragma mark - 网络请求
- (void)getLauchADNetworking {

    
    // 网络请求获取广告图片地址及其他信息
    
    // 1.发起网络请求
    {
    
    
    
    }
    
    
    // 2.网络请求成功时【将请求下来的地址图片赋值给ADImageUrl】
    
    {
    
        if (self.ADImageUrl.length > 0) {
            
            [self.view addSubview:self.ADImgView];
            
            
        }else{ // 图片地址不可用
            
            // 取消计时
            dispatch_source_cancel(_networkDurationTimer);
            [self exitADController:3];
        }
        

    
    
    }
    
    
    // 3.网络请求失败时
    
    {
    
        // 请求失败退出
        dispatch_source_cancel(_networkDurationTimer);
        [self exitADController:3];
    
    }
    
}





#pragma mark - 控件响应方法
// 点击了广告
- (void)tapADAction:(UITapGestureRecognizer *)tap{

    [self exitADController:1];
}

//  退出广告控制器
- (void)exitADController:(NSInteger)eventFloat{

    
    if (self.isNetworkDelay == YES) {
        return;   // 网络超时不再进入
    }
    
    /*
     * 1 = 点击广告     
     * 2 = 点击跳过【或】展示时间完毕
     * 3 = 图片加载失败【或】网络请求失败【或网络超时】
     * 4 = 二级广告页返回事件
     */
    
    switch (eventFloat) {
        case 1:
        {
            [self secondWebView];
            
            if (self.eventBlock)
            {
                self.eventBlock(1);
            }
        }
            break;
            
        case 2:
        {
           [self changetoRootVC];
            
            if (self.eventBlock)
            {
                self.eventBlock(2);
            }
        }
            break;
            
        case 3:
        {
            
           
           // 加了一个广告启动页到根控制器的翻转动画
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [UIView transitionWithView:[[UIApplication sharedApplication].delegate window] duration:0.5 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
                BOOL oldState=[UIView areAnimationsEnabled];
                [UIView setAnimationsEnabled:NO];
                window.rootViewController = self.homeRootVC;
                [UIView setAnimationsEnabled:oldState];
                
            }completion:NULL];
            
            if (self.eventBlock)
            {
                self.eventBlock(3);
            }

        
        }
            break;
            
        case 4:
        {
            
            if (self.eventBlock)
            {
                self.eventBlock(4);
            }
        }
            break;
        default:
            break;
    }
    
    

}

// 广告点击进入二级web页
-(void)secondWebView{
    
    /*  处理点击广告后事件，一般是加载一个webview   */
    
    
}




#pragma mark - 私有方法
- (void)changetoRootVC{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    window.rootViewController = self.homeRootVC;
    
    //    UIViewAnimationOptionTransitionFlipFromRight
    //    UIViewAnimationOptionTransitionCrossDissolve
    [UIView transitionWithView:[[UIApplication sharedApplication].delegate window] duration:0.45 options: UIViewAnimationOptionTransitionFlipFromRight animations:^{
        BOOL oldState=[UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        //        _isShowFinish = YES;
        //        if(_showFinishBlock)  _showFinishBlock();
        window.rootViewController = self.homeRootVC;
        [UIView setAnimationsEnabled:oldState];
    }completion:NULL];
    
    
}

#pragma mark - 图片处理和下载
-(UIImage *)getLaunchImage
{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if(imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if(imageL) return imageL;
    NSLog(@"LaunchImage获取失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}

// 根据横竖屏
-(UIImage *)launchImageWithType:(NSString *)type
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"])
            {
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize))
            {
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}

// 下载图片
- (void)downloadADImage{

//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadImageWithURL:[NSURL URLWithString:_imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if (image) {
//            
//            [self.ADImgView setImage:[self imageCompressForWidth:image targetWidth:mainWidth]];
//        }
//    }];
    
    NSString *temp = @"";
    if (self.imgUrl) {
        
        temp = self.imgUrl;
        
    }else{
    
        temp = self.ADImageUrl;
    
    }
    
    NSURL *pictureUrl = [NSURL URLWithString:temp];
    __weak LauchADViewController *wself = self;
    [self.ADImgView sd_setImageWithPreviousCachedImageWithURL:pictureUrl
                                                 placeholderImage:nil
                                                          options:0
                                                         progress:nil
                                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                            
                                                            if(!wself.imgUrl)
                                                            {
                                                            // 1.取消网络延时计时器
                                                             dispatch_source_cancel(_networkDurationTimer);
                                                            }
                                                            
                                                                // 2.开始广告展示计时
                                                                [wself startDisplayTimer];
                                                                
                                                                wself.ADImgView.image = [self imageCompressForWidth:image targetWidth:mainWidth];
                                                                wself.ADImgView.alpha = 0.2;
                                                                
                                                                [UIView animateWithDuration:0.3 animations:^{
                                                                    
                                                                    wself.ADImgView.alpha = 1.f;
                                                                }];

                                                        }];



}

// 指定宽度按比例缩放
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    //    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}





#pragma mark - 懒加载
-(UIImageView *)launchImgView
{
    if(_launchImgView==nil)
    {
        
        _launchImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _launchImgView.image = [self getLaunchImage];
    }
    return _launchImgView;
}

-(UIImageView *)ADImgView
{
    if(_ADImgView==nil)
    {
        if (self.lauchADType == LogoType) {
            _ADImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-[[UIScreen mainScreen] bounds].size.width/3)];
        }else{
            _ADImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        // 下载图片
        [self downloadADImage];
        _ADImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapADAction:)];
        [_ADImgView addGestureRecognizer:tap];
    }
    return _ADImgView;
}


-(void)setNoDataDuration:(NSInteger)noDataDuration
{
    if(noDataDuration<1)
    {
        noDataDuration=1;
    }
    _noDataDuration = noDataDuration;

}





//- (void)dealloc{
//
//    NSLog(@"广告页被释放");
//}

@end
