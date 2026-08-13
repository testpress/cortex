/**
 * @file MobileRTCMeetingService+Avatar.h
 * @brief Meeting+Avatar service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @class MobileRTC3DAvatarImageInfo
 * @brief 3d avatar image item.
 */
@interface MobileRTC3DAvatarImageInfo : NSObject
/**
 * @brief YES if the current image is selected. Otherwise, NO.
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 * @brief The file path of the current image.
 */
@property (nonatomic, copy) NSString * _Nullable imagePath;

/**
 * @brief The name of the current image.
 */
@property (nonatomic, copy) NSString * _Nullable imageName;

/**
 * @brief The index of the current image.
 */
@property (nonatomic, assign) NSInteger index;

/**
 * @brief YES if it is the most recently used image. Otherwise, NO.
 */
@property(nonatomic,assign) BOOL isLastUsed;

@end


/**
 * @brief For 3d avatar interface.
 */
@interface MobileRTCMeetingService (Avatar)
/**
 * @brief Determines if the 3D avatar feature is supported by the video device.
 * @return YES if the video device supports the 3D avatar feature. Otherwise, NO.
 */
- (BOOL)is3DAvatarSupportedByDevice;

/**
 * @brief Determines if the 3D avatar feature is enabled.
 * @return YES if the video filter feature is enabled. Otherwise, NO.
 */
- (BOOL)is3DAvatarEnabled;

/**
 * @brief Gets the array of the video filter images.
 * @return If the function succeeds, it returns an NSArray of MobileRTC3DAvatarImageInfo objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTC3DAvatarImageInfo* >* _Nullable)get3DAvatarImageList;

/**
 * @brief Specifies an image to be the video filter image.
 * @param imageInfo The image to use.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Will close the 3D avatar when the imageInfo.index is -1.
 */
- (MobileRTCSDKError)set3DAvatarImage:(MobileRTC3DAvatarImageInfo*_Nullable)imageInfo;

/**
 * @brief Sets to show or hide the last used avatar in the meeting.
 * @param bShow YES to show the last used avatar. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)showAvatar:(BOOL)bShow;

/**
 * @brief Determines if the meeting is showing the avatar.
 * @return YES if the meeting is showing the avatar. Otherwise, NO.
 */
- (BOOL)isShowAvatar;

/**
 * @brief Enables or disables 3D avatar effect when joining meeting.
 * @param enable YES to enable 3D avatar effect. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enable3DAvatarEffectForAllMeeting:(BOOL)enable;

/**
 * @brief Determines whether 3D avatar is enabled when joining the meeting.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)is3DAvatarEffectForAllMeetingEnabled;

@end

