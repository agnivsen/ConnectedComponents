//
//  ConnectedComponentLabelling.m
//  ConnectedComponents
//
//  Created by agniva on 16/04/14.
//  Copyright (c) 2014 agniva. All rights reserved.
//

#import "ConnectedComponentLabelling.h"

@implementation ConnectedComponentLabelling

int dimension = 1000;
int unionFinder[2][1000];
int multiplier = 1;
int colorMap[2][200];


/*color is the value for which the target image will be binarized*/
-(UIImage *)twoPassCCL : (UIImage *) image : (UIColor *) color
{
    [self initUnionFind];
    
    if(color == Nil)
    {
        color = [UIColor whiteColor];
    }

    
    CGImageRef imageRef = [image CGImage];
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    unsigned char *input_image = (unsigned char *)CFDataGetBytePtr(pixelData);
    unsigned char *output_image = (unsigned char *)malloc(height*4*width);
    
    int i,j;
    
    float label = 0;
    
    float rLow, rHigh, bLow, bHigh, gLow, gHigh;
    
    int tolerance = 10;
    
    const CGFloat *_components = CGColorGetComponents(color.CGColor);
    
    int red = _components[0]*255;
    int green = _components[1]*255;
    int blue = _components[2]*255;
    
    bLow = (blue - tolerance);
    bHigh = (blue + tolerance);
    gLow = (green - tolerance);
    gHigh = (green + tolerance);
    rLow = (red - tolerance);
    rHigh = (red + tolerance);
    
    bLow<0?(bLow = 0):(bHigh>255?bHigh = 255:TRUE);
    gLow<0?(gLow = 0):(gHigh>255?gHigh = 255:TRUE);
    rLow<0?(rLow = 0):(rHigh>255?rHigh = 255:TRUE);
    
    for (i=0; i<height;i++) {
        for (j=0; j<4*width; j+=4) {
            
            //first pass
            
            if(((input_image[i*4*width+4*(j/4)])>rLow)&&((input_image[i*4*width+4*(j/4)])<=rHigh)&&((input_image[i*4*width+4*(j/4)+1])>gLow)&&((input_image[i*4*width+4*(j/4)+1])<=gHigh)&&((input_image[i*4*width+4*(j/4)+2])>bLow)&&((input_image[i*4*width+4*(j/4)+2])<=bHigh))
                
            {
                output_image[i*4*width+4*(j/4)+0] = 255;
                output_image[i*4*width+4*(j/4)+1] = label;  //assigning label value to this channel
                output_image[i*4*width+4*(j/4)+2]   = 0;
                output_image[i*4*width+4*(j/4)+3] = 255;
            }
            
            else
            {
                output_image[i*4*width+4*(j/4)+0] = 0;
                output_image[i*4*width+4*(j/4)+1] = 0;
                output_image[i*4*width+4*(j/4)+2]   = 0;
                output_image[i*4*width+4*(j/4)+3] = 255;
            }
        }
    }
    
    
    
    for (i=0; i<height;i++)
    {
        for (j=0; j<4*width; j+=4)
        {
            //second pass
            
            if((i>0)&&(j>0)&&(j<((4*width)-4))&&(output_image[i*4*width+4*(j/4)+0]==255))
            {
                
                
                int n1 =output_image[(i-1)*4*width+4*(j/4)+0];
                int n2 =output_image[i*4*width+4*((j-4)/4)+0];
                int n3 =output_image[(i-1)*4*width+4*((j-4)/4)+0];
                int n4 = output_image[(i-1)*4*width+4*((j+4)/4)+0];
                
                int l1 =output_image[(i-1)*4*width+4*(j/4)+1];
                int l2 =output_image[i*4*width+4*((j-4)/4)+1];
                int l3 =output_image[(i-1)*4*width+4*((j-4)/4)+1];
                int l4 = output_image[(i-1)*4*width+4*((j+4)/4)+1];
                
                
                if((n1==0)&&(n2==0)&&(n3==0)&&(n4==0))
                {
                    
                    label++;
                    output_image[i*4*width+4*(j/4)+1] = label;
                }
                else if ((n1+n2+n3+n4)==255)
                {
                    
                    if(n1==255)
                    {
                        output_image[i*4*width+4*(j/4)+1] = l1;
                    }
                    else if(n2==255)
                    {
                        output_image[i*4*width+4*(j/4)+1] = l2;
                    }
                    else if(n3==255)
                    {
                        output_image[i*4*width+4*(j/4)+1] = l3;
                    }
                    else if(n4==255)
                    {
                        output_image[i*4*width+4*(j/4)+1] = l4;
                    }
                    
                }
                else if((n1+n2+n3+n4)>255)
                {
                    
                    int min = 500;
                    int arr[4];
                    int index = 0;
                    
                    if(l1>0)
                    {
                        if(min>l1)
                        {
                            min = l1;
                            arr[index++] = l1;
                        }
                    }
                    if(l2>0)
                    {
                        if(min>l2)
                        {
                            min = l2;
                            arr[index++] = l2;
                        }
                    }
                    if(l3>0)
                    {
                        if(min>l3)
                        {
                            min = l3;
                            arr[index++] = l3;
                        }
                    }
                    if(l4>0)
                    {
                        if(min>l4)
                        {
                            min = l4;
                            arr[index++] = l4;
                        }
                    }
                    
                     output_image[i*4*width+4*(j/4)+1] = min;
                    
                    for(int i = 0; i<index; i++)
                    {
                        [self unionMake:arr[i] :min];
                    }
                    
                }
            }
            
            
        }
    }
    
    
    
    int totalUnique = [self countUniqueElement:label];
    NSLog(@"Total unique connected component = %d",totalUnique);
    uniqueElement = totalUnique;
    
    if(totalUnique>0)
    {
    int step = 255/totalUnique;
    
    int rCCL = 0;
    int gCCL = 255;
    
    for (i=0; i<height;i++)
    {
        for (j=0; j<4*width; j+=4)
        {
            //a final pass for rendering the input image using color gradients to match the number of unique elements found
            if((i>0)&&(j>0)&&(j<((4*width)-4))&&(output_image[i*4*width+4*(j/4)+0]==255))
            {
                int label = output_image[i*4*width+4*(j/4)+1];
                
                int parent = [self find:label];
                
                int colorKey = [self returnColorKey:parent :totalUnique];
                
                
                output_image[i*4*width+4*(j/4)+0] = rCCL + (colorKey*step);
                output_image[i*4*width+4*(j/4)+1] = gCCL - (colorKey*step);
                output_image[i*4*width+4*(j/4)+2] = 255;//bCCL + (colorKey*step);
            }
            //this loop can be removed if a nice and colorful output is not required as the end result
        }
    }
    
       
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo1 = kCGBitmapByteOrderDefault |  kCGImageAlphaPremultipliedLast;
    CGContextRef context = CGBitmapContextCreate(output_image,
                                    width,
                                    height,
                                    8,
                                    4*width,
                                    colorSpaceRef,
                                    bitmapInfo1);
    
    CGImageRef modifiedImageRef = CGBitmapContextCreateImage (context);
    UIImage* newimage = [UIImage imageWithCGImage:modifiedImageRef];
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRelease(context);
    CFRelease(modifiedImageRef);
    
    return newimage;
    }
    else
    {
        return image;
    }

}

