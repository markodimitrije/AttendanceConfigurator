/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCBase.h>
#import <ScanditCaptureCore/SDCQuadrilateral.h>
#import <ScanditBarcodeCapture/SDCSymbology.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A barcode that was only localized but not recognized yet. This means there is no data or symbology associated with it.
 */
NS_SWIFT_NAME(LocalizedOnlyBarcode)
SDC_EXPORTED_SYMBOL
@interface SDCLocalizedOnlyBarcode : NSObject

/**
 * The location of the code. The coordinates are in image-space, meaning that the coordinates correspond to actual pixels in the image. For display, the coordinates need first to be converted into screen-space.
 *
 * The meaning of the values of SDCQuadrilateral.topLeft etc is such that the top left point corresponds to the top left corner of the barcode, independent of how the code is oriented in the image.
 *
 * @warning In case the feature is not licensed, a quadrilateral with all corners set to 0, 0 is returned.
 */
@property (nonatomic, readonly) SDCQuadrilateral location;
/**
 * Id of the frame from which this barcode information was obtained.
 */
@property (nonatomic, readonly) NSUInteger frameId;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
