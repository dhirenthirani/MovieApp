//
//  SearchMovieObject.m
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "SearchMovieObject.h"
#import "Movie.h"

@interface SearchMovieObject ()

@property (nonatomic, strong) NSURLSession *task;
@end

@implementation SearchMovieObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.moviesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadMoreResults {
    if (self.moviesArray.count < self.totalResult.integerValue) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@(self.page.integerValue + 1) forKey:@"page"];
        [params setObject:self.searchString forKey:@"query"];
        
        [self getMovieListWithParams:[self getStringFromDictionary:params]];
    }
}

- (NSString *)getStringFromDictionary:(NSDictionary *)dictionary {
    NSString *param = @"";
    for (NSString *key in dictionary) {
        param = [param stringByAppendingFormat:@"&%@=%@", key, [dictionary valueForKey:key]];
    }
    return param;
}

- (void)getMovieListForSearchString:(NSString *)searchString {
    [self.moviesArray removeAllObjects];
    self.totalResult = @(0);
    self.page = @(1);
    self.totalPage = @(0);
    
    self.searchString = searchString;
    
    if (searchString.length > 0) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:self.searchString forKey:@"query"];
        
        [self getMovieListWithParams:[self getStringFromDictionary:params]];
    }
}

- (void)getMovieListWithParams:(NSString *)params {
    self.isLoading = YES;
    [self cancelRequest];
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/search/movie?api_key=602eb9d1f5397e4be0e036fa9baa1fe0"];
        
        if (params.length > 0) {
            urlString = [urlString stringByAppendingString:params];
        }
        
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [urlRequest setHTTPMethod:@"GET"];
        
        self.task = NSURLSession.sharedSession;
        [[self.task dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (!error && data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                [self parseResponseObject:json];
                
                self.isLoading = NO;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(movieSearchedSuccessfully)]) {
                        [self.delegate movieSearchedSuccessfully];
                    }
                });
                
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(movieSearchFailedWithError:)]) {
                        [self.delegate movieSearchFailedWithError:error];
                    }
                });
            }
            
        }] resume];
    });
}

- (void)cancelRequest {
    [self.task invalidateAndCancel];
}

- (void)parseResponseObject:(NSDictionary *)responseObject {
    self.page = [responseObject objectForKey:@"page"];
    self.totalPage = [responseObject objectForKey:@"total_pages"];
    self.totalResult = [responseObject objectForKey:@"total_results"];
    
    NSArray *results = [responseObject objectForKey:@"results"];
    for (NSDictionary *dictionary in results) {
        Movie *movie = [[Movie alloc] init];
        [movie parseResponseObject:dictionary];
        [self.moviesArray addObject:movie];
    }
}

@end