-(int)countUniqueElement:(int) sizeCurrent
{
    int countObj = 0;
    
    
    for(int i = 1; i<sizeCurrent; i++)
    {
        if(unionFinder[1][i]<=-1)
        {
            colorMap[0][countObj] = countObj;
            colorMap[1][countObj] = unionFinder[0][i];
            countObj++;
        }
    }
    return countObj;
    
}

-(int)returnColorKey:(int) key :(int) size
{
    
    int colorKey = 0;
    for(int i = 0; i<size; i++)
    {
        if(colorMap[1][i]==key)
        {
            colorKey = i;
        }
    }
    
    return colorKey;
}

-(void)unionMake:(int) key1 :(int) key2
{
    
    
    int root1 = key1/multiplier;
    int root2 = key2/multiplier;
    
    int parent1 = unionFinder[1][root1];
    int parent2 = unionFinder[1][root2];
    
    
    if(key1!=key2)
    {
        if((parent1<0)&&(parent2<0))
        {
            
            if(parent1<parent2)
            {
                unionFinder[1][root2] = unionFinder[0][root1];
                unionFinder[1][root1]--;
            }
            else
            {
                unionFinder[1][root1] = unionFinder[0][root2];
                unionFinder[1][root2]--;
            }
            
        }
        else if ((parent1<0)&&(parent2>=0))
        {
            parent2 = [self find:key2];
            
            if(parent2!=key1)
            {
                unionFinder[1][parent2]--;
                unionFinder[1][root1] = parent2;
            }
        }
        else if ((parent1>=0)&&(parent2<0))
        {
            parent1 = [self find:key1];
            
            if(parent1!=key2)
            {
                unionFinder[1][parent1]--;
                unionFinder[1][root2] = parent1;
            }
        }
        else if ((parent1>=0)&&(parent2>=0))
        {
            parent1 = [self find:key1];
            parent2 = [self find:key2];
            
            if((parent1!=key2)&&(parent2!=key1)&&(parent1!=parent2))
            {
                unionFinder[1][parent2] = parent1;
                unionFinder[1][parent1]--;
            }
        }
    }
    
}

-(int)find:(int) key
{
    
    int root = key/multiplier;
    int parent = unionFinder[1][root];
    
    if(parent<0)
    {
        return key;
    }
    else
    {
        parent = [self find:parent];
        return parent;
    }
    
    
}

-(void)initUnionFind
{
    int label = 0;
    for(int i = 0; i<dimension; i++)
    {
        unionFinder[0][i] = label;
        label+=multiplier;
        unionFinder[1][i] = -1;
    }
    
}

-(int) getUniqueElementCount
{
    return uniqueElement;
}


@end
