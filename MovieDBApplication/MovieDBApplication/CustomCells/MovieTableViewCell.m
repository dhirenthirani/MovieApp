//
//  MovieTableViewCell.m
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "Constants.h"
#import "UIImageView+Download.h"

CGFloat const padding = 10;
CGFloat const betweenPadding = 8;
CGFloat const imageSize = 100;

@interface MovieTableViewCell()

@property (nonatomic, strong) UIImageView *movieImageView;
@property (nonatomic, strong) UILabel *movieName;

@property (nonatomic, strong) UIView *containerView;

@end

@implementation MovieTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        
        
        [self createViews];
    }
    return self;
}

- (void)createViews {
    [self createContainerView];
    [self createImageView];
    [self createMovieNameLabel];
}

- (void)createContainerView {
    self.containerView = [[UIView alloc] init];
    [self.containerView setBackgroundColor:[UIColor whiteColor]];
    [self.containerView.layer setShadowOpacity:1.0f];
    [self.containerView.layer setShadowRadius:1.0f];
    [self.containerView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [self.containerView.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.containerView.layer setMasksToBounds:YES];
    [self.containerView setClipsToBounds:YES];
    [self.contentView addSubview:self.containerView];
}

- (void)createImageView {
    self.movieImageView = [[UIImageView alloc] init];
    [self.movieImageView setBackgroundColor:[UIColor grayColor]];
    [self.movieImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.containerView addSubview:self.movieImageView];
}

- (void)createMovieNameLabel {
    self.movieName = [[UILabel alloc] init];
    [self.movieName setFont:[UIFont systemFontOfSize:20]];
    [self.movieName setTextColor:[UIColor darkTextColor]];
    [self.movieName setNumberOfLines:0];
    [self.movieName sizeToFit];
    [self.containerView addSubview:self.movieName];
}

- (void)setData:(Movie *)movie {
    [self.movieImageView setImageWithUrl:[NSURL URLWithString:movie.imageUrl]];
    [self.movieName setText:movie.name];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containerView setFrame:CGRectMake(padding, padding, W(self.contentView) - 2*padding, H(self.contentView) - 2*padding)];
    [self.movieImageView setFrame:CGRectMake(0, 0, W(self.containerView), imageSize)];
    
    CGSize labelSize = [self.movieName.text boundingRectWithSize:CGSizeMake((W(self.containerView) - 2*betweenPadding), CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    
    [self.movieName setFrame:CGRectMake(betweenPadding, BOTTOM(self.movieImageView) + betweenPadding, W(self.containerView) - 2*betweenPadding, labelSize.height)];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.movieImageView setImage:nil];
    [self.movieName setText:nil];
}

+ (CGFloat)getHeightForMovie:(Movie *)movie {
    CGFloat height = 0.0f;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - 2*padding - 2*betweenPadding;
    
    height += 2*padding;
    height += imageSize;
    
    CGSize labelSize = [movie.name boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
    height += (labelSize.height + 2*betweenPadding);
    
    return height;
}

@end
