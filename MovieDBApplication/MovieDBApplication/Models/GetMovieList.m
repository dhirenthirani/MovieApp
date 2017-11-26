//
//  GetMovieList.m
//  MovieDBApplication
//
//  Created by Anurag on 27/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "GetMovieList.h"
#import "Movie.h"

@implementation GetMovieList

- (instancetype)init {
    self = [super init];
    if (self) {
        self.moviesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getMovieList {
    [self getMovieListWithParams:nil];
}

- (void)loadMoreResults {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(self.page.integerValue + 1) forKey:@"page"];
    
    [self getMovieListWithParams:[self getStringFromDictionary:params]];
}

- (NSString *)getStringFromDictionary:(NSDictionary *)dictionary {
    NSString *param = @"";
    for (NSString *key in dictionary) {
        param = [param stringByAppendingFormat:@"&%@=%@", key, [dictionary valueForKey:key]];
    }
    return param;
}

- (void)getMovieListWithParams:(NSString *)params {
    self.isLoading = YES;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?api_key=602eb9d1f5397e4be0e036fa9baa1fe0"];
        
        if (params.length > 0) {
            urlString = [urlString stringByAppendingString:params];
        }
        
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [urlRequest setHTTPMethod:@"GET"];
        
        [[NSURLSession.sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Data received: %@", myString);
            
            if (!error && data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                [self parseResponseObject:json];
                
                self.isLoading = NO;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(movieListFetchedSuccessfully)]) {
                        [self.delegate movieListFetchedSuccessfully];
                    }
                });
                
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(movieListFetchingFailedWithError:)]) {
                        [self.delegate movieListFetchingFailedWithError:error];
                    }
                });
            }
            
        }] resume];
    });
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
