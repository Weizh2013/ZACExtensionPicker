//
//  ZACExtensionPickerView.h
//  Test
//
//  Created by Kingo on 2018/8/8.
//  Copyright © 2018年 Kingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZACExtesionContentCell.h"
#import "ZACExtensionTitleCell.h"

#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// RGB的颜色转换
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// 带透明度的颜色转换
#define kUIColorFromARGB(argbValue) [UIColor \
colorWithRed:((float)((argbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((argbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(argbValue & 0xFF))/255.0 \
alpha:((float)((argbValue & 0xFF000000) >> 24))/255.0]


typedef NS_ENUM(NSInteger, ZACExtensionPickerMaskType) {
    ZACExtensionPickerMaskTypeAll = 0,  // 全屏
//    ZACExtensionPickerMaskTypeTop,      // 控件的上方
//    ZACExtensionPickerMaskTypeBottom,   // 控件的下方
    ZACExtensionPickerMaskTypeNone,     // 无
};

@class ZACExtensionPickerView;

@protocol ZACExtensionPickerViewDataSource <NSObject>

@required
/**
 标题数量
 */
- (NSInteger)numberOfSectionInExtensionPicker:(ZACExtensionPickerView *)extensionPickerView;
/**
 标题Cell
 */
- (ZACExtensionTitleCell *)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView titleOfSection:(NSInteger)section;
/**
 内容数量
 */
- (NSInteger)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView numberOfContentOfSection:(NSInteger)section;
/**
 内容Cell
 */
- (ZACExtesionContentCell *)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView cellOfIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ZACExtensionPickerViewDelegate <NSObject>

@optional
/**
 选择了某个IndexPath
 */
- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 取消选择了某个IndexPath
 */
- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView didDeSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 将要展开某个Section
 */
- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView willExtensionSection:(NSInteger)section;
/**
 已经展开某个Section
 */
- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView didExtensionSection:(NSInteger)section;
/**
 将要收起某个Section
 */
- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView willCloseSection:(NSInteger)section;
/**
 已经收起某个Section
 */
- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView didCloseSection:(NSInteger)section;
/**
 高度开始变化
 */
- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView willChangeHeight:(CGFloat)height;
/**
 高度结束变化
 */
- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView didChangeHeight:(CGFloat)height;

@end

@interface ZACExtensionPickerView : UIView

/**
 标题栏颜色
 */
@property (nonatomic , strong) UIColor *titleBgColor;
/**
 mask类型
 */
@property (nonatomic , assign) ZACExtensionPickerMaskType maskType;

/**
 数据源
 */
@property (nonatomic , weak) id<ZACExtensionPickerViewDataSource> dataSource;
/**
 代理
 */
@property (nonatomic , weak) id<ZACExtensionPickerViewDelegate> delegate;

/**
 * 初始化方法
 * @param superView 父视图
 * @param topConstraint 顶部约束
 */
- (instancetype)initWithSuperView:(__weak UIView *)superView
                      titleHeight:(CGFloat)titleHeight
                    topConstraint:(CGFloat)topConstraint NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 重载View
 */
- (void)reloadData;
/**
 收起View
 */
- (void)closeExtension;

/**
 注册重用标识符
 */
- (void)registerNib:(UINib *)nib forTitleCellReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerClass:(nullable Class)class forTitleCellReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerNib:(UINib *)nib forContentCellReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerClass:(nullable Class)class forContentCellReuseIdentifier:(NSString *)reuseIdentifier;
/**
 取出Cell
 */
- (ZACExtensionTitleCell *)dequeueReusableTitleCellWithIdentifier:(NSString *)reuseIdentifier forSection:(NSInteger)section;
- (ZACExtesionContentCell *)dequeueReusableContentCellWithIdentifier:(NSString *)reuseIdentifier;

@end
















