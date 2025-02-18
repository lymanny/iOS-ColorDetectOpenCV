//
//  OpenCVWrapper.h
//  ColorDetectOpenCV
//
//  Created by lymanny on 14/2/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject

// Ensure method signatures are correct
+ (UIImage *)detectGreenObjects:(UIImage *)image originalSize:(CGSize)originalSize;

@end


