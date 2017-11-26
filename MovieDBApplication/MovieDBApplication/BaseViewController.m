//
//  BaseViewController.m
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "BaseViewController.h"
#import "Constants.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIView *overLayView;

@property (nonatomic, strong) UIActivityIndicatorView *loader;

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *emptyViewText;
@property (nonatomic, strong) UIImageView *emptyViewImage;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createOverLayView];
    [self createLoader];
    [self createEmptyView];
}

- (void)createOverLayView {
    self.overLayView = [[UIView alloc] initWithFrame:CGRectMake(0, [Constants navigationBarHeight], W(self.view), H(self.view) - [Constants navigationBarHeight])];
    [self.overLayView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.overLayView];
}
- (void)createLoader {
    self.loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.overLayView addSubview:self.loader];
    [self.loader setCenter:self.overLayView.center];
    [self.loader setHidesWhenStopped:YES];
}

- (void)createEmptyView {
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W(self.view), 0)];
    
    self.emptyViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.emptyViewImage setImage:[UIImage imageNamed:@"Error"]];
    [self.emptyViewImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.emptyViewImage setCenter:CGPointMake(self.emptyView.center.x, self.emptyViewImage.center.y)];
    [self.emptyView addSubview:self.emptyViewImage];
    
    self.emptyViewText = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.emptyViewImage) + SIDE_PADDING, W(self.emptyView) - 2*SIDE_PADDING, 25)];
    [self.emptyViewText setText:@"Something Went Wrong !"];
    [self.emptyViewText setNumberOfLines:0];
    [self.emptyViewText setFont:[UIFont systemFontOfSize:18]];
    [self.emptyViewText setTextAlignment:NSTextAlignmentCenter];
    [self.emptyView addSubview:self.emptyViewText];
    
    [self.overLayView addSubview:self.emptyView];
    
    [self.emptyView setFrame:CGRectMake(0, 0, W(self.view), (BOTTOM(self.emptyViewText) + SIDE_PADDING))];
    [self.emptyView setCenter:CGPointMake(self.emptyView.center.x, self.overLayView.center.y)];
}

- (void)showLoader {
    [self.view bringSubviewToFront:self.overLayView];
    [self.emptyView setHidden:YES];
    [self.loader setHidden:NO];
    [self.overLayView setHidden:NO];
    [self.loader startAnimating];
}

- (void)showEmptyView {
    [self.view bringSubviewToFront:self.overLayView];
    [self.overLayView setHidden:NO];
    [self.emptyView setHidden:NO];
    [self.loader setHidden:YES];
}

- (void)hideEmptyViewAndLoader {
    [self.view sendSubviewToBack:self.overLayView];
    [self.overLayView setHidden:YES];
    [self.emptyView setHidden:YES];
    [self.loader setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
