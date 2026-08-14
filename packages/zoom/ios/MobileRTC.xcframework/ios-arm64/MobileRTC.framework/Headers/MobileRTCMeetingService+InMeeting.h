/**
 * @file MobileRTCMeetingService+InMeeting.h
 * @brief Meeting+InMeeting service functionality and management.
 * The AI Companion brand has been retired. AI-powered features are now more deeply integrated throughout Zoom Workplace. Existing APIs and SDKs that reference AI Companion will continue to function as before to ensure backward compatibility.
 */

#import <MobileRTC/MobileRTC.h>
#import <MobileRTC/MobileRTCRawLiveStreamInfo.h>

/**
 * @class MobileRTCAudioStatisticInfo
 * @brief Session audio statistic information.
 */
@interface MobileRTCAudioStatisticInfo : NSObject
/**
 * @brief This meeting's sent audio frequency in kilohertz (KHz).
 */
@property(nonatomic, assign, readonly) NSInteger  sendFrequency;
/**
 * @brief This meeting's sent audio band width.
 */
@property(nonatomic, assign, readonly) NSInteger  sendBandwidth;
/**
 * @brief This meeting's sent audio RTT.
 */
@property(nonatomic, assign, readonly) NSInteger  sendRTT;
/**
 * @brief This meeting's sent audio jitter.
 */
@property(nonatomic, assign, readonly) NSInteger  sendJitter;
/**
 * @brief This meeting's average of sent audio packet loss.
 */
@property(nonatomic, assign, readonly) CGFloat    sendPacketLossAvg;
/**
 * @brief This meeting's maximum of sent audio packet loss.
 */
@property(nonatomic, assign, readonly) CGFloat    sendPacketLossMax;
/**
 * @brief This meeting's received audio frequency in kilohertz (KHz).
 */
@property(nonatomic, assign, readonly) NSInteger  recvFrequency;
/**
 * @brief This meeting's received audio band width.
 */
@property(nonatomic, assign, readonly) NSInteger  recvBandwidth;
/**
 * @brief This meeting's received audio RTT.
 */
@property(nonatomic, assign, readonly) NSInteger  recvRTT;
/**
 * @brief This meeting's received audio jitter.
 */
@property(nonatomic, assign, readonly) NSInteger  recvJitter;
/**
 * @brief This meeting's average of received audio packet loss.
 */
@property(nonatomic, assign, readonly) CGFloat    recvPacketLossAvg;
/**
 * @brief This meeting's maximum received audio packet loss.
 */
@property(nonatomic, assign, readonly) CGFloat    recvPacketLossMax;
@end

/**
 * @class MobileRTCASVStatisticInfo
 * @brief The session video or share statistic information.
 */
@interface MobileRTCASVStatisticInfo : NSObject
/**
 * @brief This meeting's sent band width for video or sharing.
 */
@property(nonatomic, assign, readonly) NSInteger  sendBandwidth;
/**
 * @brief This meeting's sent frame rate of video or sharing.
 */
@property(nonatomic, assign, readonly) NSInteger  sendFps;
/**
 * @brief This meeting's sent video or sharing rtt data.
 */
@property(nonatomic, assign, readonly) NSInteger  sendRTT;
/**
 * @brief This meeting's sent video or /sharinge jitter data.
 */
@property(nonatomic, assign, readonly) NSInteger  sendJitter;
/**
 * @brief This meeting's average video or sharing packet loss for sent data.
 */
@property(nonatomic, assign, readonly) CGFloat    sendPacketLossAvg;
/**
 * @brief This meeting's maximum video or sharing packet loss for sent data.
 */
@property(nonatomic, assign, readonly) CGFloat    sendPacketLossMax;
/**
 * @brief This meeting's received band width for video or sharing.
 */
@property(nonatomic, assign, readonly) NSInteger  recvBandwidth;
/**
 * @brief This meeting's received frame rate for video or sharing.
 */
@property(nonatomic, assign, readonly) NSInteger  recvFps;
/**
 * @brief This meeting's received video or sharing rtt data.
 */
@property(nonatomic, assign, readonly) NSInteger  recvRTT;
/**
 * @brief This meeting's received video or sharing jitter data.
 */
