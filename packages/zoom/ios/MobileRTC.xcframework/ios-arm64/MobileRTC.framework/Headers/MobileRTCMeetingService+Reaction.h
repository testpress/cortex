/**
 * @file MobileRTCMeetingService+Reaction.h
 * @brief Meeting+Reaction service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

NS_ASSUME_NONNULL_BEGIN


/**
 * @brief Interface for managing emoji reactions and emoji feedback in Zoom SDK.
 */
@interface MobileRTCMeetingService (Reaction)

/**
 * @brief Determines if the Reaction feature is enabled.
 * @return YES if the Reaction feature is enabled. Otherwise, NO.
 */
- (BOOL)isEmojiReactionEnabled;

/**
 * @brief Sends emoji reaction.
 * @param type The type of the emoji reaction.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 * @warning MobileRTCEmojiReactionSkinTone doesn't work for MobileRTCEmojiReactionType_Heart type. To set MobileRTCEmojiReactionSkinTone, use -[MobileRTCMeetingSettings setReactionSkinTone] in MobileRTCMeetingSettings.h file.
 */
- (MobileRTCSDKError)sendEmojiReaction:(MobileRTCEmojiReactionType)type;

/**
 * @brief Sends the emoji feedback.
 * @param type The emoji feedback type to be sent.
 * @return If the function succeeds, it will return MobileRTCMeetError_Success, otherwise not.
 */
- (MobileRTCSDKError)sendEmojiFeedback:(MobileRTCEmojiFeedbackType)type;

/**
 * @brief Cancels the emoji feedback.
 * @return If the function succeeds, it will return MobileRTCMeetError_Success, otherwise not.
 */
- (MobileRTCSDKError)cancelEmojiFeedback;
@end

NS_ASSUME_NONNULL_END
