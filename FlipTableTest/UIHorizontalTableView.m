//
//  UIHorizontalTableView.m
//
//  Created by Alterplay on 11/23/11.
//  Copyright (c) 2011 Alterplay. All rights reserved.
//

#import "UIHorizontalTableView.h"

#define TABLEVIEW_TAG 800

@implementation UIHorizontalTableViewCell

@synthesize contentCell;

- (void)prepareRotatedView:(UIView *)rotatedView withContentView:(UIView *)content
{
    if (content == nil)
		content = [[UIView alloc] initWithFrame:rotatedView.bounds];
    
	content.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[rotatedView addSubview:content];
}

- (void)setContentCell:(UITableViewCell *)_contentCell
{
    [contentCell removeFromSuperview];
    contentCell = _contentCell;
    
    UIView *rotatedView				= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width)];
    rotatedView.center				= self.contentView.center;
    rotatedView.backgroundColor		= [UIColor clearColor];//self.cellBackgroundColor;
    rotatedView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    BOOL shouldBeUserInteractionEnabled = NO;
    
    rotatedView.userInteractionEnabled = shouldBeUserInteractionEnabled;
    rotatedView.transform = CGAffineTransformMakeRotation(M_PI/2);

    // We want to make sure any expanded content is not visible when the cell is deselected
    rotatedView.clipsToBounds = YES;
    
    // Prepare and add the custom subviews
    [self prepareRotatedView:rotatedView withContentView:contentCell];
    
    [self.contentView addSubview:rotatedView];
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [contentCell setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [contentCell setSelected:selected animated:animated];
}

@end

@interface UIHorizontalTableView (PrivateMethods)
- (void)createHorizontalTableView;
@end


@implementation UIHorizontalTableView

@synthesize dataSource;
@synthesize delegate;

@synthesize reuseIdentifier;
@synthesize cellWidth;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        cellWidth = 108.0f;
        self.reuseIdentifier = @"HorTableViewCell";
        [self createHorizontalTableView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

		cellWidth	= 108.0f;
        self.reuseIdentifier = @"HorTableViewCell";
		[self createHorizontalTableView];
	}
    return self;
}

- (void)createHorizontalTableView {
	
	UITableView *tableView;

    int xOrigin	= (self.bounds.size.width - self.bounds.size.height)/2;
	int yOrigin	= (self.bounds.size.height - self.bounds.size.width)/2;
    tableView	= [[UITableView alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, self.bounds.size.height, self.bounds.size.width)];	
    
	tableView.tag				= TABLEVIEW_TAG;
	tableView.delegate			= self;
	tableView.dataSource		= self;
	tableView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	// Rotate the tableView 90 degrees so that it is horizontal
    tableView.transform	= CGAffineTransformMakeRotation(-M_PI/2);
	tableView.showsVerticalScrollIndicator = NO;    
    tableView.rowHeight = cellWidth;
    [self addSubview:tableView];
}

#pragma mark - Properties

- (UITableView *)tableView {
    return (UITableView *)[self viewWithTag:TABLEVIEW_TAG];
}

- (UITableViewCell *)visibleCellAtIndex:(NSUInteger)index {	
    UIHorizontalTableViewCell *horCell = (UIHorizontalTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
	return horCell.contentCell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([delegate respondsToSelector:@selector(horizontalTableView:didSelectCellAtIndex:)])
        [delegate horizontalTableView:self didSelectCellAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([delegate respondsToSelector:@selector(horizontalTableView:didDeselectCellAtIndex:)])
        [delegate horizontalTableView:self didDeselectCellAtIndex:indexPath.row];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([delegate respondsToSelector:@selector(horizontalTableView:willSelectCellAtIndex:)]) {
        NSUInteger row = [delegate horizontalTableView:self willSelectCellAtIndex:indexPath.row];
        if (row == NSNotFound) return nil;
        return [NSIndexPath indexPathForRow:row inSection:0];
    }
	return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([delegate respondsToSelector:@selector(horizontalTableView:willDeselectCellAtIndex:)]) {
        NSUInteger row = [delegate horizontalTableView:self willDeselectCellAtIndex:indexPath.row];
        if (row == NSNotFound) return nil;
        return [NSIndexPath indexPathForRow:row inSection:0];
    }
	return indexPath;
}

#pragma mark - TableViewDataSource

- (void)setCellWidth:(CGFloat)_cellWidth {
    self.tableView.rowHeight = _cellWidth;
    cellWidth = _cellWidth;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSUInteger numOfItems = [dataSource numberOfCellsForHorizontalTableView:self];
    return numOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIHorizontalTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        BOOL viewAnimation = [UIView areAnimationsEnabled];
        if (viewAnimation == YES) [UIView setAnimationsEnabled:NO];
        
        cell = [[UIHorizontalTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.bounds = CGRectMake(0, 0, self.bounds.size.height, cellWidth);
        cell.contentView.frame = cell.bounds;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITableViewCell *contentCell = [dataSource horizontalTableView:self cellForIdentifier:reuseIdentifier];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentCell = contentCell;

        if (viewAnimation == YES) [UIView setAnimationsEnabled:YES];
	}

    [dataSource horizontalTableView:self setDataForCell:cell.contentCell forIndex:indexPath.row];
    
    return cell;
}

- (void)selectCellAtIndex:(NSUInteger)index animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    UITableView *tableView = [self tableView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    CGFloat animationSpeed = animated ? 0.20f : 0.0f;
    [UIView animateWithDuration: animationSpeed
                     animations:^{ 
                         [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:scrollPosition];
                     }];

}

@end
