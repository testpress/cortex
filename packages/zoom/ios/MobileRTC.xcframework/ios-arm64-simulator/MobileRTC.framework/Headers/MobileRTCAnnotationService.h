/**
 * @file MobileRTCAnnotationService.h
 * @brief Interface for managing annotation features including tool settings, drawing operations, and annotation permissions during screen sharing.
 */

#import <Foundation/Foundation.h>

/**
 * @brief Type of annotation tools. For more information, please visit <https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0067931>.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAnnoTool) {
    /** Switch to mouse cursor. For initialization. */
    MobileRTCAnnoTool_None = 0,
    /** Pen. */
    MobileRTCAnnoTool_Pen,
    /** Highlighter. */
    MobileRTCAnnoTool_HighLighter,
    /** A straight line changes automatically in pace with the mouse cursor. */
    MobileRTCAnnoTool_AutoLine,
    /** A rectangle changes automatically in pace with the mouse cursor. */
    MobileRTCAnnoTool_AutoRectangle,
    /** An ellipse changes automatically in pace with the mouse cursor. */
    MobileRTCAnnoTool_AutoEllipse,
    /** An arrow changes automatically in pace with the mouse cursor. */
    MobileRTCAnnoTool_AutoArrow,
    /** An arrow changes automatically in pace with the mouse cursor. */
    MobileRTCAnnoTool_AutoArrow2,
    /** A filled rectangle. */
    MobileRTCAnnoTool_AutoRectangleFill,
    /** A filled ellipse. */
    MobileRTCAnnoTool_AutoEllipseFill,
    /** Only available if you started the shared screen or whiteboard. Displays your mouse pointer to all participants when your mouse is within the area being shared. Use this to point out parts of the screen to other participants. */
    MobileRTCAnnoTool_SpotLight,
    /** Displays a small arrow instead of your mouse pointer. Each subsequent click will remove the previous arrow placed. */
    MobileRTCAnnoTool_Arrow,
    /** Erase parts of your annotation. */
    MobileRTCAnnoTool_ERASER,
    /** Only available if you started the shared screen or whiteboard. Select , move, or resize your annotations. */
    MobileRTCAnnoTool_Picker,
    /** A fair rectangle changes automatically in pace with the mouse cursor. */
    MobileRTCAnnoTool_AutoRectangleSemiFill,
    /** A fair ellipse changes automatically in pace with the mouse cursor. */
    MobileRTCAnnoTool_AutoEllipseSemiFill,
    /** A line with a double-arrow. */
    MobileRTCAnnoTool_AutoDoubleArrow,
    /** An unfilled rhombus. */
    MobileRTCAnnoTool_AutoDiamond,
    /** A fixed-size arrow for marking. */
    MobileRTCAnnoTool_AutoStampArrow,
    /** A sign marking that something is correct. */
    MobileRTCAnnoTool_AutoStampCheck,
    /** A sign marking that something is incorrect. */
    MobileRTCAnnoTool_AutoStampX,
    /** A star for marking. */
    MobileRTCAnnoTool_AutoStampStar,
    /** A heart for marking. */
    MobileRTCAnnoTool_AutoStampHeart,
    /** A sign for interrogation. */
    MobileRTCAnnoTool_AutoStampQm,
};

/**
 * @brief Types of clearing annotations.
 */
typedef NS_ENUM(NSUInteger, MobileRTCAnnoClearType) {
    /** Clear all annotations. Hosts, cohost and shared meeting owners can use. */
    MobileRTCAnnoClearType_All = 0,
    /** Clear only your own annotations. Everyone can use. */
    MobileRTCAnnoClearType_My,
    /** Clear only the others' annotations. Only shared meeting owners can use. */
    MobileRTCAnnoClearType_Others,
};

/**
 * @brief The method is used to provide annotate service. 
 * @warning User, as the presenter, should stop the current share before starting another share. 
 */

@class MobileRTCAnnotationService;
/**
 * @protocol MobileRTCAnnotationServiceDelegate
 * @brief The share sender will disable the annotation, this delegate will notify the status change to viewer #only for custom UI#.
 * @warning If support is YES, viewer need call startAnnotationWithSharedView interface to start shareView annotation service.
 */
@protocol MobileRTCAnnotationServiceDelegate <NSObject>

/**
 * @brief Callback of that annotation tools change.
 * @param tool Specify the tool to annotate.
 */
- (void)onAnnotationToolChanged:(MobileRTCAnnoTool)tool;

