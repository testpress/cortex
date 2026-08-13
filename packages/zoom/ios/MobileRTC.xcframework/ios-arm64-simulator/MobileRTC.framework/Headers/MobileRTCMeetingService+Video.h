/**
 * @file MobileRTCMeetingService+Video.h
 * @brief Meeting+Video service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>
#import <AVFoundation/AVFoundation.h>

/**
 * @class MobileRTCVideoPreferenceSetting
 * @brief Video Preference Setting.
 * @note When setting custom modes, the developer provides the maximum and minimum frame rates.
 * @note If the current bandwidth cannot maintain the minimum frame rate, the video system will drop to the next lower resolution.
 * @note The default maximum and minimum frame rates for other modes are 0.
 */
@interface MobileRTCVideoPreferenceSetting : NSObject
/**
 * @brief Preferred video mode. 
 * @note 0: Balance mode; 1: Smoothness mode; 2: Sharpness mode; 3: Custom mode
 */
@property (nonatomic, assign) MobileRTCVideoPreferenceMode mode;

/**
 * @brief Minimum frame rate, default is 0, minimumFrameRate should be less than maximumFrameRate.
 * @note Range: from 0 to 30. Out of range for frame rate will use default frame rate of Zoom.
 */
@property (nonatomic, assign) NSUInteger minimumFrameRate;

/**
 * @brief Maximum frame rate, default is 0, , maximumFrameRate should be less or equal than 30.
 * @note Range: from 0 to 30. Out of range for frame rate will use default frame rate of Zoom.
 */
@property (nonatomic, assign) NSUInteger maximumFrameRate;

@end

/**
 * @class MobileRTCCameraDevice
 * @brief Camera information.
 */
@interface MobileRTCCameraDevice : NSObject
/**
 * @brief Camera device ID.
 */
@property (nonatomic, readonly, nullable, copy) NSString* deviceId;
/**
 * @brief Camera name.
 */
@property (nonatomic, readonly, nullable, copy) NSString* deviceName;
/**
 * @brief Is current use.
 */
@property (nonatomic, readonly, assign)         BOOL isSelectDevice;
/**
 * @brief Camera position.
 */
@property (nonatomic, readonly, assign)         AVCaptureDevicePosition position;
/**
 * @brief Camera device type.
 */
@property (nonatomic, readonly, nullable, copy) AVCaptureDeviceType deviceType;
/**
 * @brief Camera maximum zoom factor. Maximum supported is 10.
 */
@property (nonatomic, readonly, assign)         CGFloat maxZoomFactor;
/**
 * @brief The maximum optical zoom factor.
 */
@property (nonatomic, readonly, assign)         CGFloat videoZoomFactorUpscaleThreshold;

@end


/**
 * @brief video interface of meeting service.
 */
@interface MobileRTCMeetingService (Video)

/**
 * @brief Queries if the user is sending video.
 * @return YES if sending. Otherwise, NO.
 */
- (BOOL)isSendingMyVideo;

/**
 * @brief Queries if the user can unmute their video themselves.
 * @return YES if able. Otherwise, NO.
 */
- (BOOL)canUnmuteMyVideo;

/**
 * @brief Mutes or unmutes video of the current user.
 * @param mute YES to mute video of the current user. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)muteMyVideo:(BOOL)mute;

/**
 * @brief Rotates my video.
 * @param rotation The device orientation.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)rotateMyVideo:(UIDeviceOrientation)rotation;

/**
 * @brief Queries if the user's video is spotlighted. Once the user's video is spotlighted, it shows only the specified video in the meeting instead of the active user's.
 * @param userId The user ID in the meeting.
 * @return YES if spotlighted. Otherwise, NO.
 */
- (BOOL)isUserSpotlighted:(NSUInteger)userId;

/**
 * @brief Sets whether to spotlight the user's video.
 * @param on YES to spotlight the user's video. NO to cancel spotlighting the user's video.
 * @param userId The user ID whose video will be spotlighted in the meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function, and the user spotlighted should not be the host themselves.
 */
- (BOOL)spotlightVideo:(BOOL)on withUser:(NSUInteger)userId;

