//
//  UILoaderTableViewCell.m
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "UILoaderTableViewCell.h"

@interface UILoaderTableViewCell()

@property (nonatomic, strong) UIActivityIndicatorView *loader;

@end

@implementation UILoaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
        
        [self createViews];
    }
    return self;
}

- (void)createViews {
    self.loader = [[UIActivityIndicatorView alloc] init];
    [self.loader setHidesWhenStopped:YES];
    [self.loader startAnimating];
    [self.contentView addSubview:self.loader];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.loader setCenter:self.contentView.center];
}

@end