@property(nonatomic, assign, readonly) NSInteger  recvJitter;
/**
 * @brief This meeting's average video or sharing packet loss for receivde data.
 */
@property(nonatomic, assign, readonly) CGFloat    recvPacketLossAvg;
/**
 * @brief This meeting's maximum video or sharing packet loss for received data.
 */
@property(nonatomic, assign, readonly) CGFloat    recvPacketLossMax;
@end

/**
 * @class MobileRTCRequestLocalRecordingPrivilegeHandler
 * @brief Process after the host receives the requirement from the user to give the local recording privilege.
 */
@interface MobileRTCRequestLocalRecordingPrivilegeHandler : NSObject
/**
 * @brief Gets the request ID.
 * @return The request ID.
 */
- (NSString * _Nullable)getRequestId;
/**
 * @brief Gets the user ID of the requester.
 * @return If the function succeeds, it returns the user ID. Otherwise, it returns 0.
 */
- (NSInteger)getRequesterId;
/**
 * @brief Gets the user name of the requester.
 * @return The user name.
 */
- (NSString * _Nullable)getRequesterName;
/**
 * @brief Allows the user to start local recording and then self-destroys.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)grantLocalRecordingPrivilege;
/**
 * @brief Denies the user permission to start local recording and then self-destroys.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)denyLocalRecordingPrivilege;

@end

/**
 * @class MobileRTCRequestStartCloudRecordingPrivilegeHandler
 * @brief Object to handle a user's request to start cloud recording.
 * @note If current user can control web setting for smart recording, they will get MobileRTCRequestStartCloudRecordingPrivilegeHandler when attendee request to start cloud recording or start cloud recording by self.
 */
@interface MobileRTCRequestStartCloudRecordingPrivilegeHandler : NSObject
/**
 * @brief Gets the user ID of the requester.
 * @return If the function succeeds, it returns the user ID. Otherwise, it returns 0.
 */
- (NSInteger)getRequesterId;
/**
 * @brief Gets the user name of the requester.
 * @return The user name.
 */
- (NSString * _Nullable)getRequesterName;
/**
 * @brief Accepts the request to start cloud recording and then self-destroys.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)grant;
/**
 * @brief Denies the request to start cloud recording and then self-destroys.
 * @param denyAll YES to deny all requests. Participants cannot send requests again until the host changes the setting. Otherwise, NO.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)deny:(BOOL)denyAll;

@end

/**
 * @class MobileRTCIndicatorHandler
 * @brief A handle that represents a meeting indicator item and allows control of its visibility.
 */
@interface MobileRTCIndicatorHandler : NSObject
/**
 * @brief Gets the indicator item ID.
 * @return The indicator item ID.
 */
- (NSString *_Nullable)getIndicatorItemId;
/**
 * @brief Gets the indicator name.
 * @return The indicator name.
 */
- (NSString *_Nullable)getIndicatorName;
/**
 * @brief Gets the indicator icon URL.
 * @return The indicator icon URL.
 */
- (NSString *_Nullable)getIndicatorIcon;
/**
 * @brief Shows indicator panel window.
 * @param containerView The view container to show app signaling panel.
 * @param originXY The origin position of app signaling panel in container view.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning OriginXY only takes effect on iPad device. Behavior of iPhone always pops up from the bottom with the device width.
 */
- (MobileRTCSDKError)showIndicatorPane:(UIView *_Nullable)containerView originPoint:(CGPoint)originXY;
/**
 * @brief Hides indicator panel window.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)hideIndicatorPanel;

@end

/**
 * @class MobileRTCLiveStreamItem
 * @brief Represents a standard live stream target with URL and description.
 */
@interface MobileRTCLiveStreamItem : NSObject
/**
 * @brief Gets the URL of the live stream meeting.
 * @return The URL of the live stream meeting.
 */
- (NSString *_Nullable)getLiveStreamURL;

/**
 * @brief Gets the descriptions of live stream.
 * @return The description of live stream.
 */
- (NSString *_Nullable)getLiveStreamURLDescription;
/**
 * @brief Gets the viewer URL of the live stream meeting.
 * @return The viewer URL of the live stream meeting.
 */
- (NSString *_Nullable)getLiveStreamViewerURL;

@end

/**
 * @brief Set to provide interfaces for meeting events.
 */
