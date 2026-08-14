/**
 * @file MobileRTCMeetingService+Phone.h
 * @brief Meeting+Phone service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief Provides APIs to manage Zoom phone call-in and call-out features.
 */
@interface MobileRTCMeetingService (Phone)

/**
 * @brief Determines whether the user account supports calling out.
 * @return YES if the client supports the phone call-out feature. Otherwise, NO.
 */
-(BOOL)isSupportPhone;

/**
 * @brief Determines whether the user can dial out in the meeting.
 * @return YES if the user can dial out. Otherwise, NO.
 */
- (BOOL)isDialOutSupported;

/**
 * @brief Gets the list of countries that support call out.
 * @return If the function succeeds, it returns an NSArray of MobileRTCCallCountryCode objects. Otherwise, this function fails and returns nil.
 */
-(NSArray <MobileRTCCallCountryCode*>* _Nullable)getSupportCountryInfo;

/**
 * @brief Determines whether there is any outgoing call in process.
 * @return YES if there is an outgoing call in process. Otherwise, NO.
 */
- (BOOL)isDialOutInProgress;

/**
 * @brief Starts to dial out.
 * @param phone The destination phone number. Add the country code in front of the phone number, such as +86123456789.
 * @param me YES to call me, NO to invite others by phone.
 * @param username The name of the user to be called.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)dialOut:(nonnull NSString*)phone isCallMe:(BOOL)me withName:(nullable NSString*)username;

/**
 * @brief Cancels the dial out.
 * @param isCallMe YES to call me, NO to invite others by phone.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)cancelDialOut:(BOOL)isCallMe;


/**
 * @brief Gets the country code for the current user's locale.
 * @return If the function succeeds, it returns a MobileRTCCallCountryCode object. Otherwise, this function fails and returns nil.
 */
- (nullable MobileRTCCallCountryCode *)getDialInCurrentCountryCode;

/**
 * @brief Gets all country codes.
 * @return If the function succeeds, it returns an NSArray of NSArray of MobileRTCCallCountryCode objects. Otherwise, this function fails and returns nil.
 */
- (nullable NSArray <NSArray <MobileRTCCallCountryCode *> *> *)getDialInAllCountryCodes;

/**
 * @brief Gets the country codes specified by country ID.
 * @param countryId The country ID.
 * @return If the function succeeds, it returns an NSArray of MobileRTCCallCountryCode objects. Otherwise, this function fails and returns nil.
 */
- (nullable NSArray <MobileRTCCallCountryCode *> *)getDialInCallCodesWithCountryId:(nullable NSString *)countryId;

/**
 * @brief Makes a phone call to access voice.
 * @param countryNumber The country number.
 * @return If the function succeeds, it returns YES. Otherwise, NO.
 */
- (BOOL)dialInCall:(nullable NSString *)countryNumber;

@end

NS_ASSUME_NONNULL_END
