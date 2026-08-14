/**
 * @file MobileRTCMeetingSettings.h
 * @brief Configuration settings for meeting behavior and preferences.
 */

#import <Foundation/Foundation.h>

@protocol MobileRTCMeetingSettingsDelegate;

/**
 * @class MobileRTCMeetingSettings
 * @brief A class to modify the configurations of the meeting.
 */
@interface MobileRTCMeetingSettings : NSObject

/**
 * @brief Shows or hides meeting title in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingTitleHidden;

/**
 * @brief Shows or hides meeting password in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingPasswordHidden;

/**
 * @brief Shows or hides the END/LEAVE MEETING button in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingLeaveHidden;

/**
 * @brief Shows or hides AUDIO button in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingAudioHidden;

/**
 * @brief Shows or hides VIDEO button in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingVideoHidden;

/**
 * @brief Shows or hides INVITE button in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingInviteHidden;

/**
 * @brief Shows or hides INVITE link in the meeting info view.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingInviteUrlHidden;

/**
 * @brief Shows or hides Chat in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingChatHidden;

/**
 * @brief Shows or hides PARTICIPANT button in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingParticipantHidden;

/**
 * @brief Shows or hides SHARE button in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingShareHidden;

/**
 * @brief Shows or hides MORE button in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL meetingMoreHidden;

/**
 * @brief Shows or hides the bar on the top of view in the meeting.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL topBarHidden;

/**
 * @brief Shows or hides bar at the bottom of the view in the meeting.
 * @warning The bar at the bottom of the view is available on iPhone.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL bottomBarHidden;

/**
 * @brief Shows or hides disconnect audio button.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL disconnectAudioHidden;

/**
 * @brief Shows or hides record button.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL recordButtonHidden;

/**
 * @brief YES to change thumbnail video layout while viewing a share in the meeting. Otherwise, NO.
 * @warning If you set it to YES, the video of attendees will be placed at the right of the landscape (the device screen is oriented horizontally) or the bottom of portrait (the device screen is oriented vertically) apart from the shared content, which means the video will not cover the content. If you set it to NO, it will show only the video of active speaker and the video will be placed in the bottom right of the screen.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL thumbnailInShare;

/**
 * @brief Shows or hides LEAVE MEETING item for the host in the pop up view after clicking the end/leave meeting button in the meeting bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL hostLeaveHidden;

/**
 * @brief Shows or hides the hint message in the meeting. The hint message is on the top bar.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL hintHidden;

/**
 * @brief Shows or hides the tips message in the meeting. The tips message is on the bottom of the screen.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL tipsHidden;

/**
 * @brief Shows or hides the waiting HUD while starting or joining a meeting.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL waitingHUDHidden;

/**
 * @brief Shows or hides "Call in Room System" item in Invite H.323/SIP Room System.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL callinRoomSystemHidden;

/**
 * @brief Shows or hides "Call out Room System" item in Invite H.323/SIP Room System.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL calloutRoomSystemHidden;

/**
 * @brief Shows or hides "Enter Host Key to Claim Host" item in Menu More.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL claimHostWithHostKeyHidden;

/**
 * @brief Shows or hides CLOSED CAPTION in a meeting.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL closeCaptionHidden;

/**
 * @brief Shows or hides Q&A button in webinar meeting.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL qaButtonHidden;

/**
 * @brief Shows or hides "Promote to Panelist" in webinar meeting.
 * @warning Only host or co-host can see the option in webinar meeting's participants.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL promoteToPanelistHidden;

/**
 * @brief Shows or hides "Change to Attendee" in webinar meeting.
 * @warning Only host or co-host can see the option in webinar meeting's participants.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL changeToAttendeeHidden;

/**
 * @brief Enables or disables Proximity Sensors Monitoring in a meeting.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL proximityMonitoringDisable;

/**
 * @brief Enables or disables hiding the recover meeting dialog in Zoom UI mode.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL hideRecoverMeetingDialog;

/**
 * @brief Enables or disables hiding the stop live stream dialog in Zoom UI mode.
 * @warning This function is only available in Zoom UI mode.
 */
