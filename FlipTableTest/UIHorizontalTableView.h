//
//  UIHorizontalTableView.h
//
//  Created by Alterplay on 11/23/11.
//  Copyright (c) 2011 Alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIHorizontalTableView;

@interface UIHorizontalTableViewCell : UITableViewCell {
    UITableViewCell *contentCell;
}

@property (nonatomic, strong) UITableViewCell *contentCell;

@end

@protocol UIHorizontalTableViewDataSource<NSObject>

- (NSUInteger)numberOfCellsForHorizontalTableView:(UIHorizontalTableView *)horTableView;
- (UITableViewCell *)horizontalTableView:(UIHorizontalTableView *)horTableView cellForIdentifier:(NSString *)cellIdentifier;
- (void)horizontalTableView:(UIHorizontalTableView *)horTableView setDataForCell:(UITableViewCell *)cell forIndex:(NSUInteger)index;

@end

@protocol UIHorizontalTableViewDelegate <NSObject, UIScrollViewDelegate>
@optional
//should retung NSNotFound if selection don't wanted, otherwise return index of cell that should be selected
- (NSUInteger)horizontalTableView:(UIHorizontalTableView *)horTableView willSelectCellAtIndex:(NSUInteger)index; 
- (void)horizontalTableView:(UIHorizontalTableView *)horTableView didSelectCellAtIndex:(NSInteger)index;

//should retung NSNotFound if deselection don't wanted, otherwise return index of cell that should be deselected
- (NSUInteger)horizontalTableView:(UIHorizontalTableView *)horTableView willDeselectCellAtIndex:(NSUInteger)index; 
- (void)horizontalTableView:(UIHorizontalTableView *)horTableView didDeselectCellAtIndex:(NSInteger)index;
@end


@interface UIHorizontalTableView : UIScrollView <UITableViewDelegate, UITableViewDataSource> {
}

@property (nonatomic, unsafe_unretained) IBOutlet id<UIHorizontalTableViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) IBOutlet id<UIHorizontalTableViewDelegate> delegate;
@property (nonatomic, assign) NSString *reuseIdentifier;
@property (nonatomic, assign) CGFloat cellWidth;
@property (weak, nonatomic, readonly) UITableView *tableView;

- (UITableViewCell *)visibleCellAtIndex:(NSUInteger)index;
- (void)selectCellAtIndex:(NSUInteger)index animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

@end
