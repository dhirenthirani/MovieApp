//
//  Movie.h
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSNumber *userRating;
@property (nonatomic, strong) NSNumber *movieId;

- (void)parseResponseObject:(NSDictionary *)responseObject;

@end