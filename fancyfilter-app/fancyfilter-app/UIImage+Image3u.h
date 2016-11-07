//
//  UIImage+Image3u.h
//

#import <UIKit/UIKit.h>

#include "fancyfilter/fancyfilter.hpp"

@interface UIImage (Image3u)

/**
 Initialize a new UIImage with an Image3u
 
 @param imageIn fancyfilter::Image3u to convert to a UIImage

 @return UIImage pointer initialized with the imageIn
 */
- (id)initWithImage3u:(const fancyfilter::Image3u&)imageIn;


/**
 Create a copy of the pixel data for this UIImage and return it as
 a fancyfilter::Image3u.
 
 @note Only works for 4-channel images (even if alpha is skipped/none
 
 @return fancyfilter::Image3u for *this* UIImage
 */
- (fancyfilter::Image3u)image3u;

@end
