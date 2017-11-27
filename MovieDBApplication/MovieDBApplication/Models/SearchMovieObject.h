//
//  SearchMovieObject.h
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchMovieDelegate <NSObject>

- (void)movieSearchedSuccessfully;
- (void)movieSearchFailedWithError:(NSError *)error;

@end

@interface SearchMovieObject : NSObject

@property (nonatomic) BOOL isLoading;

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *totalPage;
@property (nonatomic, strong) NSNumber *totalResult;
@property (nonatomic, strong) NSMutableArray *moviesArray;

@property (nonatomic, strong) NSString *searchString;

@property (nonatomic, weak) id<SearchMovieDelegate> delegate;

- (void)getMovieListForSearchString:(NSString *)searchString;
- (void)loadMoreResults;

@end
