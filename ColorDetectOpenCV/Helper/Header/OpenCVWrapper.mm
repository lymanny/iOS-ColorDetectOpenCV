//
//  OpenCVWrapper.m
//  ColorDetectOpenCV
//
//  Created by lymanny on 14/2/25.
//

// Fix: Prevent 'NO' macro conflict by undefining it first
#undef NO

// Include OpenCV headers AFTER the fix
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc.hpp>
#import <opencv2/highgui.hpp>
#import <opencv2/core/core.hpp>
#import <opencv2/imgcodecs/ios.h>

// Now include OpenCVWrapper after fixing Apple conflicts
#import "OpenCVWrapper.h"
#import <UIKit/UIKit.h>

@implementation OpenCVWrapper

+ (UIImage *)detectGreenObjects:(UIImage *)image originalSize:(CGSize)originalSize {
    if (!image || !image.CGImage) {
        NSLog(@"[OpenCV] Error: UIImage is nil or has no CGImage.");
        return nil;
    }

    // Convert UIImage to cv::Mat (Ensure Full Camera Frame)
    cv::Mat mat;
    UIImageToMat(image, mat);
    if (mat.empty()) {
        NSLog(@"[OpenCV] Error: Failed to convert UIImage to Mat.");
        return nil;
    }

    // Resize Mat to match the original camera resolution (fix cropping issue)
    cv::resize(mat, mat, cv::Size(originalSize.width, originalSize.height));

    // Convert to HSV color space
    cv::Mat hsv;
    cv::cvtColor(mat, hsv, cv::COLOR_BGR2HSV);

    // Define green color range in HSV
    cv::Scalar lowerGreen(30, 80, 80);
    cv::Scalar upperGreen(90, 255, 255);

    // Apply color threshold to detect green objects
    cv::Mat mask;
    cv::inRange(hsv, lowerGreen, upperGreen, mask);

    // Find contours of detected green objects
    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(mask, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);

    // Draw bounding boxes in correct position
    for (const auto& contour : contours) {
        cv::Rect bbox = cv::boundingRect(contour);  // Get the bounding box

        // Scale bounding box if necessary
        float xScale = originalSize.width / mat.cols;
        float yScale = originalSize.height / mat.rows;

        cv::Rect scaledBbox(bbox.x * xScale, bbox.y * yScale, bbox.width * xScale, bbox.height * yScale);

        // Draw Green Bounding Box on Full Camera Frame
        cv::rectangle(mat, scaledBbox, cv::Scalar(0, 255, 0), 3);
    }

    return MatToUIImage(mat);
}

@end
