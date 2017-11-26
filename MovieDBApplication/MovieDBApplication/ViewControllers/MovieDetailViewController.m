//
//  MovieDetailViewController.m
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "GetMovieDetail.h"
#import "Constants.h"
#import "UIImageView+Download.h"

@interface MovieDetailViewController () <GetMovieDetailDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tagLabel;

@property (nonatomic, strong) UILabel *synopsisTitleLabel;
@property (nonatomic, strong) UILabel *synopsisLabel;

@property (nonatomic, strong) UILabel *releaseDateTitle;
@property (nonatomic, strong) UILabel *releaseDate;

@property (nonatomic, strong) UILabel *ratingTitle;
@property (nonatomic, strong) UILabel *rating;

@property (nonatomic, strong) GetMovieDetail *getMovieDetailObject;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createHeaderView];
    
    [self getMovieDetails];
}

- (void)createHeaderView {
    [self.navigationItem setTitle:@"Movie Details"];
}

- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [Constants navigationBarHeight], W(self.view) , H(self.view) - [Constants navigationBarHeight])];
    [self.view addSubview:self.scrollView];
    
    [self createImageView];
    [self createTitleLabel];
    [self createTagLabel];
    [self createSynopsis];
    [self createSynopsisLabel];
    [self createRatingTitleLabel];
    [self createRatingLabel];
    [self createReleaseDateTitleLabel];
    [self createReleaseDateLabel];
    
    [self.scrollView setContentSize:CGSizeMake(W(self.view), BOTTOM(self.releaseDate) + 2*SIDE_PADDING)];
}

- (void)createImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W(self.scrollView), 210)];
    [self.imageView setBackgroundColor:[UIColor grayColor]];
    [self.imageView setImageWithUrl:[NSURL URLWithString:self.getMovieDetailObject.movie.imageUrl]];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.scrollView addSubview:self.imageView];
    
//    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
//    gradient.frame = self.imageView.frame;
//    gradient.colors = @[(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor]];
//    gradient.locations = @[@0.5, @1.0];
//    [self.imageView.layer insertSublayer:gradient atIndex:0];
}

- (void)createTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.imageView) + SIDE_PADDING, W(self.scrollView) - 2*SIDE_PADDING, 0)];
    [self.titleLabel setText:self.getMovieDetailObject.movie.name];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
    [self.titleLabel setTextColor:[UIColor darkTextColor]];
    [self.titleLabel setNumberOfLines:0];
    [self.titleLabel sizeToFit];
    [self.scrollView addSubview:self.titleLabel];
}

- (void)createTagLabel {
    self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.titleLabel), W(self.scrollView) - 2*SIDE_PADDING, 0)];
    [self.tagLabel setText:self.getMovieDetailObject.movie.tagline];
    [self.tagLabel setFont:[UIFont italicSystemFontOfSize:16]];
    [self.tagLabel setNumberOfLines:0];
    [self.tagLabel sizeToFit];
    [self.scrollView addSubview:self.tagLabel];
}

- (void)createSynopsis {
    self.synopsisTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.tagLabel) + SIDE_PADDING, W(self.scrollView) - 2*SIDE_PADDING, 0)];
    [self.synopsisTitleLabel setText:@"SYNOPSIS"];
    [self.synopsisTitleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.synopsisTitleLabel sizeToFit];
    [self.scrollView addSubview:self.synopsisTitleLabel];
}

- (void)createSynopsisLabel {
    self.synopsisLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.synopsisTitleLabel) + SIDE_PADDING, W(self.scrollView) - 2*SIDE_PADDING, 0)];
    [self.synopsisLabel setText:self.getMovieDetailObject.movie.synopsis];
    [self.synopsisLabel setFont:[UIFont systemFontOfSize:16]];
    [self.synopsisLabel setNumberOfLines:0];
    [self.synopsisLabel sizeToFit];
    [self.scrollView addSubview:self.synopsisLabel];
}

- (void)createRatingTitleLabel {
    self.ratingTitle = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.synopsisLabel) + SIDE_PADDING, W(self.scrollView) - 2*SIDE_PADDING, 0)];
    [self.ratingTitle setText:@"Average Rating"];
    [self.ratingTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [self.ratingTitle sizeToFit];
    [self.scrollView addSubview:self.ratingTitle];
}

- (void)createRatingLabel {
    self.rating = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.ratingTitle) + SIDE_PADDING, W(self.scrollView) - 2*SIDE_PADDING, 0)];
    [self.rating setText:[NSString stringWithFormat:@"%.2f", self.getMovieDetailObject.movie.userRating.floatValue]];
    [self.rating setFont:[UIFont systemFontOfSize:16]];
    [self.rating setNumberOfLines:0];
    [self.rating sizeToFit];
    [self.scrollView addSubview:self.rating];
}

- (void)createReleaseDateTitleLabel {
    self.releaseDateTitle = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.rating) + SIDE_PADDING, W(self.scrollView) - 2*SIDE_PADDING, 0)];
    [self.releaseDateTitle setText:@"Release Date"];
    [self.releaseDateTitle setFont:[UIFont boldSystemFontOfSize:18]];
    [self.releaseDateTitle sizeToFit];
    [self.scrollView addSubview:self.releaseDateTitle];
}

- (void)createReleaseDateLabel {
    self.releaseDate = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PADDING, BOTTOM(self.releaseDateTitle) + SIDE_PADDING, W(self.scrollView) - 2*SIDE_PADDING, 0)];
    [self.releaseDate setText:self.getMovieDetailObject.movie.releaseDate];
    [self.releaseDate setFont:[UIFont systemFontOfSize:16]];
    [self.releaseDate setNumberOfLines:0];
    [self.releaseDate sizeToFit];
    [self.scrollView addSubview:self.releaseDate];
}

- (void)getMovieDetails {
    [self showLoader];
    
    self.getMovieDetailObject = [[GetMovieDetail alloc] init];
    [self.getMovieDetailObject setDelegate:self];
    [self.getMovieDetailObject getMovieForMovieId:@(501)];
}

#pragma mark GetMovieDelegate
- (void)movieFetchedSuccessfully {
    [self hideEmptyViewAndLoader];
    
    [self createScrollView];
}

- (void)movieFetchingFailedWithError:(NSError *)error {
    [self hideEmptyViewAndLoader];
    
    [self showEmptyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
