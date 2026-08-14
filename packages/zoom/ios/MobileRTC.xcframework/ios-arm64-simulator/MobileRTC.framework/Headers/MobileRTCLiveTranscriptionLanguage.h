/**
 * @file MobileRTCLiveTranscriptionLanguage.h
 * @brief Language definitions for live transcription feature.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class MobileRTCLiveTranscriptionLanguage
 * @brief Represents live transcription language information.
 */
@interface MobileRTCLiveTranscriptionLanguage : NSObject

/**
 * @brief The language ID of the transcription language.
 */
@property(nonatomic, assign, readonly) NSInteger languageID;

/**
 * @brief The localized language name of the transcription language.
 */
@property(nonatomic, copy, readonly) NSString * _Nullable languageName;

@end

NS_ASSUME_NONNULL_END
