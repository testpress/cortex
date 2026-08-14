/**
 * @file MobileRTCMeetingService+Encryption.h
 * @brief Meeting+Encryption service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @brief Gets encryption info of the meeting.
 */
@interface MobileRTCMeetingService (Encryption)
/**
 * @brief Gets the meeting encryption type.
 * @return The meeting encryption type.
 */
- (MobileRTCMeetingEncryptionType)getEncryptionType;

/**
 * @brief Gets E2EE meeting security code.
 * @return The 40-digit security code.
 */
- (NSString* _Nullable)getE2EEMeetingSecurityCode;

/**
 * @brief Gets security code passed seconds.
 * @return The time the security code exists, in seconds.
 */
- (unsigned int)getE2EEMeetingSecurityCodePassedSeconds;

/**
 * @brief Determines whether unencrypted exception data is valid.
 * @note This method can only be called when the encryption type is MobileRTCMeetingEncryptionType_Enhanced.
 * @return YES if unencrypted exception data is valid. Otherwise, NO.
 */
- (BOOL)isUnencryptedExceptionDataValid;

/**
 * @brief Gets unencrypted exception count.
 * @return The unencrypted exception count.
 */
- (unsigned int)getUnencryptedExceptionCount;

/**
 * @brief Gets unencrypted exception info.
 * @return Unencrypted exception details.
 */
- (NSString* _Nonnull)getUnencryptedExceptionInfo;

/**
 * @brief Gets data center info.
 * @return Data center details.
 */
- (NSString* _Nonnull)getInMeetingDataCenterInfo;

@end