@interface MobileRTCMeetingService (InMeeting)
/**
 * @brief Queries if the current user is the host of the meeting.
 * @return YES if the current user is the host of the meeting. Otherwise, NO.
 */
- (BOOL)isMeetingHost;

/**
 * @brief Queries if the current user is the co-host of the meeting.
 * @return YES if the current user is the co-host of the meeting. Otherwise, NO.
 */
- (BOOL)isMeetingCoHost;

/**
 * @brief Queries if the current user is the webinar attendee of the meeting.
 * @return YES if the current user is the webinar attendee of the meeting. Otherwise, NO.
 * @warning Only for webinar meeting.
 */
- (BOOL)isWebinarAttendee;

/**
 * @brief Queries if the current user is the webinar panelist of the meeting.
 * @return YES if the current user is the webinar panelist of the meeting. Otherwise, NO.
 * @warning Only for webinar meeting.
 */
- (BOOL)isWebinarPanelist;

/**
 * @brief Notifies if the meeting is locked by host. Once the meeting is locked, other users out of the meeting can no longer join it.
 * @return YES if the meeting is locked by host. Otherwise, NO.
 */
- (BOOL)isMeetingLocked;

/**
 * @brief Notifies if the share is locked by host. Once the meeting is locked by the host or co-host, other users cannot share except the host or co-host.
 * @return YES if the screen share is locked by host. Otherwise, NO.
 * @deprecated Use \link -[MobileRTCMeetingService getShareSettingType] \endlink instead.
 */
- (BOOL)isShareLocked DEPRECATED_MSG_ATTRIBUTE("Use -[MobileRTCMeetingService getShareSettingType] instead");

#pragma mark - CMR Related
/**
 * @brief Notifies if the cloud recording is enabled.
 * @return YES if enabled. Otherwise, NO.
 */
- (BOOL)isCMREnabled;

/**
 * @brief Notifies if the cloud recording is in progress.
 * @return YES if the cloud recording is in progress. Otherwise, NO.
 */
- (BOOL)isCMRInProgress;

/**
 * @brief Notifies if the cloud recording is paused.
 * @return YES if the cloud recording is paused. Otherwise, NO.
 */
- (BOOL)isCMRPaused;

/**
 * @brief Pauses or resumes cloud recording in the meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)resumePauseCMR;

/**
 * @brief Turns on or off the cloud recording in the meeting.
 * @param on YES to turn on cloud recording. Otherwise, NO.
 */
- (void)turnOnCMR:(BOOL)on;

/**
 * @brief Gets current cloud recording status.
 * @return The recording status.
 */
- (MobileRTCRecordingStatus)getCloudRecordingStatus;

/**
 * @brief Sends a request to ask the host to start cloud recording.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success and the SDK sends the request. Otherwise, this function returns an error and the request is not sent.
 */
- (MobileRTCSDKError)requestStartCloudRecording;

/**
 * @brief Determines if the smart recording feature is enabled in the meeting.
 * @return YES if the feature is enabled. Otherwise, NO.
 */
- (BOOL)isSmartRecordingEnabled;


#pragma mark Meeting Info Related
/**
 * @brief Queries if the meeting is failover.
 * @return YES if failover. Otherwise, NO.
 * @warning The method is optional.
 */
- (BOOL)isFailoverMeeting;

/**
 * @brief Gets the type of current meeting.
 * @return The type of meeting.
 */
- (MobileRTCMeetingType)getMeetingType;

/**
 * @brief Queries if the meeting is Webinar.
 * @return YES if Webinar. Otherwise, NO.
 * @warning It returns NO if MobileRTCMeetingState is not equal to MobileRTCMeetingState_InMeeting.
 */
- (BOOL)isWebinarMeeting;

/**
 * @brief Sets to lock the meeting.
 * @param lock YES to lock the meeting. Otherwise, NO.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can call the function.
 */
- (BOOL)lockMeeting:(BOOL)lock;

/**
 * @brief Sets to lock the share.
 * @param lock YES to lock the share. Otherwise, NO.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can call the function.
 * @deprecated Use \link -[MobileRTCMeetingService setShareSettingType:] \endlink instead.
 */
- (BOOL)lockShare:(BOOL)lock DEPRECATED_MSG_ATTRIBUTE("Use -[MobileRTCMeetingService setShareSettingType:] instead");

