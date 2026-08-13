/**
 * @file MobileRTCAutoFramingParameter.h
 * @brief Auto-framing parameters.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>

/**
 * @class MobileRTCAutoFramingParameter
 * @brief A class that contains auto-framing parameters.
 */
@interface MobileRTCAutoFramingParameter : NSObject

/**
 * @brief The ratio of auto framing. For each mode, the ratio is different.
 */
@property (nonatomic, assign) CGFloat ratio;

/**
 * @brief The auto framing fail strategy.
 */
@property (nonatomic, assign) MobileRTCFaceRecognitionFailStrategy failStrategy;
@end

