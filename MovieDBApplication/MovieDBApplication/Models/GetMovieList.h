//
//  GetMovieList.h
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetMovieListDelegate <NSObject>

- (void)movieListFetchedSuccessfully;
- (void)movieListFetchingFailedWithError:(NSError *)error;

@end

@interface GetMovieList : NSObject

@property (nonatomic) BOOL isLoading;

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *totalPage;
@property (nonatomic, strong) NSNumber *totalResult;
@property (nonatomic, strong) NSMutableArray *moviesArray;

@property (nonatomic, weak) id<GetMovieListDelegate> delegate;

- (void)getHighestRatedMovies;

- (void)getPopularMovieList;

- (void)loadMoreResults;

@end
