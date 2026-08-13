/**
 * @file MobileRTCFaceROIInfo.h
 * @brief Per-frame face region of interest (ROI) accessor for raw video data.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief Face region of interest reported alongside a decoded frame.
 *
 * Coordinates are normalized to [0.0, 1.0], with the origin at the top-left
 * corner of the decoded (pre-rotation) frame. Callers that need display
 * coordinates must apply the frame rotation reported by the host raw data.
 */
@interface MobileRTCFaceROI : NSObject
/** Normalized left edge, [0.0, 1.0]. */
@property (readonly, nonatomic) float left;
/** Normalized top edge, [0.0, 1.0]. */
@property (readonly, nonatomic) float top;
/** Normalized right edge, [0.0, 1.0], > left. */
@property (readonly, nonatomic) float right;
/** Normalized bottom edge, [0.0, 1.0], > top. */
@property (readonly, nonatomic) float bottom;
@end

/**
 * @class MobileRTCFaceROIInfo
 * @brief Per-frame face ROI metadata accessor.
 *
 * Face ROI data is generated on the sender's device and embedded in the
 * video stream. The receiver SDK only surfaces what the sender provides;
 * no face detection is performed locally. Individual participants may
 * deliver frames with zero detected faces — for example, when their device
 * does not support face detection or detection is not currently active.
 *
 * Reachable from two raw video delegate callbacks:
 *  - @c -onMobileRTCRender:frameRawData: via @c MobileRTCVideoRawData.faceROIInfo
 *  - @c -onMobileRTCRender:framePixelBuffer:extraInfo: via @c MobileRTCVideoPixelBufferExtraInfo.faceROIInfo
 *
 * @note Face ROI is only supported on video streams.
 */
@interface MobileRTCFaceROIInfo : NSObject

/**
 * @brief Number of valid face ROIs available for the current frame.
 *
 * When multiple faces are present, the ROIs are ordered by the area of the
 * detected region in descending order — index 0 corresponds to the largest
 * (typically closest or most prominent) face.
 *
 * @return The face count in [0, 50]. Zero indicates no face was detected,
 *         the sender has not enabled detection, or face metadata was not
 *         delivered for this frame.
 */
- (NSUInteger)getFaceCount;

/**
 * @brief Get a face ROI by zero-based index.
 *
 * Faces are sorted by detected region area in descending order; index 0
 * is always the largest face in the frame.
 *
 * @param index The zero-based index, must be < @c -getFaceCount.
 * @return The face ROI on success, or @c nil if @p index is out of range.
 */
- (nullable MobileRTCFaceROI *)getFaceROIByIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
