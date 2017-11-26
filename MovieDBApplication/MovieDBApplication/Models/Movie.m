//
//  Movie.m
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (void)parseResponseObject:(NSDictionary *)responseObject {
    self.movieId = [responseObject objectForKey:@"id"];
    self.name = [responseObject objectForKey:@"original_title"];
    self.synopsis = [responseObject objectForKey:@"overview"];
    self.releaseDate = [responseObject objectForKey:@"release_date"];
    self.tagline = [responseObject objectForKey:@"tagline"];
    self.userRating = [responseObject objectForKey:@"vote_average"];
    self.movieStatus = [responseObject objectForKey:@"status"];
    
    NSString *posterUrl = [responseObject objectForKey:@"poster_path"];
    self.posterImageUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", posterUrl];
    
    NSString *backDropPath = [responseObject objectForKey:@"backdrop_path"];
    self.imageUrl = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/original%@", backDropPath];
}

@end
