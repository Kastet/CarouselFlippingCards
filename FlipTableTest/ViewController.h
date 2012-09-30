//
//  ViewController.h
//  FlipTableTest
//
//  Created by Kostia Kim on 7/27/12.
//  Copyright (c) 2012 Alterplay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHorizontalTableView.h"

@interface ViewController : UIViewController <UIHorizontalTableViewDataSource, UIHorizontalTableViewDelegate> {
    
    UIHorizontalTableView *carousel;
    
    NSInteger _lastSelectedIndex;
    BOOL moveRight;
}

@end