/**
 * @brief Checks in-meeting network status.
 * @param type Meeting component types. Now we can only query three components network status: MobileRTCComponentType_AUDIO, MobileRTCComponentType_VIDEO, and MobileRTCComponentType_SHARE.
 * @param sending YES to query sending data. Otherwise, NO to query receiving data.
 * @return The level of network quality.
 * @warning The method is optional. You can query the network quality of audio, video, and sharing.
 */
- (MobileRTCNetworkQuality)queryNetworkQuality:(MobileRTCComponentType)type withDataFlow:(BOOL)sending;

/**
 * @brief Gets meeting audio statistics information.
 * @return If the function succeeds, it returns a MobileRTCAudioStatisticInfo object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCAudioStatisticInfo * _Nullable)getMeetingAudioStatisticInfo;

/**
 * @brief Gets meeting video statistics information.
 * @return If the function succeeds, it returns a MobileRTCASVStatisticInfo object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCASVStatisticInfo * _Nullable)getMeetingVideoStatisticInfo;

/**
 * @brief Gets meeting share statistics information.
 * @return If the function succeeds, it returns a MobileRTCASVStatisticInfo object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCASVStatisticInfo * _Nullable)getMeetingShareStatisticInfo;

/**
 * @brief Presents Zoom original Meeting Chat ViewController.
 * @param parentVC The view controller used to present ViewController.
 * @param userId The user ID of the user you would like to chat.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning If userId = 0 or nil, it will send to everyone.
 */
- (BOOL)presentMeetingChatViewController:(nonnull UIViewController*)parentVC userId:(NSInteger)userId;

/**
 * @brief Set to present Zoom original Participants ViewController.
 * @param parentVC which use to present ViewController.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)presentParticipantsViewController:(nonnull UIViewController*)parentVC;

/**
 * @brief Configure DSCP values for audio and video.
 * @param audioValue Audio values in the meeting.
 * @param videoValue Video values in the meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning The function should be invoked before meeting starts.
 */
- (BOOL)configDSCPWithAudioValue:(NSUInteger)audioValue VideoValue:(NSUInteger)videoValue;

#pragma mark Live Stream

/**
 * @brief Check if the live stream reminder is enabled.
 * @return YES means the live stream reminder is enabled.
 * @note When the live stream reminder is enabled, the new join user is notified that the meeting is at capacity but that they can.
 * @note Watch live stream with the callback \link MobileRTCMeetingServiceDelegate::onMeetingFullToWatchLiveStream: \endlink.
 * @note When the meeting user has reached the meeting capacity.
 */
- (BOOL)isLiveStreamReminderEnabled;

/**
 * @brief Check if the current user can enable/disable the live stream reminder.
 * @return YES means the current user can enable or disable the live stream reminder.
 */
- (BOOL)canEnableLiveStreamReminder;

/**
 * @brief Enable or disable the live stream reminder.
 * @param enable true means enable the live stream reminder. False means disable the live stream reminder.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
-(MobileRTCSDKError)enableLiveStreamReminder:(BOOL)enable;

/**
 * @brief Set to start Live Stream.
 * @param streamingURL The live stream URL by which you can live the meeting. 
 * @param key Stream key offered by the third platform on which you want to live stream your meeting. 
 * @param broadcastURL The URL of live stream page.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host can start live Stream successfully.
 */
- (BOOL)startLiveStreamWithStreamingURL:(nonnull NSString*)streamingURL StreamingKey:(nonnull NSString*)key BroadcastURL:(nonnull NSString*)broadcastURL;

/**
 * @brief Get live stream server URL.
 * @return The dictionary of live stream URL if the function succeeds.
 * @warning The function is available only for host.
 * @note For Facebook Live Stream Service, "facebook" as the key in Dictionary. For Workplace by Facebook Live Stream Service, "fb_workplace" as the key in Dictionary. For YouTube Live Stream Service, "youtube" as the key in Dictionary. For Custom Live Stream Service, "custom" as the key in Dictionary.
 * @deprecated Use getSupportLiveStreamItems instead.
 */
- (nullable NSDictionary*)getLiveStreamURL DEPRECATED_MSG_ATTRIBUTE("Use getSupportLiveStreamItems instead");