@property (assign, nonatomic) BOOL hideStopLiveStreamDialog;

/**
 * @brief Hides feedback button on cloud whiteboard.
 * @deprecated Use \link hideFeedbackButtonOnCloudWhiteboard: \endlink in MeetingService instead.
 */
@property (assign, nonatomic) BOOL hideFeedbackButtonOnCloudWhiteboard DEPRECATED_MSG_ATTRIBUTE("Use hideFeedbackButtonOnCloudWhiteboard: in MeetingService instead");

/**
 * @brief Hides share button on cloud whiteboard.
 * @deprecated Use \link hideShareButtonOnCloudWhiteboard: \endlink in MeetingService instead.
 */
@property (assign, nonatomic) BOOL hideShareButtonOnCloudWhiteboard DEPRECATED_MSG_ATTRIBUTE("Use hideShareButtonOnCloudWhiteboard: in MeetingService instead");

/**
 * @brief About button's visibility on the cloud whiteboard. The default is displaying.
 * @deprecated Use \link hideAboutButtonOnCloudWhiteboard: \endlink in MeetingService instead.
 */
@property (assign, nonatomic) BOOL hideAboutButtonOnCloudWhiteboard DEPRECATED_MSG_ATTRIBUTE("Use hideAboutButtonOnCloudWhiteboard: in MeetingService instead");

/**
 * @brief Queries if the user joins meeting with audio device.
 * @return YES if the audio device is automatically connected. Otherwise, NO.
 */
- (BOOL)autoConnectInternetAudio;

/**
 * @brief Sets to auto-connect the audio when the user joins the meeting.
 * @param connected The option value.
 */
- (void)setAutoConnectInternetAudio:(BOOL)connected;

/**
 * @brief Queries if the user's audio is muted when they join the meeting.
 * @return YES if muted. Otherwise, NO.
 */
- (BOOL)muteAudioWhenJoinMeeting;

/**
 * @brief Sets to mute the user's audio when they join the meeting.
 * @param muted YES to mute the audio. Otherwise, NO.
 */
- (void)setMuteAudioWhenJoinMeeting:(BOOL)muted;

/**
 * @brief Queries if the user's video is muted when they join the meeting.
 * @return YES if muted. Otherwise, NO.
 */
- (BOOL)muteVideoWhenJoinMeeting;

/**
 * @brief Sets to mute the user's video when they join the meeting.
 * @param muted YES to mute the video. Otherwise, NO.
 */
- (void)setMuteVideoWhenJoinMeeting:(BOOL)muted;

/**
 * @brief Queries if Touch up my appearance is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)faceBeautyEnabled;

/**
 * @brief Enables or disables Touch up my appearance.
 * @param enable YES to enable. Otherwise, NO.
 */
- (void)setFaceBeautyEnabled:(BOOL)enable;

/**
 * @brief Determines if mirror effect is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isMirrorEffectEnabled;

/**
 * @brief Enables or disables mirror effect.
 * @param enable YES to enable. Otherwise, NO to disable.
 */
- (void)enableMirrorEffect:(BOOL)enable;

/**
 * @brief Queries if driving mode is disabled.
 * @return YES if disabled. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)driveModeDisabled;

/**
 * @brief Sets to disable the Driving mode in the meeting.
 * @param disabled YES to disable. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)disableDriveMode:(BOOL)disabled;

/**
 * @brief Queries if Gallery View is disabled.
 * @return YES if disabled. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)galleryViewDisabled;

/**
 * @brief Sets to disable the Gallery View in the meeting.
 * @param disabled YES to disable. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)disableGalleryView:(BOOL)disabled;

/**
 * @brief Enables or disables the new Zoom Whiteboard feature (different from Classic Whiteboard). This feature is enabled by default.
 * @param disabled YES to disable. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 * @deprecated Use \link disableCloudWhiteboard: \endlink in MeetingService instead.
 */
