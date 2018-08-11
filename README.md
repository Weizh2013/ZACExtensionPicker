# ZACExtensionPicker
可收放选择器


[GitHub: https://github.com/Weizh2013/ZACExtensionPicker](https://github.com/Weizh2013/ZACExtensionPicker)


## 可设置属性
### ZACExtensionPicker 说明
ZACExtensionPicker的配置与UITableView类似，顶部每个标签相当于一个Section，下面展开的选择视图相当于每个Row，所以对它的配置大家也就很熟悉了。
#### 1、宏定义
```ruby
// 屏幕宽高
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
```
#### 2、数据代理方法
```ruby
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
```
#### 3、事件回调代理方法
```ruby
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
```
#### 4、属性及方法
```ruby
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
 * @param titleHeight 标题栏高度
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
 根据重用标识符获取相应的Cell
 */
- (ZACExtensionTitleCell *)dequeueReusableTitleCellWithIdentifier:(NSString *)reuseIdentifier forSection:(NSInteger)section;
- (ZACExtesionContentCell *)dequeueReusableContentCellWithIdentifier:(NSString *)reuseIdentifier;
```

### ZACExtensionSimplePickerView 说明
针对比较简单使用的ZACExtensionPickerView,我做了一个封装，先说明下其头文件，再给个示例代码
#### 1、 属性和方法
```ruby
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
```
#### 2、使用方法
```ruby
ZACExtensionSimplePickerView *picker = [ZACExtensionSimplePickerView extensionViewWithSuperView:self.view topConstrant:64.0f completeHandler:^(NSIndexPath *indexPath) {
        // 每次选中后，会调用该block
        NSLog(@"选中了:(%ld,%ld)",indexPath.section,indexPath.row);
        
    }];
    
[picker addTitle:@"城市" forContents:@[@"不限",@"北京",@"上海",@"广州"]];
[picker addTitle:@"行业" forContents:@[@"不限",@"计算机IT",@"金融",@"销售"]];
[picker addTitle:@"职位" forContents:@[@"不限",@"iOS工程师",@"安卓工程师",@"web前端"]];
[picker addTitle:@"排序" forContents:@[@"默认排序",@"按薪资由高到低",@"距离我远近"]];
...此处可以继续加，建议最多加四个，多了可能会影响视图效果
```
#### 3、效果图如下
![起始图片](https://github.com/Weizh2013/ZACExtensionPicker/blob/master/pages/start.PNG)
![展开效果](https://github.com/Weizh2013/ZACExtensionPicker/blob/master/pages/extension.PNG)
![选中效果](https://github.com/Weizh2013/ZACExtensionPicker/blob/master/pages/selected.PNG)
![选中展开效果](https://github.com/Weizh2013/ZACExtensionPicker/blob/master/pages/selected_extension.PNG)


#### github下载地址：[https://github.com/Weizh2013/ZACExtensionPicker](https://github.com/Weizh2013/ZACExtensionPicker)

如果觉得对你还有些用，顺手点一下star吧 (｡♥‿♥｡)   你的支持是我继续的动力。<br>
