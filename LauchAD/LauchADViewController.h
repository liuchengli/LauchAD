//
//  LauchADViewController.h
//  ZiPeiYi
//
//  Created by 刘成利 on 16/11/18.
//  Copyright © 2016年 刘成利. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LogoType = 100,        // 带logo的广告
    FullScreenType = 101,  // 全屏的广告
}ADType;

/*
 * 1 = 点击广告     
 * 2 = 点击跳过【或】展示时间完毕
 * 3 = 图片加载失败【或】网络请求失败【或】网络超时
 * 4 = 二级广告页返回事件
 */
typedef void (^CallbackEvent) (NSInteger tag);



@interface LauchADViewController : UIViewController

/**
 *  无数据时长 （默认2秒，最小1秒）
 */
@property (nonatomic, assign) NSInteger   noDataDuration;

/**
 *  广告展示时长（默认2秒，最小1秒）
 */
@property (nonatomic, assign) NSInteger   showDuration;

/**
 *  网络图片URL
 */
@property (nonatomic, strong) NSString    *imgUrl;

/**
 *  广告类型（全屏或者带logo屏，默认全屏）
 */
@property (nonatomic, assign) ADType      lauchADType;

/**
 *  事件回调
 */
@property (nonatomic, copy) CallbackEvent eventBlock;

/**
 *  消失后进入的根控制器（也可在CallbackEvent处理）
 */
@property (nonatomic, strong) UIViewController *homeRootVC;


@end
