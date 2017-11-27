//
//  GetMovieDetail.m
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "GetMovieDetail.h"

@implementation GetMovieDetail

- (instancetype)init {
    self = [super init];
    if (self) {
        self.movie = [[Movie alloc] init];
    }
    return self;
}

- (void)getMovieForMovieId:(NSNumber *)movieId {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=602eb9d1f5397e4be0e036fa9baa1fe0", movieId];
        
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [urlRequest setHTTPMethod:@"GET"];
        
        [[NSURLSession.sharedSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (!error && data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                [self.movie parseResponseObject:json];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(movieFetchedSuccessfully)]) {
                        [self.delegate movieFetchedSuccessfully];
                    }
                });
                
            }
            else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(movieFetchingFailedWithError:)]) {
                        [self.delegate movieFetchingFailedWithError:error];
                    }
                });
            }
            
        }] resume];
    });
}

@end
