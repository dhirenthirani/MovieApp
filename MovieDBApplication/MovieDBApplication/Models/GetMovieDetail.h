//
//  GetMovieDetail.h
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@protocol GetMovieDetailDelegate <NSObject>

- (void)movieFetchedSuccessfully;
- (void)movieFetchingFailedWithError:(NSError *)error;

@end

@interface GetMovieDetail : NSObject

@property (nonatomic, strong) Movie *movie;

@property (nonatomic, weak) id<GetMovieDetailDelegate> delegate;

- (void)getMovieForMovieId:(NSNumber *)movieId;

@end