/**
 * @brief Get the list of live stream information items in the current meeting.
 * @return If the function succeeds, it returns an NSArray of MobileRTCLiveStreamItem objects. Otherwise, this function fails and returns nil.
 */
- (NSArray <MobileRTCLiveStreamItem*>*_Nullable)getSupportLiveStreamItems;

/**
 * @brief Get the current live stream object.
 * @return If the function succeeds, it returns a MobileRTCLiveStreamItem object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCLiveStreamItem *_Nullable)getCurrentLiveStreamItem;

/**
 * @brief Set to stop live streaming.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning The function is available only for host. 
 */
- (BOOL)stopLiveStream;

/**
 * @brief Query Whether the meeting supports raw live streams.
 * @return YES if supported, NO if not supported.
 */
- (BOOL)isRawLiveStreamSupported;

/**
 * @brief Whether the current user is able to start raw live streaming.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)canStartRawLiveStream;

/**
 * @brief Send a request to enable the SDK to start a raw live stream.
 * @param broadcastURL The broadcast URL of the live-stream.
 * @param broadcastName The broadcast name of the live-stream.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success and the SDK will send the request. Otherwise, this function returns an error and the request will not be sent.
 */
- (MobileRTCSDKError)requestRawLiveStreaming:(nonnull NSString *)broadcastURL broadcastName:(NSString *_Nullable)broadcastName ;

/**
 * @brief Start a rawData live stream.
 * @param broadcastURL The broadcast URL of the live-stream.
 * @param broadcastName The broadcast name of the live-stream.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success and the SDK will send the request. Otherwise, this function returns an error and the request will not be sent.
 */
- (MobileRTCSDKError)startRawLiveStreaming:(nonnull NSString *)broadcastURL broadcastName:(NSString *_Nullable)broadcastName;

/**
 * @brief Stop a rawData live stream.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)stopRawLiveStream;

/**
 * @brief Remove the raw live stream privilege.
 * @param userId Specify the ID of the user whose privilege will be removed.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)removeRawLiveStreamPrivilege:(NSUInteger)userId;

/**
 * @brief Get a list of current active raw live streams.
 * @return If the function succeeds, it returns an NSArray of MobileRTCRawLiveStreamInfo objects. Otherwise, this function fails and returns nil.
 */
- (NSArray<MobileRTCRawLiveStreamInfo *> * _Nullable)getRawLiveStreamingInfoList;

/**
 * @brief Get the list of users' IDs who have raw live stream privileges.
 * @return If the function succeeds, the return value is a pointer to the NSArray object.
 */
- (NSArray <NSNumber *> * _Nullable)getRawLiveStreamPrivilegeUserList;


#pragma mark Display/Hide Meeting UI
/**
 * @brief Set to show UI of meeting.
 * @param completion User can do other operations once the meeting UI comes out.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning The method does not work if you have set mobileRTCRootController via [MobileRTC setMobileRTCRootController].
 */
- (BOOL)showMobileRTCMeeting:(void (^_Nonnull)(void))completion;

/**
 * @brief Set to hide the UI of meeting.
 * @param completion User can do other operations once the meeting UI hide.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning The method does not work if you have set mobileRTCRootController via [MobileRTC setMobileRTCRootController].
 */
- (BOOL)hideMobileRTCMeeting:(void (^_Nonnull)(void))completion;

/**
 * @brief If you add a full-screen view to our zoom meeting UI, you can display the control bar by this method when the control bar is hidden.
 * @warning The zoom meeting UI is only valid, the customized UI is invalid.
 */
- (void)showMeetingControlBar;

/**
 * @brief Switch to active scene.The sequence of video frames is { drive scene(only iPhone), active scene, gallery scene(if has)}.
 * @warning The zoom meeting UI is only valid, the customized UI is invalid.
 * @warning Both the iPad and the iPhone can use this method.
 */
- (void)switchToActiveSpeaker;

/**
 * @brief Switch to gallery scene.The sequence of video frames is { drive scene(only iPhone), active scene, gallery scene(if has)}.
 * @warning The zoom meeting UI is only valid, the customized UI is invalid.
 * @warning Both the iPad and the iPhone can use this method.
 */
