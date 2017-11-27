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
CGFloat const betweenPadding = 5;
CGFloat const imageSize = 100;

NSInteger const fontSize = 15;

@interface MovieTableViewCell()

@property (nonatomic, strong) UIImageView *movieImageView1;
@property (nonatomic, strong) UILabel *movieName1;

@property (nonatomic, strong) UIImageView *movieImageView2;
@property (nonatomic, strong) UILabel *movieName2;

@property (nonatomic, strong) UIView *containerView1;
@property (nonatomic, strong) UIView *containerView2;

@property (nonatomic, strong) Movie *movie1;
@property (nonatomic, strong) Movie *movie2;

@end

@implementation MovieTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        [self setExclusiveTouch:YES];
        
        [self createViews];
    }
    return self;
}

- (void)createViews {
    [self createContainerView];
    [self createImageView];
    [self createmovieName1Label];
}

- (void)createContainerView {
    self.containerView1 = [[UIView alloc] init];
    [self.containerView1 setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.containerView1];
    
    [self.containerView1.layer setShadowOpacity:1.0f];
    [self.containerView1.layer setShadowRadius:2.0f];
    [self.containerView1.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.containerView1.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.containerView1 setClipsToBounds:YES];
    [self.containerView1.layer setMasksToBounds:NO];
    [self.containerView1 setExclusiveTouch:YES];
    [self.containerView1 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContainer1)];
    [self.containerView1 addGestureRecognizer:gesture1];
    
    self.containerView2 = [[UIView alloc] init];
    [self.containerView2 setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.containerView2];
    
    [self.containerView2.layer setShadowOpacity:1.0f];
    [self.containerView2.layer setShadowRadius:2.0f];
    [self.containerView2.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.containerView2.layer setShadowOffset:CGSizeMake(2, 1)];
    [self.containerView2 setClipsToBounds:YES];
    [self.containerView2.layer setMasksToBounds:NO];
    [self.containerView2 setExclusiveTouch:YES];
    [self.containerView2 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapContainer2)];
    [self.containerView2 addGestureRecognizer:gesture2];
}

- (void)createImageView {
    self.movieImageView1 = [[UIImageView alloc] init];
    [self.movieImageView1 setBackgroundColor:[UIColor grayColor]];
    [self.movieImageView1 setContentMode:UIViewContentModeScaleAspectFill];
    [self.movieImageView1 setClipsToBounds:YES];
    [self.containerView1 addSubview:self.movieImageView1];
    
    self.movieImageView2 = [[UIImageView alloc] init];
    [self.movieImageView2 setBackgroundColor:[UIColor grayColor]];
    [self.movieImageView2 setContentMode:UIViewContentModeScaleAspectFill];
    [self.movieImageView2 setClipsToBounds:YES];
    [self.containerView2 addSubview:self.movieImageView2];
}

- (void)createmovieName1Label {
    self.movieName1 = [[UILabel alloc] init];
    [self.movieName1 setFont:[UIFont systemFontOfSize:fontSize]];
    [self.movieName1 setTextColor:[UIColor darkTextColor]];
    [self.movieName1 setNumberOfLines:0];
    [self.movieName1 sizeToFit];
    [self.containerView1 addSubview:self.movieName1];
    
    self.movieName2 = [[UILabel alloc] init];
    [self.movieName2 setFont:[UIFont systemFontOfSize:fontSize]];
    [self.movieName2 setTextColor:[UIColor darkTextColor]];
    [self.movieName2 setNumberOfLines:0];
    [self.movieName2 sizeToFit];
    [self.containerView2 addSubview:self.movieName2];
}

- (void)setDataForMovie1:(Movie *)movie1 movie2:(Movie *)movie2 {
    self.movie1 = movie1;
    self.movie2 = movie2;
    
    [self.movieImageView1 setImageWithUrl:[NSURL URLWithString:movie1.posterImageUrl]];
    [self.movieName1 setText:movie1.name];
    
    [self.movieImageView2 setImageWithUrl:[NSURL URLWithString:movie2.posterImageUrl]];
    [self.movieName2 setText:movie2.name];
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = (W(self.contentView) - 3*padding)/2;
    
    [self.containerView1 setFrame:CGRectMake(padding, padding, width, H(self.contentView) - 2*padding)];
    [self.movieImageView1 setFrame:CGRectMake(0, 0, W(self.containerView1), imageSize)];
    
    CGSize labelSize = [self.movieName1.text boundingRectWithSize:CGSizeMake((width - 2*betweenPadding), CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    [self.movieName1 setFrame:CGRectMake(betweenPadding, BOTTOM(self.movieImageView1) + betweenPadding, W(self.containerView1) - 2*betweenPadding, labelSize.height)];
    
    
    [self.containerView2 setFrame:CGRectMake(AFTER(self.containerView1) + padding, padding, width, H(self.contentView) - 2*padding)];
    [self.movieImageView2 setFrame:CGRectMake(0, 0, W(self.containerView2), imageSize)];
    
    CGSize labelSize2 = [self.movieName2.text boundingRectWithSize:CGSizeMake((width - 2*betweenPadding), CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    [self.movieName2 setFrame:CGRectMake(betweenPadding, BOTTOM(self.movieImageView2) + betweenPadding, W(self.containerView2) - 2*betweenPadding, labelSize2.height)];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.movieImageView1 setImage:nil];
    [self.movieName1 setText:nil];
    
    [self.movieImageView2 setImage:nil];
    [self.movieName2 setText:nil];
}

- (void)didTapContainer1 {
    if ([self.delegate respondsToSelector:@selector(didTapMovie:)]) {
        [self.delegate didTapMovie:self.movie1];
    }
}

- (void)didTapContainer2 {
    if ([self.delegate respondsToSelector:@selector(didTapMovie:)]) {
        [self.delegate didTapMovie:self.movie2];
    }
}

+ (CGFloat)getHeightForMovie1:(Movie *)movie1 movie2:(Movie *)movie2 {
    CGFloat height = 0.0f;
    CGFloat width = (([[UIScreen mainScreen] bounds].size.width - 3*padding)/2) - 2*betweenPadding;
    
    height += 2*padding;
    height += imageSize;
    height += betweenPadding;
    
    CGSize labelSize1 = [movie1.name boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    CGSize labelSize2 = [movie2.name boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    height += (MAX(labelSize1.height, labelSize2.height) + padding);
    
    return height;
}

@end
