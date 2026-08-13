/**
 * @file MobileRTCRequestRawLiveStreamPrivilegeHandler.h
 * @brief Handler for requesting raw live stream privileges.
 */

#import <Foundation/Foundation.h>

/**
 * @class MobileRTCRequestRawLiveStreamPrivilegeHandler
 * @brief A handler that processes after the host receives the requirement from the user to give the raw live stream privilege.
 */
@interface MobileRTCRequestRawLiveStreamPrivilegeHandler : NSObject

/**
 * @brief Gets the request ID.
 * @return If the function succeeds, it returns the request ID.
 */
- (NSString * _Nullable)getRequestId;

/**
 * @brief Gets the user ID who requested privilege.
 * @return If the function succeeds, it returns the user ID. Otherwise, it returns 0.
 */
- (NSUInteger)getRequesterId;

/**
 * @brief Gets the user name who requested privilege.
 * @return If the function succeeds, it returns the user name.
 */
- (NSString * _Nullable)getRequesterName;

/**
 * @brief Gets the broadcast URL.
 * @return If the function succeeds, it returns the broadcast URL.
 */
- (NSString * _Nullable)getBroadcastUrl;

/**
 * @brief Gets the broadcast name.
 * @return If the function succeeds, it returns the broadcast name.
 */
- (NSString * _Nullable)getBroadcastName;

/**
 * @brief Allows the user to start raw live stream and finally self-destroys.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)grantRawLiveStreamPrivilege;

/**
 * @brief Denies the user permission to start raw live stream and finally self-destroys.
 * @return YES if the function succeeds. Otherwise, NO.
 */
- (BOOL)denyRawLiveStreamPrivilege;

@end