/**
 * @brief Designated for Zoom Meeting notify the sharing user has changed the viewer's annotation privilage.
 * @param support YES means the share source user enabled the viewer to allow annotationse, otherwise not.
 * @param shareSourceID The share source ID  that is sharing.
 */
@optional
- (void)onAnnotationService:(nullable MobileRTCAnnotationService *)service supportStatusChanged:(BOOL)support shareSouceID:(NSUInteger)shareSourceID;
@end

/**
 * @class MobileRTCAnnotationService
 * @brief The Zoom annotation service for managing annotation.
 */
@interface MobileRTCAnnotationService : NSObject

/**
 * @brief Callback of receiving meeting events.
 */
@property (weak, nonatomic) id<MobileRTCAnnotationServiceDelegate> _Nullable delegate;

/**
 * @brief Determines if the current shareView can do annotation or not.
 * @param shareView The shared view.
 * @return YES if annotation can be done. Otherwise, NO.
 * @warning In ZoomUI Mode, If shareView is nil ,That means the currently active Zoom Subscribe Share View.
 */
- (BOOL)canDoAnnotation:(nullable UIView*)shareView;

/**
 * @brief Starts annotations on the shared view.
 * @param shareView The shared view.
 * @return The result of operation.
 */
- (MobileRTCAnnotationError)startAnnotationWithSharedView:(nullable UIView*)shareView;

/**
 * @brief Stops annotations.
 * @return The result of operation. 
 */
- (BOOL)stopAnnotation;

/**
 * @brief Sets the colors of annotation tools.
 * @return The result of setting the colors.
 */
- (MobileRTCAnnotationError)setToolColor:(nullable UIColor *)toolColor;

/**
 * @brief Gets the current annotation tool color.
 * @return The color by tool type.
 */
- (nullable UIColor *)getToolColor;

/**
 * @brief Sets the types of annotation tools.  
 * @return The result of operation.
 * @warning The tool type MobileRTCAnnoTool_Picker and MobileRTCAnnoTool_SpotLight are not support for viewer.
 */
- (MobileRTCAnnotationError)setToolType:(MobileRTCAnnoTool)type;

/**
 * @brief Gets the annotation tool type.
 * @return The current tool type.
 */
- (MobileRTCAnnoTool)getToolType;

/**
 * @brief Sets the line width of annotation tools.  
 * @return The result of operation.
 */
- (MobileRTCAnnotationError)setToolWidth:(NSUInteger)width;

/**
 * @brief Gets the annotation tool width.
 * @return The current tool width.
 */
- (NSUInteger)getToolWidth;

/**
 * @brief Clears the annotation content.
 * @param type the specify clear type.
 * @return The result of it.
 */
- (MobileRTCAnnotationError)clear:(MobileRTCAnnoClearType)type;

/**
 * @brief Undo the last annotation.  
 * @return The result of undoing the annotations.
 */
- (MobileRTCAnnotationError)undo;

/**
 * @brief Redo the last annotation.
 * @return The result of redoing the annotations. 
 */
- (MobileRTCAnnotationError)redo;

/**
 * @brief Determines if the current user is the presenter.
 * @return YES if the user is the presenter. Otherwise, NO.
 * @warning That need to start annotation first.
 */
- (BOOL)isPresenter;

/**
 * @brief Determines if it supports disabling viewer's annotation item.
 * @return YES if supported. Otherwise, NO.
 */
- (BOOL)canDisableViewerAnnotation;

/**
 * @brief Determines if the sender currently disabled the viewer's annotation or not.
 * @return YES if viewer's annotation is disabled. Otherwise, NO.
 */
- (BOOL)isViewerAnnotationDisabled;

/**
 * @brief Enables or disables viewer's annotation.
 * @param isDisable YES to disable, NO to enable.
 * @return MobileRTCAnnotationError_Successed if the operation succeeds.
 */
- (MobileRTCAnnotationError)disableViewerAnnotation:(BOOL)isDisable;

/**
 * @brief Determines if annotation legal notice is available.
 * @return YES if available. Otherwise, NO.
 */
- (BOOL)isAnnotationLegalNoticeAvailable;

/**
 * @brief Gets the annotation over share legal notices prompt.
 * @return The annotation over share legal notices prompt.
 */
- (NSString *_Nullable)getAnnotationLegalNoticesPrompt;

/**
 * @brief Gets the annotation over share legal notices explained.
 * @return The annotation over share legal notices explained.
 */
- (NSString *_Nullable)getAnnotationLegalNoticesExplained;

@end
