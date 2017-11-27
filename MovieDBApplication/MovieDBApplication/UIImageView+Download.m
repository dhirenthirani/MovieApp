//
//  UIImageView+Download.m
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import "UIImageView+Download.h"

@implementation UIImageView (Download)

- (void)setImageWithUrl:(NSURL *)url {
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loader];
    [self bringSubviewToFront:loader];
    [loader setCenter:self.center];
    [loader setHidesWhenStopped:YES];
    [loader startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
                [loader stopAnimating];
                [loader setHidden:YES];
                [loader removeFromSuperview];
            });
        }]resume];
    });
}

@end