- (void)disableCloudWhiteboard:(BOOL)disabled DEPRECATED_MSG_ATTRIBUTE("Use disableCloudWhiteboard: in MeetingService instead");

/**
 * @brief Queries if it is disabled to call in.
 * @return YES if disabled. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)callInDisabled;

/**
 * @brief Sets to disable the incoming calls.
 * @param disabled The option value.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)disableCallIn:(BOOL)disabled;

/**
 * @brief Queries if it is disabled to call out.
 * @return YES if disabled. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)callOutDisabled;

/**
 * @brief Sets to disable the outgoing calls.
 * @param disabled The option value.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)disableCallOut:(BOOL)disabled;

/**
 * @brief Queries if it is disabled to Minimize Meeting.
 * @return YES if disabled. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)minimizeMeetingDisabled;

/**
 * @brief Sets to disable the Minimize Meeting.
 * @param disabled The option value.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)disableMinimizeMeeting:(BOOL)disabled;

/**
 * @brief Queries if it is disabled free meeting upgrade tips.
 * @return YES if disabled. Otherwise, NO.
 */
- (BOOL)freeMeetingUpgradeTipsDisabled;

/**
 * @brief Sets to disable free meeting upgrade tips.
 * @param disabled The option value.
 */
- (void)disableFreeMeetingUpgradeTips:(BOOL)disabled;

/**
 * @brief Queries meeting setting of speaker off when present meeting.
 * @return YES if speaker is off. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)speakerOffWhenInMeeting;

/**
 * @brief Sets speaker off. The default value is NO. Set to NO when not used.
 * @param speakerOff YES to set speaker off. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)setSpeakerOffWhenInMeeting:(BOOL)speakerOff;

/**
 * @brief Queries show meeting elapse time.
 * @return YES if show meeting elapse time. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)showMyMeetingElapseTime;

/**
 * @brief Enables or disables showing meeting elapse time.
 * @param enable YES to show meeting elapse time. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)enableShowMyMeetingElapseTime:(BOOL)enable;

/**
 * @brief Queries if mic original input is enabled.
 * @return YES if mic original input is enabled. Otherwise, NO.
 */
- (BOOL)micOriginalInputEnabled;

/**
 * @brief Enables or disables mic original input.
 * @param enable YES to enable mic original input. Otherwise, NO.
 */
- (void)enableMicOriginalInput:(BOOL)enable;

/**
 * @brief Queries if reactions on MeetingUI is hidden.
 * @return YES if reactions on MeetingUI is hidden. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)reactionsOnMeetingUIHidden;

/**
 * @brief Sets the visibility of reaction on meeting UI. The default is displaying.
 * @param hidden YES to hide reaction emotion. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)hideReactionsOnMeetingUI:(BOOL)hidden;

/**
 * @brief Queries if it is disabled to show video preview when joining meeting.
 * @return YES if disabled. Otherwise, NO.
 * @warning If showVideoPreviewWhenJoinMeeting is enabled, customized UI mode must implements the callback of onJoinMeetingInfoRequired:.
 */
- (BOOL)showVideoPreviewWhenJoinMeetingDisabled;

/**
 * @brief Sets to disable show video preview when joining meeting.
 * @param disabled The option value.
 * @warning If showVideoPreviewWhenJoinMeeting is enabled, customized UI mode must implements the callback of onJoinMeetingInfoRequired:.
 */
- (void)disableShowVideoPreviewWhenJoinMeeting:(BOOL)disabled;

/**
 * @brief Queries if it is disabled for virtual background.
 * @return YES if disabled. Otherwise, NO.
 */
- (BOOL)virtualBackgroundDisabled;

/**
 * @brief Sets to disable virtual background.
 * @param disabled The option value.
 */
- (void)disableVirtualBackground:(BOOL)disabled;

/**
 * @brief Pre-populates webinar registration info.
 * @param email The registration email address.
 * @param username The registration username.
 */
- (void)prePopulateWebinarRegistrationInfo:(nonnull NSString *)email username:(nonnull NSString *)username;

/**
 * @brief Sets the webinar register information dialog to hide or display.
 * @param hide YES to hide the dialog. Otherwise, NO.
 */