/**
 * @brief Un-spotlights all users.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)unSpotlightAllVideos;

/**
 * @brief Gets the spotlight user list.
 * @return UserId array.
 */
- (NSArray <NSNumber *>* _Nullable)getSpotLightedVideoUserList;

/**
 * @brief Queries if the user's video is pinned.
 * @param userId The user ID whose video will be pinned in the meeting.
 * @return YES if the user's video is pinned. Otherwise, NO.
 * @warning This function is only for Zoom UI.
 */
- (BOOL)isUserPinned:(NSUInteger)userId;

/**
 * @brief Determines whether the user's video can be pinned.
 * @param userId The user ID whose video is being checked.
 * @return The result indicating if it is able to pin.
 */
-(MobileRTCPinResult)canPinVideo:(NSUInteger)userId;

/**
 * @brief Sets whether to pin the user's video or not.
 * @param on YES to pin the user's video. Otherwise, NO.
 * @param userId The user ID whose video will be pinned.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning This function is only for Zoom UI.
 */
- (BOOL)pinVideo:(BOOL)on withUser:(NSUInteger)userId;

/**
 * @brief Queries if the user's video is being sent.
 * @param userID The user ID whose video will be sent in the meeting.
 * @return YES if the video is being sent. Otherwise, NO.
 */
- (BOOL)isUserVideoSending:(NSUInteger)userID;

/**
 * @brief Stops the user's video.
 * @param userID The user ID of other users except the host in the meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only host can run the function in the meeting.
 */
- (BOOL)stopUserVideo:(NSUInteger)userID;

/**
 * @brief The host can use this function to demand the user to start video.
 * @param userID The user ID who needs to turn on video in the meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only host can run the function in the meeting.
 */
- (BOOL)askUserStartVideo:(NSUInteger)userID;

/**
 * @brief Gets the size of the user's video.
 * @param userID The user ID in the meeting. userID should be 0 when not in meeting.
 * @return The size of the user's video.
 */
- (CGSize)getUserVideoSize:(NSUInteger)userID;

#pragma mark Camera Related
/**
 * @brief Queries if the user is using back camera.
 * @return YES if using back camera. Otherwise, NO.
 */
- (BOOL)isBackCamera;

/**
 * @brief Switches the camera of the current user in the local device.
 * @return The result of operation. 
 */
- (MobileRTCCameraError)switchMyCamera;

/**
 * @brief Gets the camera device list.
 * @return If the function succeeds, it returns an NSArray of MobileRTCCameraDevice objects. Otherwise, this function fails and returns nil.
 * @warning Only iOS 17.0 or above and iPad device can get the external camera devices.
 */
- (NSArray <MobileRTCCameraDevice *>* _Nullable)getCameraDeviceList;

/**
 * @brief Switches camera by camera ID.
 * @param cameraId The target camera ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)switchCamera:(NSString * _Nullable)cameraId;

/**
 * @brief Gets the current camera device in use.
 * @return If the function succeeds, it returns a MobileRTCCameraDevice object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCCameraDevice * _Nullable)getSelectedCamera;

/**
 * @brief Zooms the camera in or out.
 * @param velocity The zoom velocity.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Please refer to the MobileRTCCameraDevice class. The value of maxZoomFactor means the camera's maximum zoom factor. The value of videoZoomFactorUpscaleThreshold means the maximum scale of optical zoom factor.
 */
- (BOOL)zoomCamera:(CGFloat)velocity;

/**
 * @brief Sets the video quality preference that automatically adjusts the user's video to prioritize frame rate vs. resolution based on the current bandwidth available.
 * @param preferenceSetting The video quality preference.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning This only supports the raw data render model.
 */
- (MobileRTCSDKError)setVideoQualityPreference:(MobileRTCVideoPreferenceSetting * _Nullable)preferenceSetting;

/**
 * @brief Queries if the account supports follow host video order feature.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isSupportFollowHostVideoOrder;

/**
 * @brief Queries if follow host video order is currently on.
 * @return YES if follow. Otherwise, NO.
 */
- (BOOL)isFollowHostVideoOrderOn;

