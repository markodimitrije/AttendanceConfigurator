//
//  GlobalFuncs.swift
//  tryWebApiAndSaveToRealm
//
//  Created by Marko Dimitrijevic on 04/11/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//
 
import UIKit
import AVFoundation
import ScanditBarcodeCapture

func +=<Key, Value> (lhs: inout [Key: Value], rhs: [Key: Value]) {
    rhs.forEach{ lhs[$0] = $1 }
}

func getArrowImgView(frame: CGRect, validAttendance valid: Bool) -> UIImageView {
    let insetX = 0.4 * frame.width
    let insetY = 0.4 * frame.height
    let imgFrame = frame.insetBy(dx: insetX, dy: insetY)
    let v = UIImageView.init(frame: imgFrame)
    let imgName = valid ? "success" : "rejected"
    v.image = UIImage.init(named: imgName)
    v.tag = 20
    //v.contentMode = UIView.ContentMode.scaleAspectFill
    v.contentMode = UIView.ContentMode.scaleAspectFit
    return v
}

func getCameraDeviceDirection() -> CameraPosition? {
    if UIDevice.current.userInterfaceIdiom == .phone {
        return CameraPosition.worldFacing
    } else if UIDevice.current.userInterfaceIdiom == .pad {
        return CameraPosition.userFacing
    }
    return nil
}

func trimmedToSixCharactersCode(code: String) -> String {

    guard code.count >= 6 else { return code }
    
    let startPosition = code.count - 6
    let trimToSixCharactersCode = NSString(string: code).substring(from: startPosition)
//    print("trimed code = \(trimToSixCharactersCode), with code = \(code)")
    return trimToSixCharactersCode
}
