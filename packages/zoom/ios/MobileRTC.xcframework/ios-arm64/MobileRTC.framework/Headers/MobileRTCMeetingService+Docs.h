/**
 * @file MobileRTCMeetingService+Docs.h
 * @brief Meeting+Docs service functionality and management.
 */

#import <MobileRTC/MobileRTC.h>

/**
 * @class MobileRTCDocSharingSourceInfo
 * @brief Share source info of Zoom docs.
 */
@interface MobileRTCDocSharingSourceInfo: NSObject
/**
 * @brief Gets the user ID of the Doc Sharing Source info.
 * @return If the function succeeds, the return value is the User ID. Otherwise the function fails, and the return value is ZERO (0).
 */
- (NSUInteger)getUserID;

/**
 * @brief Gets the sharing source ID.
 * @return If the function succeeds, the return value is the sharing Source ID. Otherwise the function fails, and the return value is ZERO (0).
 */
- (NSUInteger)getShareSourceID;

/**
 * @brief Gets the status of the Doc Sharing Source Info.
 * @return The sharing Source Info status.
 */
- (MobileRTCDocsStatus)getStatus;

/**
 * @brief Gets the title of the Doc Sharing Source Info.
 * @return The title of Sharing Source Info.
 */
- (NSString *_Nullable)getDocTitle;

@end


/**
 * @brief Meeting service for docs.
 */
@interface MobileRTCMeetingService (Docs)

/**
 * @brief Determines whether the current meeting supports Docs.
 * @return YES if the current meeting supports Docs. Otherwise, NO.
 */
- (BOOL)isSupportDocs;

/**
 * @brief Determines whether the current user can start sharing Doc.
 * @return If the function succeeds, it returns MobileRTCCannotShareReasonType_None. Otherwise, this function returns the reason that no one can start sharing the Doc.
 */
- (MobileRTCCannotShareReasonType)canStartShareDoc;

/**
 * @brief Shows Doc or DocDashboardView. Need to set parent view controller. If Doc is active \link MobileRTCDocsStatus_Start \endlink, that can show active Doc.
 * @param parentVC The view controller used to present ViewController.
 * @warning The function is only for Custom UI. This method is a prerequisite for using doc. Suggest to call this function in "onDocsStatusChanged:" for doc status.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)showDocByParentViewCtroller:(UIViewController* _Nonnull)parentVC;

/**
 * @brief Shows Doc or DocDashboardView. Need to set parent view controller. If Doc is active \link MobileRTCDocsStatus_Start \endlink, that can show active Doc.
 * @param parentVC The view controller used to present ViewController.
 * @param shareSourceID The selected doc share source ID.
 * @warning The function is only for Custom UI. This method is a prerequisite for using doc. Suggest to call this function in "onDocsStatusChanged:" for doc status.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)showActiveDoc:(NSUInteger)shareSourceID byParentViewCtroller:(UIViewController* _Nonnull)parentVC;

/**
 * @brief Shows the dashboard web view window.
 * @warning The function is only for Custom UI.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
- (MobileRTCSDKError)showDocDashboardView;

/**
 * @brief Dismisses Doc or dashboard.
 * @warning The function is only for Custom UI.
 */
- (void)dismissDocOrDashboardView;

/**
 * @brief Determines whether the current user can set Docs option.
 * @return YES if the current user can set Docs option. Otherwise, NO.
 */
- (BOOL)canSetDocsOption;

/**
 * @brief Sets the setting option for Docs who can share.
 * @param option The setting for who can share.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
-(MobileRTCSDKError)setDocsShareOption:(MobileRTCDocsShareOption)option;

/**
 * @brief Gets the setting option for Docs who can share.
 * @return The option.
 */
-(MobileRTCDocsShareOption)getDocsShareOption;

/**
 * @brief Sets the setting option for Docs who can initiate new Docs.
 * @param option The setting option for who can initiate new Docs.
 * @return If the function succeeds, it returns MobileRTCSDKError_Success. Otherwise, this function returns an error.
 */
-(MobileRTCSDKError)setDocsCreateOption:(MobileRTCDocsCreateOption)option;

/**
 * @brief Gets the setting option for who can initiate new Docs.
 * @return The option.
 */
-(MobileRTCDocsCreateOption)getDocsCreateOption;

/**
 * @brief Queries if other user is sharing docs.
 * @return YES if sharing successfully. Otherwise, NO.
 */
-(BOOL)isOtherSharingDocs;

/**
 * @brief Queries if the current user is sharing docs successfully.
 * @return YES if sharing successfully. Otherwise, NO.
 */
-(BOOL)isSharingDocsOut;

/**
 * @brief Gets the list of sharing source info.
 * @param userID The user ID who is sharing.
 * @return If the function succeeds, it returns an NSArray of MobileRTCDocSharingSourceInfo objects. Otherwise, this function fails and returns nil.
 */
- (NSArray<MobileRTCDocSharingSourceInfo *>* _Nullable)getDocSharingSourceInfoList:(NSUInteger)userID;


@end


