//
//  AddRatingManagerBridge.m
//  PackageShield
//
//  Created by Sireesha Neelapu on 07/12/21.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
//#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>

@interface RCT_EXTERN_MODULE(CheckoutManager, RCTEventEmitter)

//RCT_EXTERN_METHOD(dismissPresentedViewController:(nonnull NSNumber *)reactTag)
//
//RCT_EXTERN_METHOD(callTheRN:(nonnull NSString *)message)


RCT_EXTERN_METHOD(dismissPresentedViewController:(nonnull NSString *)reactTag)

RCT_EXTERN_METHOD(exitRN:(nonnull NSString *)reactTag)

RCT_EXTERN_METHOD(getTransactionStatus:(nonnull NSString *)message)



RCT_EXTERN_METHOD(getNewCardDetails:(nonnull NSString *)reactTag)

RCT_EXTERN_METHOD(getSavedCardsData:(nonnull NSString *)message)



RCT_EXTERN_METHOD(getSavedCardsSelectedData:(nonnull NSString *)reactTag)

RCT_EXTERN_METHOD(getSelectedWallet:(nonnull NSString *)message)
RCT_EXTERN_METHOD(getNonTokenizationATMDetails:(nonnull NSString *)message)
RCT_EXTERN_METHOD(getNonTokenizationCreditDetails:(nonnull NSString *)message)
RCT_EXTERN_METHOD(getTokenizationCardDetails:(nonnull NSString *)message)

@end