- (void)setHideRegisterWebinarInfoWindow:(BOOL)hide;

/**
 * @brief Gets whether the webinar register information dialog is hidden or displayed.
 * @return YES if hidden. Otherwise, NO.
 */
- (BOOL)hideRegisterWebinarInfoWindow;

/**
 * @brief Sets the webinar username input dialog to hide or display. If hide webinar user name input dialog, should handle \link MobileRTCMeetingServiceDelegate::onWebinarNeedInputScreenName: \endlink. \link MobileRTCWebinarInputScreenNameHandler:: inputName: \endlink.
 * @param hide YES to hide the dialog. Otherwise, NO.
 */
- (void)setHideWebinarNameInputWindow:(BOOL)hide;

/**
 * @brief Gets whether the webinar username input dialog is hidden or displayed.
 * @return YES if hidden. Otherwise, NO.
 */
- (BOOL)isHideWebinarNameInputWindow;

/**
 * @brief Sets to disable confidential watermark.
 * @param disable The option value.
 * @return YES if confidential watermark is disabled. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)disableConfidentialWatermark:(BOOL)disable;

/**
 * @brief Queries if it is disabled for copy meeting URL.
 * @return YES if disabled. Otherwise, NO.
 * @warning This function is only available in Zoom UI mode.
 */
- (BOOL)copyMeetingUrlDisabled;

/**
 * @brief Sets to disable copy meeting URL in the meeting info view.
 * @param disabled The option value.
 * @warning This function is only available in Zoom UI mode.
 */
- (void)disableCopyMeetingUrl:(BOOL)disabled;

/**
 * @brief Sets emoji reaction skin tone.
 * @param skinTone The reaction skin tone.
 * @return If the function succeeds, it will return MobileRTCMeetError_Success. Otherwise the function fails.
 * @warning This function is only available in Zoom UI mode.
 */
- (MobileRTCMeetError)setReactionSkinTone:(MobileRTCEmojiReactionSkinTone)skinTone;

/**
 * @brief Gets reaction skin tone.
 * @return The skin tone for emoji reaction.
 * @warning This function is only available in Zoom UI mode.
 */
- (MobileRTCEmojiReactionSkinTone)reactionSkinTone;

/**
 * @brief Disables the action of clear WebView's cache.
 * @param disabled YES to disable the clear action. Otherwise, NO.
 */
- (void)disableClearWebKitCache:(BOOL)disabled;

/**
 * @brief Queries if the action of clear WebView's cache is disabled.
 * @return YES if the action of clear WebView's cache is disabled. Otherwise, NO.
 */
- (BOOL)isDisabledClearWebKitCache;

/**
 * @brief Queries if the option HIDE NON-VIDEO PARTICIPANTS is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isHideNoVideoUsersEnabled;

/**
 * @brief Sets whether to enable the option HIDE NON-VIDEO PARTICIPANTS.
 * @param enabled YES to enable. Otherwise, NO.
 */
- (void)setHideNoVideoUsersEnabled:(BOOL)enabled;

/**
 * @brief Enables or disables to hide the user's own view. isHidden YES indicates to enable to hide the user's own view.
 * @param isHidden YES to enable to hide the user's own view. Otherwise, NO.
 */
- (void)enableHideSelfView:(BOOL)isHidden;

/**
 * @brief Gets the flag to enable or disable to hide the user's own view.
 * @return YES if hide self view. Otherwise, NO.
 */
- (BOOL)isHideSelfViewEnabled;

/**
 * @brief Sets the visibility of request local recording privilege dialog when attendee requests local recording privilege. Default is displaying.
 * @param bHide YES to hide the dialog. Otherwise, NO.
 */
- (void)hideRequestRecordPrivilegeDialog:(BOOL)bHide;

/**
 * @brief Gets the flag of auto enter Picture-in-Picture Mode for video calls.
 * @return YES if auto enter Picture-in-Picture Mode. Otherwise, NO.
 */
- (BOOL)videoCallPictureInPictureEnabled;

