//
//  VideoCameraWrapper.h
//  AccuraSDK


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VideoCameraWrapperDelegate.h"
#import "SDKModels.h"
#import "ResultModel.h"

@interface AccuraCameraWrapper : NSObject

{
    BOOL _isCapturing;
    BOOL _isMotion;
    NSThread *thread;
}


@property (nonatomic, strong) id<VideoCameraWrapperDelegate> delegate;



@property NSMutableDictionary *ocrDataSet;


- (SDKModels *)loadEngine:(NSString *)url;
- (NSMutableArray *)getOCRList;
-(void)setDefaultDialogs:(bool)isShowErrorDialogs;

-(id)initWithDelegate:(UIViewController<VideoCameraWrapperDelegate>*)delegate andImageView:(UIImageView *)iv andLabelMsg:(UILabel*)l andurl:(NSString*)url cardId:(int)cardId countryID:(int)countryID isScanOCR:(bool)isScanOCR andLabelMsgTop:(UILabel*)msgTop andcardName:(NSString*)cardName;
-(id)initWithDelegate:(UIViewController<VideoCameraWrapperDelegate>*)delegate andImageView:(UIImageView *)iv andMsgLabel:(UILabel*)l andfeedBackframeMessage:(NSString*)feedBackframeMessage andfeedBackAwayMessage:(NSString*)feedBackAwayMessage andfeedBackOpenEyesMessage:(NSString*)feedBackOpenEyesMessage andfeedBackCloserMessage:(NSString*)feedBackCloserMessage andfeedBackCenterMessage:(NSString*)feedBackCenterMessage andfeedBackMultipleFaceMessage:(NSString*)feedBackMultipleFaceMessage andfeedBackFaceSteady:(NSString*)feedBackFaceSteady andfeedBackLowLightMessage:(NSString*)feedBackLowLightMessage andfeedBackBlurFaceMessage:(NSString*)feedBackBlurFaceMessage andfeedBackGlareFaceMessage:(NSString*)feedBackGlareFaceMessage andcheckLivess:(bool)checkLivenss;

-(void)startCamera;
-(void)stopCamera;
-(void)ChangedOrintation:(CGFloat)width height:(CGFloat)height;

-(void)processWithArray:(NSArray*)imageDataArray andarrTextData:(NSArray*)ad;

-(void)processWithBack1:(NSString*)stCard  andisCheckBack:(bool)isCheckBack;
-(void)drawFeatures:(UIImage *)image11;
-(void)setHologramDetection:(bool)hologram;
-(void)setFaceBlurPercentage:(int)faceBlur;
-(void)setLowLightTolerance:(int)lowLight;
-(void)setMotionThreshold:(int)motion;
-(void)setGlarePercentage:(int)intMin intMax:(int)intMax;
-(void)setCheckPhotoCopy:(bool)isPhoto;
-(void)setBlurPercentage:(int)blur;
-(void)showLogFile:(bool)isShowLogs;
- (void)saveLogToFile:(NSString *)msg;
-(void) refreshPreview;
-(void)setMinFrameForValidate:(int)minFrame;
-(void)setMinFrameQatarName_IDNo_Validate:(int)minFrame;
-(void)setLivenessGlarePercentage:(int)glareMin glareMax:(int)glareMax;
-(void)setLivenessBlurPercentage:(int)blur;
-(void)setLivenessLowLightTolerence:(int)lowLightThreshold;
-(void)doRemoveBrightness:(bool)remove :(int)threshold;
-(void)SetAPIData:(NSString*)URL APIKey:(NSString*)APIKey;
- (void)CloseOCR;
-(NSString *)getSDKVersion;


@end
