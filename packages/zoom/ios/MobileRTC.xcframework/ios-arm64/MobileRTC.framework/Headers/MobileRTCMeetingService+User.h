/**
 * @file MobileRTCMeetingService+User.h
 * @brief Meeting+User service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @brief User of MobileRTCMeetingService
 */
@interface MobileRTCMeetingService (User)

/**
 * @brief Changes the user's screen name in the meeting.
 * @param inputName The screen name displayed in the meeting.
 * @param userId The user ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Normal user can change their own screen name, while the host or co-host can change all attendees' names.
 */
- (BOOL)changeName:(nonnull NSString*)inputName withUserID:(NSUInteger)userId;

/**
 * @brief Gets all the users in the meeting.
 * @return User id array, each user id is a NSNumber object.
 * @warning For Webinar Meeting, returned list does not include Attendee User.
 */
- (nullable NSArray <NSNumber *> *)getInMeetingUserList;

/**
 * @brief Gets all the attendees in the webinar.
 * @return User id array, each Attendee id is a NSNumber object.
 * @warning Only webinar meeting host, co-host, or panelist can run the function.
 */
- (nullable NSArray <NSNumber *> *)getWebinarAttendeeList;
/**
 * @brief Gets user information in the meeting.
 * @param userId The in-meeting user ID.
 * @return User information.
 * @warning Webinar attendee cannot call the function. Please use \link attendeeInfoByID: \endlink.
 */
- (nullable MobileRTCMeetingUserInfo*)userInfoByID:(NSUInteger)userId;

/**
 * @brief Gets attendees' information in the webinar.
 * @param userId The attendee's ID in the meeting.
 * @return Attendee info, a MobileRTCMeetingWebinarAttendeeInfo object.
 * @warning Webinar meeting host, co-host, or panelist can get other attendee info.
 * @warning Webinar attendee can only get their own attendee info.
 */
- (nullable MobileRTCMeetingWebinarAttendeeInfo*)attendeeInfoByID:(NSUInteger)userId;

/**
 * @brief Assigns a user as the host in the meeting.
 * @param userId The user ID who is specified as host in the meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host can run this function, and userId should not be myself.
 */
- (BOOL)makeHost:(NSUInteger)userId;

/**
 * @brief Removes a user from the meeting.
 * @param userId The user ID to be removed from the meeting.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning The method is available only for the host or co-host, and the host or co-host cannot remove themselves.
 */
- (BOOL)removeUser:(NSUInteger)userId;

/**
 * @brief Gets the ID of the current user in the meeting.
 * @return The ID of the current user.
 */
- (NSUInteger)myselfUserID;

/**
 * @brief Gets the ID of the active user in the meeting.
 * @return The active user ID.
 */
- (NSUInteger)activeUserID;

/**
 * @brief Gets the ID of the user who is sharing in the meeting.
 * @return The ID of the user who is sharing in the meeting.
 * @deprecated Use \link getViewableSharingUserList \endlink instead.
 */
- (NSUInteger)activeShareUserID DEPRECATED_MSG_ATTRIBUTE("Use getViewableSharingUserList instead");

/**
 * @brief Gets the IDs of users who are sharing.
 * @return A NSArray of sourceID of all users who are sharing.
 */
- (NSArray<NSNumber *>* _Nullable)getViewableSharingUserList;

/**
 * @brief Gets the IDs of users who are sharing docs.
 * @return An NSArray of user ID of all users who are sharing.
 */
- (NSArray<NSNumber *>* _Nullable)getViewableDocSharingUserList;

/**
 * @brief Gets the user's child list.
 * @param userId The user ID for which to get the information.
 * @return The sub-user list of user companion mode.
 */
- (NSArray *_Nullable)getCompanionChildList:(NSUInteger)userId;

/**
 * @brief Gets the information about the user's parent user.
 * @param userId The user ID for which to get the information.
 * @return If the function succeeds, it returns a MobileRTCMeetingUserInfo object. Otherwise, this function fails and returns nil.
 */
- (MobileRTCMeetingUserInfo *_Nullable)getCompanionParentUser:(NSUInteger)userId;

/**
 * @brief Judges if the two IDs from different sessions are of the same user.
 * @param user1 One user ID in the meeting.
 * @param user2 Another user ID in the meeting.
 * @return YES if the same user. Otherwise, NO.
 */
- (BOOL)isSameUser:(NSUInteger)user1 compareTo:(NSUInteger)user2;

/**
 * @brief Queries if the user is host.
 * @param userID The user ID.
 * @return YES if the user is the host. Otherwise, NO.
 */
- (BOOL)isHostUser:(NSUInteger)userID;

/**
 * @brief Queries if the ID is the current user's.
 * @param userID The user ID to be checked.
 * @return YES if the user themselves. Otherwise, NO.
 */
- (BOOL)isMyself:(NSUInteger)userID;

/**
 * @brief Queries if the user joined the meeting from H.323.
 * @param userID The user ID.
 * @return YES if the user joined the meeting from H.323. Otherwise, NO.
 */
