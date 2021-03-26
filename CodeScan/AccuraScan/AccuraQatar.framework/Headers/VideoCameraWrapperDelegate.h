//
//  VideoCameraWrapperDelegate.h
//  AccuraSDK
//
//  Created by Chang Alex on 1/26/20.
//  Copyright © 2020 Elite Development LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ResultModel.h"

typedef NS_ENUM(NSUInteger, RecType) {
    REC_INIT = 1001,
    REC_BOTH,
    REC_FACE,
    REC_MRZ
};

typedef NS_ENUM(NSUInteger, RecogType) {
    OCR,
    PDF417,
    MRZ
};

@protocol VideoCameraWrapperDelegate <NSObject>
@optional
-(void)processedImage:(UIImage*)image;
-(void)recognizeFailed:(NSString*)message;
-(void)recognizeSucceed:(NSMutableDictionary*)scanedInfo recType:(RecType)recType bRecDone:(BOOL)bRecDone bFaceReplace:(BOOL)bFaceReplace bMrzFirst:(BOOL)bMrzFirst photoImage:(UIImage*)photoImage docFrontImage:(UIImage*)docFrontImage docbackImage:(UIImage*)docbackImage;
-(void)processedBlurPer: (BOOL)isBlur;
-(void)resultData:(ResultModel*)resultmodel;
-(void)screenSound;
-(void)livenessData:(UIImage*)livenessImage andshowImage:(UIImage*)showImage;
-(void)reco_msg:(NSString*)messageCode;
-(void)OnAPIError:(NSString *)message;
-(void)CloseOCR;
@end
