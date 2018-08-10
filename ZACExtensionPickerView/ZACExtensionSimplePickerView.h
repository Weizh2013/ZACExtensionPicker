//
//  ZACExtensionSimplePickerView.h
//  Test
//
//  Created by Kingo on 2018/8/9.
//  Copyright © 2018年 Kingo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZACExtensionPickerView.h"

@interface ZACExtensionSimplePickerView : ZACExtensionPickerView

/**
 常规图标
 */
@property (nonatomic , strong) UIImage *normalImage;
/**
 常规字体
 */
@property (nonatomic , strong) UIFont *normalFont;
/**
 常规字的颜色
 */
@property (nonatomic , strong) UIColor *normalColor;

/**
 展开图标
 */
@property (nonatomic , strong) UIImage *extensionImage;
/**
 展开字体
 */
@property (nonatomic , strong) UIFont *extensionFont;
/**
 展开字的颜色
 */
@property (nonatomic , strong) UIColor *extensionColor;

/**
 选择后图标
 */
@property (nonatomic , strong) UIImage *selectedImage;
/**
 选择后字体
 */
@property (nonatomic , strong) UIFont *selectedFont;
/**
 选择后字的颜色
 */
@property (nonatomic , strong) UIColor *selectedColor;

/**
 被选中的IndexPath
 */
@property (nonatomic , strong, readonly) NSArray<NSIndexPath *> *selectedIndexPaths;

/**
 * 重写 初始化方法
 * @param superView 父视图
 * @param topConstraint 顶部约束
 */
+ (instancetype)extensionViewWithSuperView:(__weak UIView *)superView
                              topConstrant:(CGFloat)topConstraint
                           completeHandler:(void(^)(NSIndexPath *indexPath))completeHandler;
/**
 增加标题
 */
- (void)addTitle:(NSString *)title forContents:(NSArray *)contents;
/**
 移除某个标题
 */
- (void)removeTitle:(NSString *)title;
/**
 移除所有的标题
 */
- (void)removeAllTitles;

@end
