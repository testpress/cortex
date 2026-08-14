/**
 * @file MobileRTCDirectShareService.h
 * @brief Direct screen sharing service functionality.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCDirectShareViaMeetingIDOrPairingCodeHandler
 * @brief Direct sharing by meeting ID or pairing code helper interface.
 */
@interface MobileRTCDirectShareViaMeetingIDOrPairingCodeHandler : NSObject
/**
 * @brief Try to match with the specified meeting number.
 * @param meetingNumber Specifies the meeting number.
 * @return The result of the function.
 */
- (BOOL)TryWithMeetingNumber:(NSString *_Nonnull)meetingNumber;

/**
 * @brief Try to match with the pairing code.
 * @param pairingCode Specifies the pairing code.
 * @return The result of the function.
 */
- (BOOL)TryWithPairingCode:(NSString *_Nonnull)pairingCode;

/**
 * @brief Delete the present direct sharing.
 * @return The result of the function.
 */
- (BOOL)cancel;
@end

/**
 * @protocol MobileRTCDirectShareServiceDelegate
 * @brief Callback event of direct share.
 */
@protocol MobileRTCDirectShareServiceDelegate <NSObject>
@optional
/**
 * @brief The callback event will be triggered if the status of direct sharing changes.
 * @param status Specifies the status of direct sharing.
 * @param handler A pointer to the MobileRTCDirectShareViaMeetingIDOrPairingCodeHandler. It is only valid when the value of status is MobileRTCDirectShareStatus_Need_MeetingID_Or_PairingCode.The SDK user must set the value of the pairingCode or meetingNumber via the functions of MobileRTCDirectShareViaMeetingIDOrPairingCodeHandler to start direct sharing.
 */
- (void)onDirectShareStatusUpdate:(MobileRTCDirectShareStatus)status handler:(MobileRTCDirectShareViaMeetingIDOrPairingCodeHandler  *_Nullable)handler;
@end

/**
 * @class MobileRTCDirectShareService
 * @brief Direct sharing helper Interface.
 * @warning You can only use this feature over iOS12.
 */
@interface MobileRTCDirectShareService : NSObject
/**
 * @brief Direct sharing helper callback.
 */
@property (assign, nonatomic) id<MobileRTCDirectShareServiceDelegate> _Nullable delegate;

/**
 * @brief Determines if it is able to start the direct sharing.
 * @return YES if direct sharing can be started. Otherwise, NO.
 */
- (BOOL)canStartDirectShare;

/**
 * @brief Determines if direct sharing is in progress.
 * @return YES if direct sharing is in progress. Otherwise, NO.
 */
- (BOOL)isDirectShareInProgress;

/**
 * @brief Starts direct sharing.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)startDirectShare;

/**
 * @brief Stops direct sharing.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)stopDirectShare;
@end