/**
 * @brief Gets the host video order list.
 * @return UserId array, or nil if the host has not updated the video order.
 * @note This method only returns the order list based on the host's video order (hostVideoOrder).
 * If the host has not updated the video order, this list will be empty.
 */
- (NSArray <NSNumber *>* _Nullable)getVideoOrderList;

/**
 * @brief Gets the local video order list.
 * @return UserId array, or nil if the local video order hasn't been received yet.
 * @note This list reflects the local video order as last received via the onLocalVideoOrderUpdated callback.
 * The local video order is updated whenever onLocalVideoOrderUpdated is triggered.
 */
- (NSArray <NSNumber *>* _Nullable)getLocalVideoOrderList;

/**
 * @brief Stops the incoming video.
 * @param enable YES to enable to stop incoming video. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)stopIncomingVideo:(BOOL)enable;

/**
 * @brief Determines if the incoming video is stopped.
 * @return YES if the incoming video is stopped. Otherwise, NO.
 */
- (BOOL)isIncomingVideoStoped;

/**
 * @brief Determines if the incoming video is supported.
 * @return YES if the incoming video is supported. Otherwise, NO.
 */
- (BOOL)isStopIncomingVideoSupported;

/**
 * @brief Enables my video auto-framing.
 * @param setting The auto-framing parameter.
 * @param mode The auto-framing mode.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableVideoAutoFraming:(MobileRTCAutoFramingParameter * _Nullable)setting forMode:(MobileRTCAutoFramingMode)mode;

/**
 * @brief Stops video auto-framing.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)disableVideoAutoFraming;

/**
 * @brief Determines whether auto-framing is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isVideoAutoFramingEnabled;

/**
 * @brief Gets the current mode of auto-framing.
 * @return The current auto-framing mode.
 */
- (MobileRTCAutoFramingMode)getVideoAutoFramingMode;

/**
 * @brief Sets the mode of auto-framing when auto-framing is enabled.
 * @param mode The auto-framing mode.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setVideoAutoFramingMode:(MobileRTCAutoFramingMode)mode;

/**
 * @brief Sets the zoom in ratio of auto-framing when auto-framing is enabled.
 * @param ratio The zoom in ratio of auto-framing. Valid range of ratio: A. mode is "MobileRTCAutoFramingMode_CenterCoordinates", 1~10. B. mode is "MobileRTCAutoFramingMode_FaceRecognition", 0.1~10.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setVideoAutoFramingRatio:(CGFloat)ratio;

/**
 * @brief Sets the fail strategy of face recognition when auto-framing is enabled (mode is \link MobileRTCAutoFramingMode_FaceRecognition \endlink).
 * @param strategy The fail strategy of face recognition.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setFaceRecognitionFailStrategy:(MobileRTCFaceRecognitionFailStrategy)strategy;

/**
 * @brief Gets the setting of auto-framing.
 * @param mode The auto-framing mode.
 * @return If the function succeeds, it returns a MobileRTCAutoFramingParameter object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCAutoFramingParameter * _Nullable)getVideoAutoFramingSetting:(MobileRTCAutoFramingMode)mode;

/**
 * @brief Determines if alpha channel mode can be enabled.
 * @return YES if it can be enabled. Otherwise, NO. Only for host call.
 * @warning Only host can enable alpha channel.
 */
- (BOOL)canEnableAlphaChannelMode;

/**
 * @brief Enables or disables alpha channel mode.
 * @param enable YES to enable alpha channel mode. Otherwise, NO to disable it.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Only host can enable alpha channel.
 * @warning This function enables the meeting alpha channel, even if the current iOS device does not support alpha channel.
 * @warning For iOS device should be iPhone 8/8 Plus/X or above or be iPad Pro 9.7 above. OS should be iOS 11 or above.
 */
- (MobileRTCSDKError)enableAlphaChannelMode:(BOOL)enable;

/**
 * @brief Determines if alpha channel mode is enabled.
 * @return YES if in alpha channel mode. Otherwise, NO.
 */
- (BOOL)isAlphaChannelModeEnabled;

@end
