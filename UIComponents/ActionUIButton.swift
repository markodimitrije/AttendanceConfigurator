//
//  ActionUIButton.swift
//  AttendanceApp
//
//  Created by Marko Dimitrijevic on 08/06/2020.
//  Copyright © 2020 Navus. All rights reserved.
//

import UIKit

protocol ILoadingAnimating {
    func setLoading(_ loading: Bool)
//    func reload()
}

@IBDesignable
class ActionUIButton: UIButton, ILoadingAnimating {
    @IBInspectable var bgColorBtnEnabled: UIColor = .blue
    @IBInspectable var bgColorBtnDisabled: UIColor = .darkGray
    @IBInspectable var txtColorBtnEnabled: UIColor = .white
    @IBInspectable var txtColorBtnDisabled: UIColor = .white
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let temp = UIActivityIndicatorView()
        temp.style = .white
        temp.translatesAutoresizingMaskIntoConstraints = false
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(frame: CGRect? = nil,
         bgColorBtnEnabled: UIColor = .blue,
         bgColorBtnDisabled: UIColor = .darkGray,
         txtColorBtnEnabled: UIColor = .white,
         txtColorBtnDisabled: UIColor = .white) {
        super.init(frame: frame ?? CGRect.init())
        self.bgColorBtnEnabled = bgColorBtnEnabled
        self.bgColorBtnDisabled = bgColorBtnDisabled
        self.txtColorBtnEnabled = txtColorBtnEnabled
        self.txtColorBtnDisabled = txtColorBtnDisabled
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .green//bgColorBtnEnabled
        setTitleColor(txtColorBtnEnabled, for: .normal)
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            guard activityIndicator.superview == nil else {return}
            self.isUserInteractionEnabled = false
            addSubview(activityIndicator)
            bringSubviewToFront(activityIndicator)
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            activityIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
            activityIndicator.startAnimating()
        } else {
            self.isUserInteractionEnabled = true
            activityIndicator.removeFromSuperview()
            manageBtnColors(isLoading: false)
        }
        manageBtnColors(isLoading: loading)
    }
    
//    private func reload() {
//        backgroundColor = .green//bgColorBtnEnabled
//        setTitleColor(txtColorBtnEnabled, for: .normal)
//    }
    
    private func manageBtnColors(isLoading: Bool) {
        backgroundColor = isLoading ? .red : .green//bgColorBtnEnabled : bgColorBtnDisabled
        let color = isLoading ? txtColorBtnDisabled : txtColorBtnEnabled
        setTitleColor(color, for: .normal)
    }

}
