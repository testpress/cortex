/**
 * @file MobileRTCMeetingService+Whiteboard.h
 * @brief Meeting+Whiteboard service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @brief Whiteboard of MobileRTCMeetingService
 */
@interface MobileRTCMeetingService (Whiteboard)

/**
 * @brief Determines whether the current meeting supports the whiteboard.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)isSupportWhiteBoard;

/**
 * @brief Determines whether the current meeting can start sharing the whiteboard.
 * @return If the function succeeds, it returns MobileRTCCannotShareReasonType_None. Otherwise, this function returns the reason that no one can start sharing the whiteboard.
 */
- (MobileRTCCannotShareReasonType)canStartShareWhiteboard;

/**
 * @brief Determines whether the current user can create a new whiteboard.
 * @return YES if the current user can create a new whiteboard. Otherwise, this function returns NO.
 */
- (BOOL)canStartShareNewWhiteboard;

/**
 * @brief Starts sharing a new whiteboard.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning The function is only for Custom UI.
 */
- (MobileRTCSDKError)startNewWhiteboardShare;

/**
 * @brief Determines whether the current user can stop sharing the new whiteboard.
 * @return YES if the current user can stop sharing the new whiteboard. Otherwise, this function returns NO.
 */
- (BOOL)canStopWhiteboardShare;

/**
 * @brief When self sharing whiteboard, stop self; when self not sharing, stop all others.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note Valid only for user custom interface mode.
 */
- (MobileRTCSDKError)stopWhiteboardShare;

/**
 * @brief Sets parent view controller for whiteboard board view and whiteboard canvas.
 * @param parentVC The view controller used to present ViewController. If parentVC is nil, whiteboard will dismiss.
 * @warning The function is only for Custom UI. This method is a prerequisite for using whiteboard. Suggest to call this function in "onMeetingStateChange:" for inMeeting status.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @deprecated Not maintained anymore. Use \link showWhiteboardByParentViewCtroller: \endlink instead.
 */
- (MobileRTCSDKError)setParentViewCtroller:(UIViewController* _Nullable)parentVC DEPRECATED_MSG_ATTRIBUTE("Not maintain anymore,Use showWhiteboardByParentViewCtroller instead");

/**
 * @brief Shows whiteboard or DashboardView. Need to set parent view controller. If whiteboard is active \link MobileRTCWhiteboardStatus_Started \endlink, that can show active whiteboard.
 * @param parentVC The view controller used to present ViewController. If parentVC is nil, whiteboard will dismiss.
 * @warning The function is only for Custom UI. This method is a prerequisite for using whiteboard. Suggest to call this function in "onWhiteboardStatusChanged:" for whiteboard status.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)showWhiteboardByParentViewCtroller:(UIViewController* _Nullable)parentVC;

/**
 * @brief Shows the dashboard web view window.
 * @warning The function is only for Custom UI.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)showDashboardView;

/**
 * @brief Dismisses whiteboard or dashboard.
 * @warning The function is only for Custom UI.
 */
- (void)dismissWhiteboardOrDashboard;

/**
 * @brief Sets the option for who can share a whiteboard.
 * @param option The new setting for who can share a whiteboard.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setWhiteboardShareOption:(MobileRTCWhiteboardShareOption)option;

/**
 * @brief Gets the option for who can share a whiteboard.
 * @return The setting option for who can share a whiteboard.
 */
- (MobileRTCWhiteboardShareOption)getWhiteboardShareOption;

/**
 * @brief Sets the option for who can initiate a new whiteboard.
 * @param option The setting option for who can initiate a new whiteboard.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setWhiteboardCreateOption:(MobileRTCWhiteboardCreateOption)option;

/**
 * @brief Gets the option for who can initiate a new whiteboard.
 * @return The setting option for who can initiate a new whiteboard.
 */
- (MobileRTCWhiteboardCreateOption)getWhiteboardCreateOption;

/**
 * @brief Enables or disables the participants to create a new whiteboard without the host in the meeting.
 * @param enable YES to enable. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableParticipantsCreateWithoutHost:(BOOL)enable;

/**
 * @brief Determines whether enabling the participants to create a new whiteboard without the host in the meeting is enabled.
 * @return YES if they have this permission. Otherwise, NO.
 */
- (BOOL)isParticipantsCreateWithoutHostEnabled;

#pragma mark - UI setting -
/**
 * @brief Enables or disables the new Zoom Whiteboard feature (different from Classic Whiteboard). This feature is enabled by default.
 * @param disabled YES to disable. Otherwise, NO.
 * @warning The function is only for Zoom UI.
 */
- (void)disableCloudWhiteboard:(BOOL)disabled;

/**
 * @brief Allows the developer to customize the URL of cloud whiteboard feedback.
 * @param feedbackUrl The customized URL.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)setCloudWhiteboardFeedbackUrl:(nullable NSString *)feedbackUrl;

/**
 * @brief Sets the Helper center button's visibility on cloud whiteboard. Default is displaying.
 * @param hide YES to hide. Otherwise, NO to display.
 */
- (void)hideCloudWhiteboardHelperCenterButton:(BOOL)hide;

/**
 * @brief Sets the Open in browser button's visibility on cloud whiteboard. Default is displaying.
 * @param hide YES to hide. Otherwise, NO to display.
 */
- (void)hideCloudWhiteboardOpenInBrowserButton:(BOOL)hide;

/**
 * @brief Hides feedback button on cloud whiteboard.
 * @param hide YES to hide. Otherwise, NO to display.
 */
- (void)hideFeedbackButtonOnCloudWhiteboard:(BOOL)hide;

/**
 * @brief Hides share button on cloud whiteboard.
 * @param hide YES to hide. Otherwise, NO to display.
 */
- (void)hideShareButtonOnCloudWhiteboard:(BOOL)hide;

/**
 * @brief Sets About button's visibility on the cloud whiteboard. Default is displaying.
 * @param hide YES to hide. Otherwise, NO to display.
 */
- (void)hideAboutButtonOnCloudWhiteboard:(BOOL)hide;

#pragma mark - legal related -
/**
 * @brief Determines if whiteboard legal notice is available.
 * @return YES if notice is available. Otherwise, NO.
 */
- (BOOL)isWhiteboardLegalNoticeAvailable;

/**
 * @brief Gets whiteboard legal notices message.
 * @return The whiteboard legal notices message as a string.
 */
- (NSString *_Nullable)getWhiteboardLegalNoticesPrompt;

/**
 * @brief Gets whiteboard legal notices detailed description.
 * @return The whiteboard legal notices detailed description.
 */
- (NSString *_Nullable)getWhiteboardLegalNoticesExplained;

/**
 * @brief Determines if other user is sharing whiteboard.
 * @return YES if sharing. Otherwise, NO.
 */
- (BOOL)isOtherSharingWhiteboard;

/**
 * @brief Determines if the current user is sharing whiteboard.
 * @return YES if sharing. Otherwise, NO.
 */
- (BOOL)isSharingWhiteboardOut;
@end

