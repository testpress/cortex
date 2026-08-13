/**
 * @file MobileRTCMeetingService+Chat.h
 * @brief Meeting+Chat service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @brief Chat feature of meeting service class.
 */
@interface MobileRTCMeetingService (Chat)

/**
 * @brief Queries if the chat is disabled in the meeting.
 * @return YES if disabled. Otherwise, NO.
 */
- (BOOL)isChatDisabled;

/**
 * @brief Queries if it is able to send private chat in the meeting.
 * @return YES if disabled. Otherwise, NO.
 */
- (BOOL)isPrivateChatDisabled;

/**
 * @brief Sets attendee chat privilege when in-meeting.
 * @param privilege The chat privilege of the attendee.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function.
 * @warning Only normal meeting (non-webinar meeting) can run the function.
 */
- (BOOL)changeAttendeeChatPriviledge:(MobileRTCMeetingChatPriviledgeType)privilege;

/**
 * @brief Gets attendee chat privilege when in-meeting.
 * @return The result of attendee chat privilege.
 */
- (MobileRTCMeetingChatPriviledgeType)getAttendeeChatPriviledge;

/**
 * @brief Determines if meeting chat legal notice is available.
 * @return YES if available. Otherwise, NO.
 */
- (BOOL)isMeetingChatLegalNoticeAvailable;

/**
 * @brief Gets chat legal notice prompt.
 * @return The chat legal notice prompt.
 */
- (NSString *_Nullable)getChatLegalNoticesPrompt;

/**
 * @brief Gets explained text for chat legal notice.
 * @return The explained text for chat legal notice.
 */
- (NSString *_Nullable)getChatLegalNoticesExplained;

/**
 * @brief Gets in-meeting chat message.
 * @param messageID The message ID sent in the meeting.
 * @return The instance of in-meeting chat.
 * @warning The method is optional.
 */
- (nullable MobileRTCMeetingChat*)meetingChatByID:(nonnull NSString*)messageID;

/**
 * @brief Sends a chat message.
 * @param msg The chat message.
 * @return MobileRTCSendChatError_Success.
 */
- (MobileRTCSendChatError)sendChatMsg:(nullable MobileRTCMeetingChat *)msg;


/**
 * @brief Deletes chat message by message ID.
 * @param msgId The message ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)deleteChatMessage:(nonnull NSString *)msgId;

/**
 * @brief Gets all chat message IDs.
 * @return The all chat message id list. nil means failed.
 */
- (nullable NSArray <NSString *> *)getAllChatMessageID;

/**
 * @brief Determines whether the message can be deleted.
 * @param msgId The message ID.
 * @return YES if the message can be deleted. Otherwise, NO.
 */
- (BOOL)isChatMessageCanBeDeleted:(nonnull NSString *)msgId;

/**
 * @brief Determines if share meeting chat legal notice is available.
 * @return YES if available. Otherwise, NO.
 * @warning Need to call in meeting.
 */
- (BOOL)isShareMeetingChatLegalNoticeAvailable;

/**
 * @brief Gets start share meeting chat legal notice content.
 * @return The start share chat legal notice content.
 */
- (NSString *_Nullable)getShareMeetingChatStartedLegalNoticeContent;

/**
 * @brief Gets stop share meeting chat legal notice content.
 * @return The stop share chat legal notice content.
 */
- (NSString *_Nullable)getShareMeetingChatStoppedLegalNoticeContent;

#pragma mark - file transfer -
/**
 * @brief Determines whether file transfer is enabled.
 * @return YES if file transfer is enabled. Otherwise, NO.
 */
- (BOOL)isFileTransferEnabled;

/**
 * @brief Sends file to the specified user in the current meeting.
 * @param filePath The absolute path of the file.
 * @param userId The user ID to send the file to.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning This interface is related to chat privilege. See @{MobileRTCMeetingChatPriviledgeType}.
 */
- (MobileRTCSDKError)transferFile:(NSString * _Nullable)filePath toUser:(NSUInteger)userId;

/**
 * @brief Sends file to all users in the current meeting.
 * @param filePath The local path of the file.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning This interface is related to chat privilege. See @{MobileRTCMeetingChatPriviledgeType}.
 */
- (MobileRTCSDKError)transferFileToAll:(NSString * _Nullable)filePath;

/**
 * @brief Gets the list of allowed file types in transfer.
 * @return The value of allowed file types in transfer, comma-separated if there are multiple values. Exe files are by default forbidden from being transferred.
 */
- (NSString *_Nullable)getTransferFileTypeAllowList;

/**
 * @brief Gets the maximum size for file transfer.
 * @return The maximum number of bytes for file transfer.
 */
- (unsigned long long)getMaxTransferFileSize;

@end
