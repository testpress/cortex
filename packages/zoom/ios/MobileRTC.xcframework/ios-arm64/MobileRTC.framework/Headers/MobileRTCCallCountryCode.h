/**
 * @file MobileRTCCallCountryCode.h
 * @brief Country code definitions for phone calls.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCCallCountryCode
 * @brief Provides information about countries that support calling.
 */
@interface MobileRTCCallCountryCode : NSObject

/**
 * @brief Gets the ID of the country where a user can dial in. The country ID (e.g., US, CA, etc.).
 */
@property (nonatomic, copy) NSString * _Nullable countryId;

/**
 * @brief Gets the country name.
 */
@property (nonatomic, copy) NSString * _Nullable countryName;

/**
 * @brief Gets the country code.
 */
@property (nonatomic, copy) NSString * _Nullable countryCode;

/**
 * @brief Gets the country number.
 */
@property (nonatomic, copy) NSString * _Nullable countryNumber;

/**
 * @brief Indicates whether the call is toll-free.
 */
@property (nonatomic, assign) BOOL tollFree;

@end
