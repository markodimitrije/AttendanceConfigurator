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
    let imgName = valid ? "arrow" : "stop"
    v.image = UIImage.init(named: imgName)
    v.tag = 20
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