- (void)switchToVideoWall;

/**
 * @brief Switch to drive scene.The sequence of video frames is { drive scene(only iPhone), active scene, gallery scene(if has)}.
 * @warning The zoom meeting UI is only valid, the customized UI is invalid.
 * @warning Only iPhone can use this method.
 */
- (void)switchToDriveScene;

/**
 * @brief Show app signaling pannel in designated position of container view.
 * @param containerView the view container to show app signaling pannel.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note Only custom UI mode can use this method.
 */
- (MobileRTCSDKError)showAANPanelInView:(UIView *_Nullable)containerView;

/**
 * @brief Hide app signaling pannel.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Suggest to hide ANNPannel when device orietation changed or trait collection changed to avoid layout issues.
 */
- (MobileRTCSDKError)hideAANPanel;

/**
 * @brief Show the dynamic notice for the AI Companion panel view in the bottom of the container view.
 * @param containerView Show the AI Companion panel's dynamic notice in this view.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note Only custom UI mode can use this method.
 */
- (MobileRTCSDKError)showDynamicNoticeForAICompanionPanel:(UIView *_Nullable)containerView;

/**
 * @brief Hide dynamic notice for AI Companion panel view.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)hideDynamicNoticeForAICompanionPanel;

/**
 * @brief Get current meeting's password.
 * @return The current meeting's password.
 */
- (NSString *_Nullable)getMeetingPassword;

/**
 * @brief Call the method to show Minimize meeting when in Zoom UI meeting.
 * @warning The method only for Zoom UI.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)showMinimizeMeetingFromZoomUIMeeting;

/**
 * @brief Call the methond to back Zoom UI meeting when in minimize meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning The method only for Zoom UI.
 */
- (BOOL)backZoomUIMeetingFromMinimizeMeeting;

/**
 * @brief Query if the meeting is allow participants to rename themselves.
 * @return YES means will allow participants to rename themselves, Otherwise not.
 * @warning Only in-meeting can call the function.
 */
- (BOOL)isParticipantsRenameAllowed;

/**
 * @brief Set the meeting is allow participants to rename themselves.
 * @warning Only meeting host/co-host can call the function.
 * @warning Only in-meeting can call the function.
 */
- (void)allowParticipantsToRename:(BOOL)allow;

/**
 * @brief Query if the meeting is allow participants to unmute themselves.
 * @return YES means will allow participants to unmute themselves, Otherwise not.
 * @warning Only meeting host/co-host can call the function.
 * @warning Only in-meeting can call the function.
 */
- (BOOL)isParticipantsUnmuteSelfAllowed;

/**
 * @brief Query if the meeting is allow participants to unmute themselves.
 * @warning Only meeting host/co-host can call the function.
 * @warning Only in-meeting can call the function.
 */
- (void)allowParticipantsToUnmuteSelf:(BOOL)allow;

/**
 * @brief Allow participant to start video.
 * @param allow YES: allow, NO: disallow.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)allowParticipantsToStartVideo:(BOOL)allow;

/**
 * @brief Query is allow   participant to start video.
 * @return YES : allow, NO: disallow.
 */
- (BOOL)isParticipantsStartVideoAllowed;

/**
 * @brief Is live transcript legal notice available.
 * @return Available or not.
 */
- (BOOL)isLiveTranscriptLegalNoticeAvailable;

/**
 * @brief Get live transcript legal noticesPrompt.
 * @return Live transcript legal noticesPrompt.
 */
- (NSString *_Nullable)getLiveTranscriptLegalNoticesPrompt;

/**
 * @brief Get live transcript legal notices explained.
 * @return Live transcript legal notices explained.
 */
- (NSString *_Nullable)getLiveTranscriptLegalNoticesExplained;


/**
 * @brief Check whether the current meeting allows participants to send local recording privilege requests. It can only be used in regular meetings, not in webinar or breakout room.
 * @return YES: allow, NO: disallow.
 */
- (BOOL)isParticipantRequestLocalRecordingAllowed;

/**
 * @brief Allow participant to request local recording.
 * @param allow YES: allow, NO: disallow.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)allowParticipantsToRequestLocalRecording:(BOOL)allow;

/**
 * @brief Determines if the current user can enable participant request clould recording.
 * @return If allows participants to send request, the return value is true.
 */
