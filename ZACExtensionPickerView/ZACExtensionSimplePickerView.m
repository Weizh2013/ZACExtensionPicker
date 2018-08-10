//
//  ZACExtensionSimplePickerView.m
//  Test
//
//  Created by Kingo on 2018/8/9.
//  Copyright © 2018年 Kingo. All rights reserved.
//

#import "ZACExtensionSimplePickerView.h"
#define DEFAULTHEIGHT 40.0f

NSString *const titleCellIndetifier = @"ZACExtensionTitleCell";
NSString *const contentCellIndetifier = @"ZACExtesionContentCell";

typedef void (^COMPLETEHANDLERTYPE)(NSIndexPath *);

@interface ZACExtensionSimplePickerView()<ZACExtensionPickerViewDataSource, ZACExtensionPickerViewDelegate>
{
    
    NSInteger _currentSection;
    COMPLETEHANDLERTYPE _completeHandler;
    
    NSMutableArray *_titles;
    NSMutableDictionary *_pickerDic;
}
@end

@implementation ZACExtensionSimplePickerView

+ (instancetype)extensionViewWithSuperView:(UIView *__weak)superView
                              topConstrant:(CGFloat)topConstraint
                           completeHandler:(void (^)(NSIndexPath *))completeHandler {
    
    ZACExtensionSimplePickerView *picker = [[ZACExtensionSimplePickerView alloc]initWithSuperView:superView titleHeight:DEFAULTHEIGHT topConstraint:topConstraint];
    
    [picker setDefaultValueWith:completeHandler];
    
    [picker simpleExtensionViewInit];
    
    return picker;
}

- (void)setDefaultValueWith:(COMPLETEHANDLERTYPE)completeHandler {
    
    _completeHandler = completeHandler;
    
    self.titleBgColor = kUIColorFromRGB(0xf1f1f1);
    
    _normalImage = [UIImage imageNamed:@"down_black"];
    _normalFont = [UIFont systemFontOfSize:14.0f];
    _normalColor = kUIColorFromRGB(0x333333);
    
    _extensionImage = [UIImage imageNamed:@"up_blue"];
    _extensionFont = [UIFont systemFontOfSize:14.0f];
    _extensionColor = kUIColorFromRGB(0x428ee5);
    
    _selectedImage = [UIImage imageNamed:@"down_blue"];
    _selectedFont = [UIFont systemFontOfSize:14.0f];
    _selectedColor = kUIColorFromRGB(0x428ee5);
    
    _currentSection = NSNotFound;
    
    _selectedIndexPaths = @[];
    
}

- (void)simpleExtensionViewInit {
        
    [self registerClass:[ZACExtensionTitleCell class] forTitleCellReuseIdentifier:titleCellIndetifier];
    [self registerClass:[ZACExtesionContentCell class] forContentCellReuseIdentifier:contentCellIndetifier];
    
    self.dataSource = self;
    self.delegate = self;
    
}

#pragma mark -
/** Title Numbers */
- (NSInteger)numberOfSectionInExtensionPicker:(ZACExtensionPickerView *)extensionPickerView {
    return _titles.count;
}
/** Title Of Section */
- (ZACExtensionTitleCell *)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView titleOfSection:(NSInteger)section {
    NSString *title = _titles[section];
    
    ZACExtensionTitleCell *cell = [extensionPickerView dequeueReusableTitleCellWithIdentifier:titleCellIndetifier forSection:section];
    cell.titleLabel.text = title;
    // 默认的
    cell.titleLabel.font = _normalFont;
    cell.titleLabel.textColor = _normalColor;
    cell.arrowImageView.image = _normalImage;
    if (_currentSection == section) {       // 展开的
        cell.titleLabel.font = _extensionFont;
        cell.titleLabel.textColor = _extensionColor;
        cell.arrowImageView.image = _extensionImage;
    }
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {   // 选中的
        if (indexPath.section == section && indexPath.row != 0) {
            NSArray *contents = [_pickerDic objectForKey:_titles[section]];
            cell.titleLabel.text = contents[indexPath.row];
            cell.titleLabel.font = _selectedFont;
            cell.titleLabel.textColor = _selectedColor;
            if (_currentSection != section) {
                cell.arrowImageView.image = _selectedImage;
            }
            break;
        }
    }
    return cell;
}
/** Content Numbers */
- (NSInteger)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView numberOfContentOfSection:(NSInteger)section {
    NSArray *contents = [_pickerDic objectForKey:_titles[section]];
    return contents.count;
}
/** Content Of Row */
- (ZACExtesionContentCell *)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView cellOfIndexPath:(NSIndexPath *)indexPath {
    NSArray *contents = [_pickerDic objectForKey:_titles[indexPath.section]];
    NSString *content = contents[indexPath.row];
    ZACExtesionContentCell* cell = [extensionPickerView dequeueReusableContentCellWithIdentifier:contentCellIndetifier];
    cell.contentLabel.text = content;
    cell.selectImageView.hidden = YES;
    /// 选出当前indexPath是否被选中
    for (NSIndexPath *tmpIndexPath in self.selectedIndexPaths) {   // 选中的
        if (indexPath.section == tmpIndexPath.section
            && indexPath.row == tmpIndexPath.row) {
            cell.selectImageView.hidden = NO;
            break;
        }
    }
    return cell;
}

- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView willExtensionSection:(NSInteger)section {
    _currentSection = section;
    [self reloadData];
}

- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView didCloseSection:(NSInteger)section {
    _currentSection = NSNotFound;
    [self reloadData];
}

- (void)extensionPickerView:(ZACExtensionPickerView *)extensionPickerView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *mutIndexPaths = [NSMutableArray arrayWithArray:_selectedIndexPaths];
    for (int i=0; i<mutIndexPaths.count; i++) {
        NSIndexPath *tmpIndexPath = mutIndexPaths[i];
        if (tmpIndexPath.section == indexPath.section) {
            [mutIndexPaths removeObject:tmpIndexPath];
            break;
        }
    }
    [mutIndexPaths addObject:indexPath];
    _selectedIndexPaths = [NSArray arrayWithArray:mutIndexPaths];
    if (_completeHandler != nil) {
        _completeHandler(indexPath);
    }
    [self closeExtension];
}

#pragma mark -
- (void)addTitle:(NSString *)title forContents:(NSArray *)contents {
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    if (_pickerDic == nil) {
        _pickerDic = [NSMutableDictionary dictionary];
    }
    [_titles addObject:title];
    [_pickerDic setObject:contents forKey:title];
    NSMutableArray *mutIndexPaths = [NSMutableArray array];
    for (int i=0; i<_titles.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        [mutIndexPaths addObject:indexPath];
    }
    _selectedIndexPaths = [NSArray arrayWithArray:mutIndexPaths];
    [self reloadData];
}

- (void)removeTitle:(NSString *)title {
    if (![_titles containsObject:title]) {
        return;
    }
    [_titles removeObject:title];
    [_pickerDic removeObjectForKey:title];
}

- (void)removeAllTitles {
    _titles = [NSMutableArray array];
    _pickerDic = [NSMutableDictionary dictionary];
}

- (void)dealloc {
    NSLog(@"dealloc --> ZACExtensionSimplePickerView");
}

@end




















