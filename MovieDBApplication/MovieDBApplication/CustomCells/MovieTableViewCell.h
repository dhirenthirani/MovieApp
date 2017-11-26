//
//  MovieTableViewCell.h
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieTableViewCell : UITableViewCell

- (void)setData:(Movie *)movie;
+ (CGFloat)getHeightForMovie:(Movie *)movie;

@end
