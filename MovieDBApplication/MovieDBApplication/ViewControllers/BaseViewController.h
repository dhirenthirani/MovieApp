//
//  BaseViewController.h
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showLoader;
- (void)showEmptyView;
- (void)hideEmptyViewAndLoader;

@end
