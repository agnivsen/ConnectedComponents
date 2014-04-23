//
//  ConnectedComponentLabelling.h
//  ConnectedComponents
//
//  Created by agniva on 16/04/14.
//  Copyright (c) 2014 agniva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectedComponentLabelling : NSObject

-(UIImage *)twoPassCCL : (UIImage *) image : (UIColor *) color;
-(int) getUniqueElementCount;

@end

int uniqueElement;