- (BOOL)canEnableParticipantRequestCloudRecording;

/**
 * @brief Toggle whether  attendees can send requests for the host to start a cloud recording. This can only be used in regular meeetings.
 * @return If allows participants to send request, the return value is true.
 */
- (BOOL)isParticipantRequestCloudRecordingEnabled;

/**
 * @brief Allowing the regular attendees to send cloud recording privilege request, This can only be used in regular meeetings and webinar (no breakout rooms).
 * @param allow TRUE indicates that participantsthe are allowed  the regular attendees to send cloud recording privilege request.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)allowParticipantsToRequestCloudRecording:(BOOL)allow;

/**
 * @brief Check whether the current meeting auto-grants participants’ local recording privilege requests. It can only be used in regular meetings (not webinar or breakout room).
 * @return YES: allow, NO: disallow.
 */
- (BOOL)isAutoAllowLocalRecordingRequest;

/**
 * @brief Allow participants to request local recording.
 * @param allow YES: allow, NO: disallow.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */

- (MobileRTCSDKError)autoAllowLocalRecordingRequest:(BOOL)allow;

/**
 * @brief Whether the current user is able to suspend all participant activities.
 * @return YES means user can  suspend participant activities,.
 */

- (BOOL)canSuspendParticipantsActivities;

/**
 * @brief Suspend all participant activities.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Audio,Video,Share,Chat,Wihteboard funcation will be suspended,that need to call allowParticipantsToUnmuteSelf.allowParticipantsToStartVideo.lockShare.changeAttendeeChatPriviledge and allowParticipantsToShareWhiteBoard interfaces to resume.
 */
- (MobileRTCSDKError)suspendParticipantsActivites;

/**
 * @brief Query if the current user can hide participant profile pictures.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note This feature is influenced by focus mode change.
 */
- (MobileRTCSDKError)canHideParticipantProfilePictures;

/**
 * @brief Hide/Show participant profile pictures.
 * @param hide true means hide participant profile pictures, false means show participant pictures.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)hideParticipantProfilePictures:(BOOL)hide;

/**
 * @brief Query if the current meeting hides participant pictures.
 * @return YES means hide participant pictures, false means show participant pictures.
 */
- (BOOL)isParticipantProfilePicturesHidden;

#pragma mark - focus mode -
/**
 * @brief Get the focus mode enabled or not by web portal.
 * @return YES Means focus mode enabled. Otherwise NO.
 */
- (BOOL)isFocusModeEnabled;

/**
 * @brief Turn focus mode on or off. Focus mode on means Participants will only be able to see hosts' videos and shared content, and videos of spotlighted participants.
 * @param on Yes means to turen on, No means to turn off.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)turnFocusModeOn:(BOOL)on;

/**
 * @brief Get the focus mode on or off.
 * @return YES Means focus mode on. Otherwise NO.
 */
- (BOOL)isFocusModeOn;

/**
 * @brief Get share focus mode  type indicating who can see the shared content which is controlled by host or co-host.
 * @return Return the current share focus mode type.
 */
- (MobileRTCFocusModeShareType)getFocusModeShareType;

/**
 * @brief Set focus mode type indicating who can see the shared content which is controlled by host or co-host.
 * @param shareType The type of focus mode share type.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)setFocusModeShareType:(MobileRTCFocusModeShareType)shareType;

#pragma mark - virtual name tag -
/**
 * @brief Determines if there is support for the virtual name tag feature.
 * @return YES means supports the virtual name tag feature. NO means not supported.
 */
- (BOOL)isSupportVirtualNameTag;

/**
 * @brief Enable the virtual name tag feature for the account.
 * @param bEnabled YES means enabled. Otherwise not.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)enableVirtualNameTag:(BOOL)bEnabled;

/**
 * @brief Update the virtual name tag roster infomation for the account.
 * @param userRoster The virtual name tag roster info list for specify user.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note The maximum size of userRoster should less 20. User should sepcify the tagName and tagID of each MobileRTCVirtualNameTag object. The range of tagID is 0-1024.
 */
- (MobileRTCSDKError)updateVirtualNameTagRosterInfo:(NSArray<MobileRTCVirtualNameTag*>* _Nullable)userRoster;

@end
