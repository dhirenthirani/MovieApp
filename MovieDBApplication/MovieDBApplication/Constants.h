//
//  Constants.h
//  MovieDBApplication
//
//  Created by Anurag on 26/11/17.
//  Copyright © 2017 Dhiren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define H(v)                    v.frame.size.height
#define W(v)                    v.frame.size.width
#define BOTTOM(v)               v.frame.origin.y + v.frame.size.height
#define AFTER(v)                v.frame.origin.x + v.frame.size.width

#define SIDE_PADDING            12

@interface Constants : NSObject

+ (CGFloat)navigationBarHeight;

@end
