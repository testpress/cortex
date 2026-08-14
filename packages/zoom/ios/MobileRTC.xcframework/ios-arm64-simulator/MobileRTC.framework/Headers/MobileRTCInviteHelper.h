/**
 * @file MobileRTCInviteHelper.h
 * @brief Helper for managing meeting invitations.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCInviteHelper
 * @brief A class for getting and setting configurations in a meeting.
 */
@interface MobileRTCInviteHelper : NSObject

/**
 * @brief Gets the current meeting number in format such as 123456789.
 * @warning The method should be called during an ongoing meeting; otherwise, the value is invalid.
 */
@property (retain, nonatomic, readonly) NSString * _Nonnull ongoingMeetingNumber;

/**
 * @brief Gets the unique ID of the current meeting in format such as DVLObefSZizM0xQLhtrCQ==.
 * @warning The method should be called during an ongoing meeting; otherwise, the value is invalid.
 */
@property (retain, nonatomic, readonly) NSString * _Nonnull ongoingMeetingID;

/**
 * @brief Gets the current meeting topic.
 * @warning The method should be called during an ongoing meeting; otherwise, the value is invalid.
 */
@property (retain, nonatomic, readonly) NSString * _Nonnull ongoingMeetingTopic;

/**
 * @brief Gets the current meeting start time.
 * @warning The method should be called during an ongoing meeting; otherwise, the value is invalid.
 */
@property (retain, nonatomic, readonly) NSDate * _Nonnull ongoingMeetingStartTime;

/**
 * @brief Queries if the current meeting is a recurring meeting.
 * @warning The method should be called during an ongoing meeting; otherwise, the value is invalid.
 */
@property (assign, nonatomic, readonly) BOOL ongoingRecurringMeeting;

/**
 * @brief Gets the join URL of the current meeting.
 */
@property (retain, nonatomic, readonly) NSString * _Nonnull joinMeetingURL;

/**
 * @brief Gets the meeting password.
 */
@property (retain, nonatomic, readonly) NSString * _Nonnull meetingPassword;

/**
 * @brief Gets the original meeting password.
 */
@property (retain, nonatomic, readonly) NSString * _Nonnull rawMeetingPassword;

/**
 * @brief Gets the phone number of a toll call.
 */
@property (retain, nonatomic, readonly) NSString * _Nonnull tollCallInNumber;

/**
 * @brief Gets the phone number of a toll-free call.
 */
@property (retain, nonatomic, readonly) NSString * _Nonnull tollFreeCallInNumber;

/**
 * @brief Enables the invitation by message.
 * @warning If set disableInviteSMS to YES, the "Invite by Message" button will not be displayed in Invite item; otherwise, you can customize the invitation content.
 */
@property (assign, nonatomic) BOOL disableInviteSMS;

/**
 * @brief Customizes the SMS invitation content.
 */
@property (retain, nonatomic) NSString * _Nonnull inviteSMS;

/**
 * @brief Enables Copy URL.
 * @warning If set disableCopyURL to YES, the "Copy URL" button will not be displayed in Invite item; otherwise, you can customize the Copy URL content.
 */
@property (assign, nonatomic) BOOL disableCopyURL;

/**
 * @brief Customizes the content of Copy URL.
 */
@property (retain, nonatomic) NSString * _Nonnull inviteCopyURL;

/**
 * @brief Enables the invitation by email.
 * @warning If set disableEmailInvite to YES, the "Invite by Email" button will not be displayed in Invite item; otherwise, you can customize the content of email via inviteEmailSubject and inviteEmailContent.
 */
@property (assign, nonatomic) BOOL disableInviteEmail;

/**
 * @brief Customizes the subject of the invitation by email.
 */
@property (retain, nonatomic) NSString * _Nullable inviteEmailSubject;

/**
 * @brief Customizes the content of the invitation by email.
 */
@property (retain, nonatomic) NSString * _Nullable inviteEmailContent;

/**
 * @brief Gets the instance of MobileRTCInviteHelper.
 * @return The shared instance of MobileRTCInviteHelper.
 */
+ (MobileRTCInviteHelper * _Nonnull)sharedInstance;

@end
