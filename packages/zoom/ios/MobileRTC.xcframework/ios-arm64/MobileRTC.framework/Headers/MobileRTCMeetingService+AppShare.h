/**
 * @file MobileRTCMeetingService+AppShare.h
 * @brief Meeting+AppShare service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @protocol MobileRTCShareActionDelegate
 * @brief The delegate protocol to receive events related to share actions.
 */
@protocol MobileRTCShareActionDelegate <NSObject>
@optional
/**
 * @brief Callback event the moment the user receives the shared content.
 */
-(void)onSharingContentStartReceiving;
/**
 * @brief The callback is triggered before the shared action is destroyed.
 * @param sharingID Specify the sharing ID.
 * @note The specified shared action is  destroyed once the function calls end. The user should complete the operations related to the shared action before the function calls end.
 */
-(void)onActionBeforeDestroyed:(NSUInteger)sharingID;

@end

/**
 * @class MobileRTCShareAction
 * @brief Representing a share action, including subscription and rendering controls.
 */
@interface MobileRTCShareAction : NSObject
/**
 * @brief Sets the share action delegate.
 * @param delegate The share action delegate.
 */
- (void)setShareActionDelegate:(id<MobileRTCShareActionDelegate>_Nullable)delegate;

/**
 * @brief Gets active share view from share action.
 * @return If the function succeeds, it returns the active share view. Otherwise, this function fails and returns nil.
 */
- (UIView *_Nullable)getActiveShareView;
/**
 * @brief Gets the sharing ID.
 * @return If the function succeeds, the return value is the sharing ID. Otherwise the function fails, and the return value is ZERO (0).
 */
- (NSUInteger)getShareID;
/**
 * @brief Gets the name of the sharing user.
 * @return The name.
 */
- (NSString*_Nullable)getSharingUserName;
/**
 * @brief Subscribes to the sharing content.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)subscribe;

/**
 * @brief Unsubscribes from the sharing content.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)unsubscribe;

@end

/**
 * @class MobileRTCSSharingSourceInfo
 * @brief ZOOM share information class.
 */
@interface MobileRTCSSharingSourceInfo: NSObject
/**
 * @brief Gets the user ID of the sharing Source Info.
 * @return If the function succeeds, the return value is the User ID. Otherwise the function fails, and the return value is ZERO (0).
 */
- (NSUInteger)getUserID;
/**
 * @brief Gets the sharing source ID.
 * @return If the function succeeds, the return value is the sharing Source ID. Otherwise the function fails, and the return value is ZERO (0).
 */
- (NSUInteger)getShareSourceID;
/**
 * @brief Gets the content type of the sharing Source Info.
 * @note In early share status callbacks, for example, @c Sharing_Self_Send_Begin or @c Sharing_Other_Share_Begin,
 *       this value can be @c MobileRTCShareContentType_UNKNOWN temporarily.
 *       The finalized content type is available after -onShareContentChanged: is received.
 * @return The sharing Source Info content type.
 */
- (MobileRTCShareContentType)getContentType;
/**
 * @brief Gets the status of the sharing Source Info.
 * @return The sharing Source Info status.
 */
- (MobileRTCSharingStatus)getStatus;
/**
 * @brief Determines if the sharing optimize status is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isEnableOptimizingVideoSharing;
@end

/**
 * @brief Starts an App share meeting.
 */
@interface MobileRTCMeetingService (AppShare)
/**
 * @brief Queries if the current meeting was started with App Share.
 * @return YES if the meeting was started by App Share. Otherwise, NO.
 */
- (BOOL)isDirectAppShareMeeting;

/**
 * @brief Determines whether the current meeting can start sharing.
 * @return If the function succeeds, it returns MobileRTCCannotShareReasonType_None. Otherwise, this function returns the reason that no one can start sharing. See [MobileRTCCannotShareReasonType].
 */
- (MobileRTCCannotShareReasonType)canStartShare;

/**
 * @brief Shares content with the current view.
 * @param view The view to share.
 * @warning View, recommend to pass a single UIView object, e.g., UIView, UIImageView, or WKWebView.
 * @warning The UIView passed should not have any child subviews.
 */
- (void)appShareWithView:(nonnull id)view;

/**
 * @brief Starts App Share.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)startAppShare;

/**
 * @brief Stops App Share.
 */
- (void)stopAppShare;

/**
 * @brief Notifies the current user if sharing has started.
 * @return YES if the current user is sharing. Otherwise, NO.
 */
- (BOOL)isStartingShare;

/**
 * @brief Notifies the current user if they are currently viewing an App Share.
 * @return YES if the user is viewing the share. Otherwise, NO.
 */
- (BOOL)isViewingShare;

/**
 * @brief Notifies the current user if annotation is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isAnnotationOff;

/**
 * @brief Suspends App Sharing.
 * @param suspend YES if sharing should be suspended. Otherwise, NO to resume sharing.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning When the customer goes to share content, consider the effects on device performance, and use this method to pause sharing when UI changes, and resume sharing when UI changes stop. See WebViewController.m in the sample project.
 */
- (BOOL)suspendSharing:(BOOL)suspend;
/**
 * @brief Determines if sharing device audio is supported.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isSupportShareAudio;
/**
 * @brief Enables or disables the sending of device audio.
 * @param enableAudio YES to enable device audio sharing. Otherwise, NO to disable.
 */
- (void)setShareAudio:(BOOL)enableAudio;

/**
 * @brief Gets the state of device audio sharing.
 * @return YES if the device is currently audio sharing. Otherwise, NO.
 */
- (BOOL)isSharedAudio;

/**
 * @brief Gets the state of device screen sharing.
 * @return YES if the device is currently screen sharing. Otherwise, NO.
 * @warning When the onSinkMeetingActiveShare callback returns, the developer needs to judge the share screen state.
 */
- (BOOL)isDeviceSharing;

/**
 * @brief Determines if optimizing share video is supported.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isSupportOptimizeForSharedVideo;
/**
 * @brief Enables or disables optimizing share video.
 * @param enableVideo YES to enable. Otherwise, NO.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)enableOptimizeForSharedVideo:(BOOL)enableVideo;
/**
 * @brief Gets the state of optimizing share video.
 * @return YES if optimizing share video is enabled. Otherwise, NO.
 */
- (BOOL)isEnableOptimizeForSharedVideo;

/**
 * @brief Allows or disallows participants to share whiteboard.
 * @param allow YES to allow. Otherwise, NO to disallow.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)allowParticipantsToShareWhiteBoard:(BOOL)allow;

/**
 * @brief Queries if participants are allowed to share whiteboard.
 * @return YES if allowed. Otherwise, NO.
 */
- (BOOL)isParticipantsShareWhiteBoardAllowed;

/**
 * @brief Gets the list of sharing source info.
 * @param userID The user ID who is sharing.
 * @return If the function succeeds, it returns an NSArray of MobileRTCSSharingSourceInfo objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCSSharingSourceInfo*> *_Nullable)getSharingSourceInfoList:(NSInteger)userID;

/**
 * @brief Sets sharing types for the host or co-host in the meeting.
 * @param shareType Custom setting types of ZOOM SDK sharing.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
-(MobileRTCSDKError)setShareSettingType:(MobileRTCShareSettingType)shareType;

/**
 * @brief Gets the sharing types for the host or co-host in the meeting.
 * @return MobileRTCShareSettingType.
 */
- (MobileRTCShareSettingType)getShareSettingType;

@end
