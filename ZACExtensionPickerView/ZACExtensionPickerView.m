//
//  ZACExtensionPickerView.m
//  Test
//
//  Created by Kingo on 2018/8/8.
//  Copyright © 2018年 Kingo. All rights reserved.
//

#import "ZACExtensionPickerView.h"

@interface ZACExtensionPickerView()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
    __weak UIView *_superView;
    CGFloat _titleHeight;
    CGFloat _topConstraint;
    
    BOOL _open;
    NSInteger _extensionSection;
}

/** 底部MaskView */
@property (nonatomic , strong) UIView *maskView;
/** 头部选项卡 */
@property (nonatomic , strong) UICollectionView *titleCollectionView;
/** 展开部分 */
@property (nonatomic , strong) UITableView *contentTableView;

@end

@implementation ZACExtensionPickerView

- (instancetype)initWithSuperView:(UIView *__weak)superView
                      titleHeight:(CGFloat)titleHeight
                    topConstraint:(CGFloat)topConstraint  {
    
    _superView = superView;
    _topConstraint = topConstraint;
    _titleHeight = titleHeight;
    
    if (self = [super initWithFrame:CGRectMake(0, topConstraint, kSCREEN_WIDTH, titleHeight)]) {
        
        [self extensionDataInit];
        
        [self extensionViewInit];
        
    }
    return self;
}

- (void)extensionViewInit {
    self.backgroundColor = [UIColor clearColor];
    [_superView addSubview:self];
    
    CGRect rect = self.bounds;
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, _titleHeight)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeExtension)];
    _maskView.userInteractionEnabled = YES;
    [_maskView addGestureRecognizer:tap];
    _maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    [self addSubview:_maskView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, _titleHeight) collectionViewLayout:layout];
    _titleCollectionView.dataSource = self;
    _titleCollectionView.delegate = self;
    [self addSubview:_titleCollectionView];
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _titleHeight, kSCREEN_WIDTH, 0) style:UITableViewStylePlain];
    _contentTableView.dataSource = self;
    _contentTableView.delegate = self;
    _contentTableView.tableFooterView = [UIView new];
    _contentTableView.bounces = NO;
    _contentTableView.showsVerticalScrollIndicator = NO;
    [self addSubview:_contentTableView];
    
}

- (void)setTitleBgColor:(UIColor *)titleBgColor {
    _titleBgColor = titleBgColor;
    _titleCollectionView.backgroundColor = titleBgColor;
}

- (void)setMaskType:(ZACExtensionPickerMaskType)maskType {
    _maskType = maskType;
    switch (maskType) {
        case ZACExtensionPickerMaskTypeAll:
            self.maskView.hidden = NO;
            break;
        case ZACExtensionPickerMaskTypeNone:
            self.maskView.hidden = YES;
        default:
            break;
    }
}

- (void)extensionDataInit {
    
    _maskType = ZACExtensionPickerMaskTypeAll;
    
    _open = NO;         // 默认关闭
    _extensionSection = NSNotFound;
}

- (void)closeExtension {
    _open = NO;
    [self changeExtensionStatus];
}

- (void)changeExtensionStatus {
    __weak typeof(self) weakSelf = self;
    
    if(!_open) {    // 收起
        NSInteger section = _extensionSection;
        CGFloat titleHeight = _titleHeight;
        CGFloat topConstraint = _topConstraint;
        if ([self.delegate respondsToSelector:@selector(extensionPickerView:willChangeHeight:)]) {
            [self.delegate extensionPickerView:self willChangeHeight:titleHeight];
        }
        if ([self.delegate respondsToSelector:@selector(extensionPickerView:willCloseSection:)]) {
            [self.delegate extensionPickerView:self willCloseSection:section];
        }
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = CGRectMake(0, _titleHeight, kSCREEN_WIDTH, 0);
            weakSelf.contentTableView.frame = rect;
        } completion:^(BOOL finished) {
            weakSelf.frame = CGRectMake(0, topConstraint, kSCREEN_WIDTH, titleHeight);
            weakSelf.maskView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, titleHeight);
            if ([weakSelf.delegate respondsToSelector:@selector(extensionPickerView:didChangeHeight:)]) {
                [weakSelf.delegate extensionPickerView:weakSelf didChangeHeight:titleHeight];
            }
            if ([weakSelf.delegate respondsToSelector:@selector(extensionPickerView:didCloseSection:)]) {
                [weakSelf.delegate extensionPickerView:weakSelf didCloseSection:section];
            }
        }];
        _extensionSection = NSNotFound;
        
    }else {     // 展开
        NSInteger section = _extensionSection;
        CGFloat titleHeight = _titleHeight;
        NSInteger contentNum = 0;
        if ([self.dataSource respondsToSelector:@selector(extensionPickerView:numberOfContentOfSection:)] &&
            _extensionSection != NSNotFound) {
            contentNum = [self.dataSource extensionPickerView:self numberOfContentOfSection:_extensionSection];
            if (contentNum > 5) {
                contentNum = 5;
            }
        }
        if ([self.delegate respondsToSelector:@selector(extensionPickerView:willExtensionSection:)]) {
            [self.delegate extensionPickerView:self willExtensionSection:section];
        }
        CGFloat height = kSCREEN_HEIGHT-_topConstraint;
        CGFloat tableViewHeight = 44*contentNum;
        if ([self.delegate respondsToSelector:@selector(extensionPickerView:willChangeHeight:)]) {
            [self.delegate extensionPickerView:self willChangeHeight:(tableViewHeight+titleHeight)];
        }
        /// TODO: 根据type定Mask的frame
        self.frame = CGRectMake(0, _topConstraint, kSCREEN_WIDTH, height);
        self.maskView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, height);
        [UIView animateWithDuration:0.15 animations:^{
            CGRect rect = CGRectMake(0, _titleHeight, kSCREEN_WIDTH, tableViewHeight);
            weakSelf.contentTableView.frame = rect;
        }completion:^(BOOL finished) {
            if ([weakSelf.delegate respondsToSelector:@selector(extensionPickerView:didChangeHeight:)]) {
                [weakSelf.delegate extensionPickerView:weakSelf didChangeHeight:(tableViewHeight+titleHeight)];
            }
            if ([weakSelf.delegate respondsToSelector:@selector(extensionPickerView:didExtensionSection:)]) {
                [weakSelf.delegate extensionPickerView:self didExtensionSection:section];
            }
        }];
    }
    
    [self reloadData];
    
}

