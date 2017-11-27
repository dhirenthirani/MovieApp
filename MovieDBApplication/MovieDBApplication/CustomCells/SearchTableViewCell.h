//
//  SearchTableViewCell.h
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setName:(NSString *)name;

+ (CGFloat)getHeight:(NSString *)name;

@end
