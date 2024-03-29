/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2017- Scandit AG. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import <ScanditCaptureCore/SDCQuadrilateral.h>
#import <ScanditCaptureCore/SDCBase.h>
#import <ScanditBarcodeCapture/SDCSymbology.h>

@class SDCEncodingRange;

/**
 * Indicates whether the code is part of a composite code.
 */
typedef NS_CLOSED_ENUM(NSUInteger, SDCCompositeFlag) {
/**
     * Code is not part of a composite code.
     */
    SDCCompositeFlagNone = 0,
/**
     * Code could be part of a composite code. This flag is set by linear (1d) symbologies that have no composite flag support but can be part of a composite code like the EAN/UPC symbology family.
     */
    SDCCompositeFlagUnknown = 1,
/**
     * Code is the linear component of a composite code. This flag can be set by GS1 DataBar or GS1-128 (Code 128).
     */
    SDCCompositeFlagLinked = 2,
/**
     * Code is a GS1 Composite Code Type A (CC-A). This flag can be set by MicroPDF417 codes.
     */
    SDCCompositeFlagGS1TypeA = 4,
/**
     * Code is a GS1 Composite Code Type B (CC-B). This flag can be set by MicroPDF417 codes.
     */
    SDCCompositeFlagGS1TypeB = 8,
/**
     * Code is a GS1 Composite Code Type C (CC-C). This flag can be set by PDF417 codes.
     */
    SDCCompositeFlagGS1TypeC = 16,
} NS_SWIFT_NAME(CompositeFlag);

NS_ASSUME_NONNULL_BEGIN

/**
 * A recognized barcode.
 */
NS_SWIFT_NAME(Barcode)
SDC_EXPORTED_SYMBOL
@interface SDCBarcode : NSObject

/**
 * The symbology of the barcode.
 */
@property (nonatomic, readonly) SDCSymbology symbology;
/**
 * The data of this code as a unicode string.
 *
 * For some types of barcodes/2d codes (for example Data Matrix, Aztec, Pdf417), the data may contain non-printable characters, characters that can not be represented as unicode code points, or nul-bytes in the middle of the string. data may be nil for such codes. How invalid code points are handled is platform-specific and should not be relied upon. If your applications relies on scanning of such codes, use rawData instead which is capable of representing this data without loss of information.
 */
@property (nonatomic, nonnull, readonly) NSString *data;
/**
 * The raw data contained in the barcode.
 *
 * Use this property instead of data if you are relying on binary-encoded data that can not be represented as unicode strings.
 *
 * Unlike data which returns the data in Unicode representation, the rawData returns the data with the encoding that was used in the barcode. See encodingRanges for more information.
 */
@property (nonatomic, nonnull, readonly) NSData *rawData;
/**
 * Array of encoding ranges. Each entry of the returned encoding array points into bytes of rawData and indicates what encoding is used for these bytes. This information can then be used to convert the bytes to unicode, or other representations. For most codes, a single encoding range covers the whole data, but certain 2d symbologies, such as SDCSymbologyQR allow to switch the encoding in the middle of the code.
 *
 * The returned encoding ranges are sorted from lowest to highest index. Each byte in rawData is contained in exactly one range, e.g. there are no holes or overlapping ranges.
 */
@property (nonatomic, nonnull, readonly) NSArray<SDCEncodingRange *> *encodingRanges;
/**
 * The location of the code. The coordinates are in image-space, meaning that the coordinates correspond to actual pixels in the image. For display, the coordinates need first to be converted into screen-space.
 *
 * The meaning of the values of SDCQuadrilateral.topLeft etc is such that the top left point corresponds to the top left corner of the barcode, independent of how the code is oriented in the image.
 *
 * @warning In case the feature is not licensed, a quadrilateral with all corners set to 0, 0 is returned.
 */
@property (nonatomic, readonly) SDCQuadrilateral location;
/**
 * YES for codes that carry GS1 data.
 */
@property (nonatomic, readonly) BOOL isGS1DataCarrier;
/**
 * Flag to hint whether the barcode is part of a composite code.
 */
@property (nonatomic, readonly) SDCCompositeFlag compositeFlag;
/**
 * Whether the recognized code is color inverted (printed bright on dark background).
 */
@property (nonatomic, readonly) BOOL isColorInverted;
/**
 * The symbol count of this barcode. Use this value to determine the symbol count of a particular barcode, e.g. to configure the active symbol counts.
 */
@property (nonatomic, readonly) NSInteger symbolCount;
/**
 * Id of the frame from which this barcode information was obtained.
 */
@property (nonatomic, readonly) NSUInteger frameId;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
