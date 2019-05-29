//
//  GlobalFuncs.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import AVFoundation
import ScanditBarcodeScanner

func getArrowImgView(frame: CGRect, validAttendance valid: Bool) -> UIImageView {
    let v = UIImageView.init(frame: frame)
    let imgName = valid ? "success" : "error"
    v.image = UIImage.init(named: imgName)
    v.tag = 20
    v.contentMode = UIView.ContentMode.scaleAspectFill
    return v
}

func getCameraDeviceDirection() -> SBSCameraFacingDirection? {
    if UIDevice.current.userInterfaceIdiom == .phone {
        return SBSCameraFacingDirection.back
    } else if UIDevice.current.userInterfaceIdiom == .pad {
        return SBSCameraFacingDirection.front
    }
    return nil
}

func trimmedToSixCharactersCode(code: String) -> String {
    let startPosition = code.count - 6
    let trimToSixCharactersCode = NSString(string: code).substring(from: startPosition)
//    print("trimed code = \(trimToSixCharactersCode), with code = \(code)")
    return trimToSixCharactersCode
}
