//
//  ViewController.m
//  FlipTableTest
//
//  Created by Kostia Kim on 7/27/12.
//  Copyright (c) 2012 Alterplay. All rights reserved.
//

#import "ViewController.h"

static int view1tag = 99;
static int view2tag = 98;

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        _lastSelectedIndex = NSNotFound;
        moveRight = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    carousel = [[UIHorizontalTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:carousel];
    carousel.cellWidth = 600;
    carousel.dataSource  = self;
    carousel.delegate = self;
    carousel.tableView.scrollEnabled = NO;
    carousel.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSInteger initialIndex = 7;
    
    [carousel selectCellAtIndex:initialIndex animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [self moveToCellAtIndex:initialIndex animated:NO];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - UIHorizontalTable DataSource

- (NSUInteger)numberOfCellsForHorizontalTableView:(UIHorizontalTableView *)horTableView {
    return 10;
}

- (UITableViewCell *)horizontalTableView:(UIHorizontalTableView *)horTableView cellForIdentifier:(NSString *)cellIdentifier {
    static NSString *ident = @"identt";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *redView = [[UIView alloc]  initWithFrame:CGRectMake(0, 70, 600, 600)];
    redView.backgroundColor   = [UIColor redColor];
    [cell.contentView addSubview:redView];
    redView.tag = view1tag;
    redView.hidden = YES;
    UILabel *contantLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 600, 100)];
    contantLabel.textAlignment = UITextAlignmentCenter;
    contantLabel.backgroundColor = [UIColor clearColor];
    contantLabel.text = @"Content view";
    [redView addSubview:contantLabel];
    
    CGRect coverFrame;
    
    if (!moveRight) {
        coverFrame = CGRectMake(100, 300, 200, 200);
    } else {
        coverFrame = CGRectMake(300, 300, 200, 200);
    }
    
    UIView *yellowView = [[UIView alloc] initWithFrame:coverFrame];
    [yellowView setBackgroundColor:[UIColor yellowColor]];
    [cell.contentView addSubview:yellowView];
    yellowView.tag = view2tag;
    UILabel *coverLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 200, 50)];
    coverLabel.textAlignment = UITextAlignmentCenter;
    coverLabel.backgroundColor = [UIColor clearColor];
    coverLabel.text = @"Cover view";
    [yellowView addSubview:coverLabel];
    
    return cell;
}

- (void)horizontalTableView:(UIHorizontalTableView *)horTableView setDataForCell:(UITableViewCell *)cell forIndex:(NSUInteger)index {
    if (index == 0 || index == 10-1) {
        cell.contentView.hidden = YES;
    } else {
        cell.contentView.hidden = NO;
    }
}

- (void)moveToCellAtIndex:(NSInteger)index animated:(BOOL)animated {
    
    float duration = animated ? 0.5f : 0.0f;
    
    // ignore this cases
    if (index == 0 || index == 10-1 || index == _lastSelectedIndex) {
        return;
    }
        
    if (index > _lastSelectedIndex) {
        moveRight = NO;
    } else {
        moveRight = YES;
    }
    
    NSInteger newCellIndex = index;
    NSInteger oldCellIndex = NSNotFound;
    
    if (moveRight) {
        oldCellIndex = index + 1;
    } else {
        oldCellIndex = index - 1;
    }
    
    UIHorizontalTableViewCell *oldCell = (UIHorizontalTableViewCell *)[carousel visibleCellAtIndex:oldCellIndex];
    UIHorizontalTableViewCell *newCell = (UIHorizontalTableViewCell *)[carousel visibleCellAtIndex:newCellIndex];
    
    UIView *redView_old = [oldCell.contentView viewWithTag:view1tag];
    UIView *yellowView_old = [oldCell.contentView viewWithTag:view2tag];
    
    UIView *redView_new = [newCell.contentView viewWithTag:view1tag];
    UIView *yellowView_new = [newCell.contentView viewWithTag:view2tag];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionOverrideInheritedCurve
                     animations:^{
                         
                         // align previous cells
                         if (moveRight) {
                             yellowView_old.frame = CGRectMake(100, 300, 200, 200);
                         } else {
                             yellowView_old.frame = CGRectMake(300, 300, 200, 200);
                         }
                         
                         // move cells
                         [carousel selectCellAtIndex:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                         
                         // new
                         [UIView flipTransitionFromView:yellowView_new toView:redView_new flipLeftToRight:moveRight duration:duration completion:^(BOOL finished) {}];
                         
                         if ((moveRight == NO && redView_old.hidden == NO) || moveRight == YES) {
                             // old
                             [UIView flipTransitionFromView:redView_old toView:yellowView_old flipLeftToRight:moveRight duration:duration completion:^(BOOL finished) {}];                             
                         }
                         
     
                     } completion:^(BOOL finished) {
                         _lastSelectedIndex = newCellIndex; 
                     }];
}

#pragma mark - UIHorizontalTableView Delegate

- (NSUInteger)horizontalTableView:(UIHorizontalTableView *)horTableView willSelectCellAtIndex:(NSUInteger)index {
    [self moveToCellAtIndex:index animated:YES];
    return NSNotFound;
}

@end
