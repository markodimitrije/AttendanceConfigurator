//
//  ImageProvider.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 16/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import Kingfisher

protocol IImageProvider {
    func get(addr: String?) -> UIImageView
}

extension IImageProvider {
    func get(addr: String?) -> UIImageView {
        let imgView = UIImageView()
        imgView.kf.setImage(with: URL(string: addr ?? ""))
        return imgView
    }
}

struct ImageProvider: IImageProvider {}
