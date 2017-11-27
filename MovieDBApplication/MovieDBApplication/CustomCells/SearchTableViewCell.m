//
//  SearchTableViewCell.m
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "Constants.h"

@implementation SearchTableViewCell

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
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.titleLabel setTextColor:[UIColor darkTextColor]];
    [self.titleLabel setNumberOfLines:0];
    
    [self.contentView addSubview:self.titleLabel];
}

- (void)setName:(NSString *)name {
    [self.titleLabel setText:name];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize labelSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake((W(self.contentView) - 2*SIDE_PADDING), CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    
    [self.titleLabel setFrame:CGRectMake(SIDE_PADDING, SIDE_PADDING, W(self.contentView) - 2*SIDE_PADDING, labelSize.height)];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self.titleLabel setText:nil];
}

+ (CGFloat)getHeight:(NSString *)name {
    CGFloat height = 0;
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - 2*SIDE_PADDING;
    
    height += 2*SIDE_PADDING;
    
    CGSize labelSize = [name boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    
    height += labelSize.height;
    
    return height;
}

@end