- (BOOL)isH323User:(NSUInteger)userID;

/**
 * @brief Raises hand of the current user.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)raiseMyHand;
/**
 * @brief Puts hands down of the current user.
 * @param userId The user ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function when in meeting.
 */
- (BOOL)lowerHand:(NSUInteger)userId;

/**
 * @brief Puts all users' hands down.
 * @param isWebinarAttendee YES to lower all hands for webinar attendee. Otherwise, NO.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host or co-host can run the function when in meeting.
 */
- (BOOL)lowerAllHand:(BOOL)isWebinarAttendee;

/**
 * @brief Queries whether the current user is the original host.
 * @return YES if the current user is the original host. Otherwise, NO.
 */
- (BOOL)isSelfOriginalHost;

/**
 * @brief Queries if the current user can claim to be a host.
 * @return YES if the current user can claim to be a host. Otherwise, NO.
 */
- (BOOL)canClaimhost;

/**
 * @brief Reclaims the role of the host.
 * @return YES if the current user can claim to be a host. Otherwise, NO.
 */
- (BOOL)reclaimHost;

/**
 * @brief Claims to be a host by host key.
 * @param hostKey The host key.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)claimHostWithHostKey:(nonnull NSString*)hostKey;

/**
 * @brief Assigns a user as co-host in the meeting.
 * @param userID The user ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning The co-host cannot be assigned as co-host by themselves. And the user should have the power to assign the role.
 */
- (BOOL)assignCohost:(NSUInteger)userID;

/**
 * @brief Revokes co-host role of another user in the meeting.
 * @param userID The user ID.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 * @warning Only meeting host can run the function.
 */
- (BOOL)revokeCoHost:(NSUInteger)userID;

/**
 * @brief Queries if the user can be assigned as co-host in the meeting.
 * @param userID The user ID.
 * @return YES if the user can be assigned as co-host. Otherwise, NO.
 */
- (BOOL)canBeCoHost:(NSUInteger)userID;

/**
 * @brief Determines whether the user has started a live stream.
 * @param userID The user ID.
 * @return YES if the specified user has started a raw live stream. Otherwise, NO.
 */
- (BOOL)isRawLiveStreaming:(NSUInteger)userID;

/**
 * @brief Determines whether the user has raw live stream privilege.
 * @param userID The user ID.
 * @return YES if the specified user has raw live stream privilege. Otherwise, NO.
 */
- (BOOL)hasRawLiveStreamPrivilege:(NSUInteger)userID;

#pragma mark - robot -

/**
 * @brief Gets the information about the bot's authorized user.
 * @param botUserId The user ID for which to get the information.
 * @return If the function succeeds, it returns a MobileRTCMeetingUserInfo object. Otherwise, this function fails and returns nil.
 */
- (nullable MobileRTCMeetingUserInfo*)getBotAuthorizedUserInfoByUserID:(NSUInteger)botUserId;

/**
 * @brief Gets the authorizer's bot list.
 * @param userId The user ID for which to get the information.
 * @return The authorizer's robot list in the meeting.
 */
- (nullable NSArray <NSNumber *> *)getAuthorizedBotListByUserID:(NSUInteger)userId;

/**
 * @brief Assigns a user as co-host in the meeting and grants this user with privilege to manage related assets after the meeting.
 * @param userId The user ID who is specified as co-host in the meeting.
 * @param infoList The assets privilege information list.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note The co-host cannot be assigned as co-host by themselves. And the user should have the power to assign the role.
 */
- (MobileRTCSDKError)assignCohost:(NSUInteger)userId  withAssetsPrivilege:(NSArray <MobileRTCGrantCoOwnerAssetsInfo*> * _Nonnull)infoList;

/**
 * @brief Assigns a user as the host in the meeting and grants this user with privilege to manage related assets after the meeting.
 * @param userId The user ID who is specified as host in the meeting.
 * @param infoList The assets privilege information list.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note The host cannot be assigned as host by themselves. And the user should have the power to assign the role.
 */
- (MobileRTCSDKError)makeHost:(NSUInteger)userId  withAssetsPrivilege:(NSArray <MobileRTCGrantCoOwnerAssetsInfo*> * _Nonnull)infoList;

/**
 * @brief Queries if the user can be assigned as co-owner in the meeting. Co-owner can be granted with privilege to manage some assets after the meeting.
 * @param userId The user ID who will be assigned as co-owner in the meeting.
 * @return YES if the user can be assigned as co-owner. Otherwise, NO.
 */
- (BOOL)canBeCoOwner:(NSUInteger)userId;

/**
 * @brief Requests the avatar download for a specified user.
 * @param userid The user's ID whose avatar the SDK requests.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @note Valid for both ZOOM style and user custom interface mode. Valid for both normal user and webinar attendee.
 */
- (MobileRTCSDKError)requestAvatarForUser:(NSUInteger)userid;

@end
