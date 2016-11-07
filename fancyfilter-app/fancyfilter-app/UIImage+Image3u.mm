//
//  UIImage+Image3u.mm
//

#import "UIImage+Image3u.h"

#include <memory>

void reorientTransformAndBounds(CGAffineTransform *transformRef, size_t *widthRef, size_t *heightRef, UIImageOrientation orientation) {

    CGAffineTransform transform = *transformRef;
    CGFloat width = *widthRef;
    CGFloat height = *heightRef;
    
    switch (orientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, height, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, width);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (orientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Update the transform
    *transformRef = transform;
    
    // If necessary, swap the width and height which will be used for creating the context
    if (orientation == UIImageOrientationLeft || orientation == UIImageOrientationLeftMirrored ||
        orientation == UIImageOrientationRight || orientation == UIImageOrientationRightMirrored) {
        *widthRef = height;
        *heightRef = width;
    }
}


@implementation UIImage (Image3u)

- (id)initWithImage3u:(const fancyfilter::Image3u&)imageIn
{
    NSLog(@"init here");
    int w = imageIn.width();
    int h = imageIn.height();
    
    size_t n = w * h * 4 * sizeof(uint8_t);
    std::unique_ptr<unsigned char[]> buf(new unsigned char[n]);
    const unsigned char *imagePtr = imageIn.row(0);
    unsigned char *dataPtr = buf.get();
    for (int i = 0; i < w * h; i++) {
        dataPtr[0] = imagePtr[0];
        dataPtr[1] = imagePtr[1];
        dataPtr[2] = imagePtr[2];
        dataPtr[3] = 255;
        dataPtr += 4;
        imagePtr += 3;
    }
    
    NSData *data = [NSData dataWithBytes:buf.get() length:n];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(w,                                          //width
                                        h,                                          //height
                                        8,                                          //bits per component
                                        8 * 4,                                      //bits per pixel
                                        w * 4 * sizeof(uint8_t),                    //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    self = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return self;
}

- (fancyfilter::Image3u)image3u
{
    CGImageRef cgImage = self.CGImage;

    // Only work on 8-bit per channel images
    NSAssert(CGImageGetBitsPerComponent(cgImage) == 8, @"");
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    size_t depth = CGImageGetBytesPerRow(cgImage) / width;
    NSAssert((depth == 4), @"");
    
    size_t n = width * height * depth * sizeof(uint8_t);
    std::unique_ptr<unsigned char[]> buf(new unsigned char[n]);
    std::fill(buf.get(), buf.get() + n, 0);
    
    // Render this image into the Image3u data
    CGRect origRect = CGRectMake(0, 0, width, height); // Save the orig rect, since it will be transformed
    CGAffineTransform transform = CGAffineTransformIdentity;
    reorientTransformAndBounds(&transform, &width, &height, self.imageOrientation);
    
    CGContextRef ctx = CGBitmapContextCreate(buf.get(),
                                             width,
                                             height,
                                             8,
                                             width * depth * sizeof(uint8_t),
                                             CGImageGetColorSpace(cgImage),
                                             CGImageGetBitmapInfo(cgImage));

    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, origRect, cgImage);
    CGContextRelease(ctx);

    fancyfilter::Image3u imageOut(static_cast<int>(width), static_cast<int>(height));
    unsigned char *imagePtr = imageOut.row(0);
    const unsigned char *dataPtr = buf.get();
    for (int i = 0; i < width * height; i++) {
        imagePtr[0] = dataPtr[0];
        imagePtr[1] = dataPtr[1];
        imagePtr[2] = dataPtr[2];
        // skip data ptr alpha channel
        dataPtr += 4;
        imagePtr += 3;
    }

    return imageOut;
}

@end