- (void)reloadData {
    [self.titleCollectionView reloadData];
    [self.contentTableView reloadData];
}

#pragma mark -
- (void)registerNib:(UINib *)nib forTitleCellReuseIdentifier:(NSString *)reuseIdentifier {
    [_titleCollectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)registerClass:(nullable Class)class forTitleCellReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([class isEqual:[ZACExtensionTitleCell class]]) {
        NSString *nibName = NSStringFromClass([ZACExtensionTitleCell class]);
        [_titleCollectionView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        return;
    }
    [_titleCollectionView registerClass:class forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)registerNib:(UINib *)nib forContentCellReuseIdentifier:(NSString *)reuseIdentifier {
    [_contentTableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
}

- (void)registerClass:(nullable Class)class forContentCellReuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([class isEqual:[ZACExtesionContentCell class]]) {
        NSString *nibName = NSStringFromClass([ZACExtesionContentCell class]);
        [_contentTableView registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
        return;
    }
    [_contentTableView registerClass:class forCellReuseIdentifier:reuseIdentifier];
    
}

- (ZACExtensionTitleCell *)dequeueReusableTitleCellWithIdentifier:(NSString *)reuseIdentifier forSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:section inSection:0];
    return [_titleCollectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
}

- (ZACExtesionContentCell *)dequeueReusableContentCellWithIdentifier:(NSString *)reuseIdentifier {
    return [_contentTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger sectionNumber = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionInExtensionPicker:)]) {
        sectionNumber = [self.dataSource numberOfSectionInExtensionPicker:self];
    }
    return sectionNumber;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZACExtensionTitleCell *cell = nil;
    
    if ([self.dataSource respondsToSelector:@selector(extensionPickerView:titleOfSection:)]) {
        cell = [self.dataSource extensionPickerView:self titleOfSection:indexPath.item];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionInExtensionPicker:)]) {
        NSInteger sectionNumber = [self.dataSource numberOfSectionInExtensionPicker:self];
        size = CGSizeMake(kSCREEN_WIDTH/((CGFloat)sectionNumber), _titleHeight);
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(_extensionSection == indexPath.item) {
        _open = NO;
        _extensionSection = NSNotFound;
    }else {
        _open = YES;
        _extensionSection = indexPath.item;
    }
    [self changeExtensionStatus];
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger contentNum = 0;
    if ([self.dataSource respondsToSelector:@selector(extensionPickerView:numberOfContentOfSection:)] &&
        _extensionSection != NSNotFound) {
        contentNum = [self.dataSource extensionPickerView:self numberOfContentOfSection:_extensionSection];
    }
    return contentNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZACExtesionContentCell *cell = nil;
    NSIndexPath *extensionIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_extensionSection];
    
    if ([self.dataSource respondsToSelector:@selector(extensionPickerView:cellOfIndexPath:)]) {
        cell = [self.dataSource extensionPickerView:self cellOfIndexPath:extensionIndexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_extensionSection];
        
    if ([self.delegate respondsToSelector:@selector(extensionPickerView:didSelectRowAtIndexPath:)]) {
        [self.delegate extensionPickerView:self didSelectRowAtIndexPath:selectedIndexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_extensionSection];
    
    if ([self.delegate respondsToSelector:@selector(extensionPickerView:didDeSelectRowAtIndexPath:)]) {
        [self.delegate extensionPickerView:self didDeSelectRowAtIndexPath:selectedIndexPath];
    }
}

- (void)dealloc {
    NSLog(@"dealloc --> ZACExtensionPickerView");
}


@end
