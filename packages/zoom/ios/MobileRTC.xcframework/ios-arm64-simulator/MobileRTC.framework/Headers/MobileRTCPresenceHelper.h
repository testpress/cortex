/**
 * @file MobileRTCPresenceHelper.h
 * @brief Helper for managing user presence status.
 */

#import <Foundation/Foundation.h>
#import <MobileRTC/MobileRTCConstants.h>

/**
 * @class MobileRTCContactInfo
 * @brief A class that contains presence information.
 */
@interface MobileRTCContactInfo : NSObject

/**
 * @brief The contact's ID.
 */
@property (copy, nonatomic, readonly) NSString * _Nullable contactID;

/**
 * @brief The contact's name.
 */
@property (copy, nonatomic, readonly) NSString * _Nullable contactName;

/**
 * @brief The contact's presence status, such as MobileRTCPresenceStatus_Available.
 */
@property (assign, nonatomic, readonly) MobileRTCPresenceStatus presenceStatus;

/**
 * @brief The contact's profile picture.
 */
@property (copy, nonatomic, readonly) NSString * _Nullable profilepicture;

/**
 * @brief The contact's personal note.
 */
@property (copy, nonatomic, readonly) NSString * _Nullable personalNote;

/**
 * @brief The contact's company name, such as "Acme Incorporated".
 */
@property (copy, nonatomic, readonly) NSString * _Nullable companyName;

/**
 * @brief The contact's department, such as "Human resources".
 */
@property (copy, nonatomic, readonly) NSString * _Nullable department;

/**
 * @brief The contact's job title, such as "Support engineer".
 */
@property (copy, nonatomic, readonly) NSString * _Nullable jobTitle;

/**
 * @brief The contact's phone number, such as "+1 000 000-0000".
 */
@property (copy, nonatomic, readonly) NSString * _Nullable phoneNumber;

/**
 * @brief The contact's email, such as "jillchill@example.com".
 */
@property (copy, nonatomic, readonly) NSString * _Nullable email;

@end

/**
 * @class MobileRTCInvitationMeetingHandler
 * @brief A handler that processes after the user receives an invitation from another user to join a meeting.
 */
@interface MobileRTCInvitationMeetingHandler : NSObject

/**
 * @brief The inviter's ID.
 */
@property (copy, nonatomic, readonly) NSString * _Nullable senderId;

/**
 * @brief The inviter's name.
 */
@property (copy, nonatomic, readonly) NSString * _Nullable senderName;

/**
 * @brief The invite meeting number.
 */
@property (assign, nonatomic, readonly) long long meetingNumber;

/**
 * @brief Indicates whether this invitation is from the channel.
 */
@property (assign, nonatomic, readonly) BOOL isChannelInvitation;

/**
 * @brief The channel name.
 */
@property (copy, nonatomic, readonly) NSString *_Nullable channelName;

/**
 * @brief The channel member count.
 */
@property (assign, nonatomic, readonly) unsigned int channelMemberCount;

/**
 * @brief Sets the screen name for joining the meeting.
 * @param screenName The screen name.
 */
- (void)setScreenName:(NSString * _Nullable)screenName;

/**
 * @brief Accepts the invitation, joins the meeting, and finally self-destroys.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)accept;

/**
 * @brief Declines the invitation and finally self-destroys.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)decline;

/**
 * @brief Lets the invitation time out and finally self-destroys.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)timeout;

@end

/**
 * @protocol MobileRTCPresenceHelperDelegate
 * @brief A protocol for presence helper callback events.
 */
@protocol MobileRTCPresenceHelperDelegate <NSObject>

/**
 * @brief Callback event when requesting star contact ID list.
 * @param contactIDList The star contact result value.
 */
- (void)onRequestStarContact:(NSArray <NSString *> *_Nullable)contactIDList;

/**
 * @brief Callback event when requesting the contact detail information list.
 * @param contactList The contact detail information list.
 */
- (void)onRequestContactDetailInfo:(NSArray <MobileRTCContactInfo *> *_Nullable)contactList;

/**
 * @brief Callback event when contact presence changes.
 * @param contactID The contact's ID.
 * @param status The contact presence status.
 */
- (void)onUserPresenceChanged:(NSString *_Nullable)contactID presenceStatus:(MobileRTCPresenceStatus)status;

/**
 * @brief Callback event when starred contact list changes.
 * @param contactIDList The ID list of changed contacts.
 * @param add YES if the contact list is added, NO otherwise.
 */
- (void)onStarContactListChanged:(NSArray <NSString *> *_Nullable)contactIDList isAdd:(BOOL)add;

/**
 * @brief Callback event when receiving a meeting invitation.
 * @param handler A pointer to the MobileRTCInvitationMeetingHandler.
 */
- (void)onReceiveInvitationToMeeting:(MobileRTCInvitationMeetingHandler *_Nullable)handler;

/**
 * @brief Callback event when the meeting invitation is canceled by inviter.
 * @param meetingNumber The canceled meeting number.
 */
- (void)onMeetingInvitationCanceled:(long long)meetingNumber;

/**
 * @brief Callback event when the meeting invitation is accepted on another device.
 * @param meetingNumber The accepted meeting number.
 */
- (void)onMeetingAcceptedByOtherDevice:(long long)meetingNumber;

/**
 * @brief Callback event when the meeting invitation is declined on another device.
 * @param contactID The contact ID that declined the meeting invitation.
 */
- (void)onMeetingInvitationDeclined:(NSString *_Nullable)contactID;

/**
 * @brief Callback event when the meeting invitation is declined.
 * @param meetingNumber The meeting number that was declined by other device.
 */
- (void)onMeetingDeclinedByOtherDevice:(long long)meetingNumber;


@end

/**
 * @class MobileRTCPresenceHelper
 * @brief A class to manage contact presence and meeting invitations.
 */
@interface MobileRTCPresenceHelper : NSObject

/**
 * @brief The delegate for presence helper's event handler.
 */
@property(nonatomic, assign, nullable)id<MobileRTCPresenceHelperDelegate> delegate;

/**
 * @brief Sends a request to get the starred contact IDs.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)requestStarContact;

/**
 * @brief Sends a request to add the contact into a starred contact list.
 * @param contactID The contact ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)starContact:(NSString *_Nonnull)contactID;

/**
 * @brief Sends a request to remove a contact from the starred contact list.
 * @param contactID The contact ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)unStarContact:(NSString *_Nonnull)contactID;

/**
 * @brief Sends an invitation to a contact to join a meeting.
 * @param contactID The contact ID.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)inviteContact:(NSString *_Nonnull)contactID;

/**
 * @brief Batch invites a list of specified contacts to the current meeting.
 * @param contactIDList A list which contains contact IDs of the specified users.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)inviteContactList:(NSArray <NSString *> *_Nonnull)contactIDList;

/**
 * @brief Sends a request for contact detail information according to the contact ID list.
 * @param contactIDList The contact ID list.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)requestContactDetailInfo:(NSArray <NSString *> *_Nonnull)contactIDList;

/**
 * @brief Sends a request to subscribe contact presence status according to the contact ID list.
 * @param contactIDList The contact ID list.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)subscribeContactPresence:(NSArray <NSString *> *_Nonnull)contactIDList;

/**
 * @brief Sends a request to unsubscribe contact presence status according to the contact ID list.
 * @param contactIDList The contact ID list.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)unSubscribeContactPresence:(NSArray <NSString *> *_Nonnull)contactIDList;

@end



