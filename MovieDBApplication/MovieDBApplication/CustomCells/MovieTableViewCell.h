//
//  MovieTableViewCell.h
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@protocol MovieTableViewCellDelegate <NSObject>

- (void)didTapMovie:(Movie *)movie;

@end

@interface MovieTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MovieTableViewCellDelegate> delegate;

- (void)setDataForMovie1:(Movie *)movie1 movie2:(Movie *)movie2;
+ (CGFloat)getHeightForMovie1:(Movie *)movie1 movie2:(Movie *)movie2;

@end
