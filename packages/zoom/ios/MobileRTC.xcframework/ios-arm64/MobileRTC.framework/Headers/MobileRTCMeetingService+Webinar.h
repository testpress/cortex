/**
 * @file MobileRTCMeetingService+Webinar.h
 * @brief Meeting+Webinar service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @brief Interface for webinar meeting.
 */
@interface MobileRTCMeetingService (Webinar)

/**
 * @brief Queries if the user has the privilege to prompt or demote users in the webinar.
 * @return YES if the user owns the privilege. Otherwise, NO.
 */
- (BOOL)hasPromptAndDePromptPrivilege;

/**
 * @brief Prompts attendee to panelist in Webinar.
 * @param userID The user ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)promptAttendee2Panelist:(NSUInteger)userID;

/**
 * @brief Demotes the panelist to attendee.
 * @param userID The user ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)dePromptPanelist2Attendee:(NSUInteger)userID;

/**
 * @brief Sets the chat privilege of the panelist.
 * @param privilege The chat privilege of the panelist.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 * @warning Only webinar meeting can run the function.
 */
- (BOOL)changePanelistChatPrivilege:(MobileRTCPanelistChatPrivilegeType)privilege;

/**
 * @brief Gets the chat privilege of the panelist.
 * @return The chat privilege of the panelist.
 */
- (MobileRTCPanelistChatPrivilegeType)getPanelistChatPrivilege;
/**
 * @brief Allows or disallows attendee to chat.
 * @param privilegeType The chat privilege type.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 * @warning Only webinar meeting can run the function.
 */
- (BOOL)allowAttendeeChat:(MobileRTCChatAllowAttendeeChat)privilegeType;

/**
 * @brief Gets webinar attendee chat privilege type.
 * @return The chat privilege type for the webinar attendee.
 */
- (MobileRTCChatAllowAttendeeChat)getWebinarAttendeeChatPrivilege;

/**
 * @brief Queries if the attendee is allowed to talk in Webinar Meeting.
 * @param userID The user ID to be checked.
 * @return YES if allowed. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)isAllowAttendeeTalk:(NSUInteger)userID;

/**
 * @brief Allows or disallows attendee to talk in webinar.
 * @param userID The user ID to be allowed.
 * @param enable YES to enable. Otherwise, NO to disable.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)allowAttenddeTalk:(NSUInteger)userID allow:(BOOL)enable;

/**
 * @brief Queries if panelist can start video in Webinar Meeting.
 * @return YES if able. Otherwise, NO.
 */
- (BOOL)isAllowPanelistStartVideo;

/**
 * @brief Allows or disallows panelist to start video in Webinar.
 * @param enable YES to enable. Otherwise, NO to disable.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 */
- (BOOL)allowPanelistStartVideo:(BOOL)enable;

/**
 * @brief Determines if current webinar supports emoji reactions.
 * @return YES means the current webinar supports emoji reactions, NO means the feature is not supported.
 */
- (BOOL)isWebinarEmojiReactionSupported;

/**
 * @brief Queries if emoji reactions status is allowed.
 * @return YES if webinar emoji reaction is allowed. Otherwise, NO.
 */
- (BOOL)isWebinarEmojiReactionAllowed;

/**
 * @brief Permits the use of emoji reactions.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning If the function succeeds, the user will receive the callback onAllowWebinarReactionStatusChanged:. Available only for the host.
 */
- (MobileRTCSDKError)allowWebinarEmojiReaction;

/**
 * @brief Forbids the use of emoji reactions.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning If the function succeeds, the user will receive the callback onAllowWebinarReactionStatusChanged:. Available only for the host.
 */
- (MobileRTCSDKError)disallowWebinarEmojiReaction;

/**
 * @brief Queries if attendee raise hand status is allowed.
 * @return YES if webinar attendee is allowed to raise hand. Otherwise, NO.
 */
- (BOOL)isAttendeeRaiseHandAllowed;

/**
 * @brief Allows the attendee to use the raise hand.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning If the function succeeds, the user will receive the callback onAllowAttendeeRiseHandStatusChanged:. Available only for the host.
 */
- (MobileRTCSDKError)allowAttendeeRaiseHand;

/**
 * @brief Does not let the attendee raise their hand.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning If the function succeeds, the user will receive the callback onAllowAttendeeRiseHandStatusChanged:. Available only for the host.
 */
- (MobileRTCSDKError)disallowAttendeeRaiseHand;

/**
 * @brief Queries if attendee is allowed to view the participant count.
 * @return YES if allowed. Otherwise, NO.
 */
- (BOOL)isAttendeeViewTheParticipantCountAllowed;

/**
 * @brief Allows the attendee to view the participant count.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning If the function succeeds, the user will receive the onAllowAttendeeViewTheParticipantCountStatusChanged: callback event. Available only for the host.
 */
- (MobileRTCSDKError)allowAttendeeViewTheParticipantCount;

/**
 * @brief Forbids the attendee to view the participant count.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning If the function succeeds, the user will receive the onAllowAttendeeViewTheParticipantCountStatusChanged: callback event. Available only for the host.
 */
- (MobileRTCSDKError)disallowAttendeeViewTheParticipantCount;

/**
 * @brief Gets the participant count.
 * @return The count of participants.
 */
- (NSUInteger)getParticipantCount;

/**
 * @brief Sets the view mode of the attendee.
 * @param mode The view mode of the attendee.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning Only for host to call this API. Only for Zoom UI mode.
 */
- (MobileRTCSDKError)setAttendeeViewMode:(MobileRTCAttendeeViewMode)mode;

/**
 * @brief Gets the view mode of the attendee.
 * @return The attendee's view mode.
 * @warning Only for host to call this API. Only for Zoom UI mode.
 */
- (MobileRTCAttendeeViewMode)getAttendeeViewMode;

/**
 * @brief Gets poll legal notices prompt.
 * @return The poll legal notices prompt.
 */
- (NSString *_Nullable)getPollLegalNoticesPrompt;

/**
 * @brief Determines if polling legal notice is available.
 * @return YES if available. Otherwise, NO.
 */
- (BOOL)isPollingLegalNoticeAvailable;

/**
 * @brief Gets poll legal notices explained.
 * @return The poll legal notices explained.
 */
- (NSString *_Nullable)getPollLegalNoticesExplained;

/**
 * @brief Gets poll anonymous legal notices explained.
 * @return The poll anonymous legal notices explained.
 */
- (NSString *_Nullable)getPollAnonymousLegalNoticesExplained;

/**
 * @brief Gets annotation over share legal notices prompt.
 * @return The annotation over share legal notices prompt.
 */
- (NSString *_Nullable)getWebinarRegistrationLegalNoticesPrompt;

/**
 * @brief Gets annotation over share legal notices explained.
 * @return The annotation over share legal notices explained.
 */
- (MobileRTCWebinarRegistLegalNoticeContent *_Nullable)getWebinarRegistrationLegalNoticesExplained;

@end