/**
 * @brief Sets whether to close the current sharing of another user without prompt and directly beginning a new sharing content by the closer. Default value: NO (prompt).
 * @param enable YES to indicate no prompt. Otherwise, NO.
 */
- (void)enableGrabShareWithoutReminder:(BOOL)enable;

/**
 * @brief Sets the meeting input user info dialog to hide or display.
 * @param hide YES to hide the dialog. Otherwise, NO.
 */
- (void)setHideMeetingInputUserInfoWindow:(BOOL)hide;

/**
 * @brief Gets whether the meeting input user info dialog is hidden or displayed.
 * @return YES if hidden. Otherwise, NO.
 */
- (BOOL)isHideMeetingInputUserInfoWindow;

/**
 * @brief Queries if this device supports CenterStage Mode.
 * @return YES if supported. Otherwise, NO.
 * @warning Only iPad of OS version above 14.5 can use this feature.
 */
- (BOOL)isCenterStageModeSupported;

/**
 * @brief Enables or disables CenterStage Mode. This is disabled by default.
 * @param enable YES to enable. Otherwise, NO.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)enableCenterStageMode:(BOOL)enable;

/**
 * @brief Queries if CenterStage Mode is enabled by MobileRTC.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isEnabledCenterStageMode;
/**
 * @brief Enables or disables echo cancellation.
 * @param enable YES to enable. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableEchoCancellation:(BOOL)enable;

/**
 * @brief Determines if echo cancellation is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isEchoCancellationOn;

/**
 * @brief Determines if the meeting supports echo cancellation.
 * @return YES if supported. Otherwise, NO. Only use this feature when enabled original sound called: "enableMicOriginalInput:".
 */
- (BOOL)isSupportEchoCancellation;


/**
 * @brief Sets the confirm start archive dialog to hide or display.
 * @param hide YES to hide the dialog. Otherwise, NO.
 * @warning If hide confirm start archive dialog when joining meeting, should handle the 'MobileRTCArchiveConfrimHandle'.
 */
- (void)setHideConfirmStartArchiveDialog:(BOOL)hide;

/**
 * @brief Gets whether the confirm start archive dialog is hidden or displayed.
 * @return YES if hidden. Otherwise, NO.
 */
- (BOOL)isHideConfirmStartArchiveDialog;

/**
 * @brief Enables or disables canceling the bandwidth limit. If YES is set, the network bandwidth is no longer limited, and better audio and video quality can be obtained. Bandwidth is not limited by default. If it is a WiFi network, the bandwidth is not limited, and this setting is invalid.
 * @param enable YES to enable. Otherwise, NO.
 */
- (void)enable5GHighBandWidth:(BOOL)enable;

/**
 * @brief Enables or disables zoom docs features in custom UI. This can only take effect when \link MobileRTCSDKInitContext::enableCustomizeMeetingUI \endlink is true. This is disabled by default. When you enable this feature, you need to handle the \link MobileRTCMeetingServiceDelegate::onDocsStatusChanged: \endlink, and subscribe the docs share with the \link MobileRTCMeetingService::showDocByParentViewCtroller: \endlink.
 * @param enable YES to enable. Otherwise, NO.
 */
- (void)enableZoomDocs:(BOOL)enable;

/**
 * @brief Enables or disables automatic dimming of video when sharing content flashes. When enabled, the video will be automatically dimmed when the shared content contains flashing elements.
 * @param enable YES to enable automatic dimming. Otherwise, NO.
 */
- (void)enableShareContentFlashDetection:(BOOL)enable;

/**
 * @brief Queries whether automatic dimming of video when sharing content flashes is enabled.
 * @return YES if the feature is enabled. Otherwise, NO.
 */
- (BOOL)isShareContentFlashDetectionEnabled;

/**
 * @brief Set the delegate to receive meeting settings events, including 3D avatar settings events.
 * @param delegate The delegate object.
 */
- (void)setDelegate:(id<MobileRTCMeetingSettingsDelegate> _Nullable)delegate;

@end
