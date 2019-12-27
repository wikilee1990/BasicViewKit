//
//  UILabelExt.swift
//  GIViewKit
//
//  Created by Ray on 2018/12/26.
//  Copyright © 2018 Rex. All rights reserved.
//

import UIKit

extension UILabel {
    
    private struct AssociatedKeys {
        static var copyAble = "copyAble"
    }
    
    private var isAlreadyCopyAble: Bool {
        return objc_getAssociatedObject(self, &AssociatedKeys.copyAble) as? Bool ?? false
    }
    
    @IBInspectable public var copyAvailable: Bool {
        set {
            
            ///是否之前已经是copyAvailable
            if newValue && !isAlreadyCopyAble {
                self.addTap()
            }

            ///之前的是否需要添加手势验证完毕后 设置属性
            objc_setAssociatedObject(self, &AssociatedKeys.copyAble, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return isAlreadyCopyAble
        }
    }

    ///增加手势
    func addTap() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(copyByLongPress)))
    }
    
    @objc func copyByLongPress() {
        
        self.becomeFirstResponder()
        
        menuPushed()
    }
    
    
    @discardableResult func menuPushed() -> Bool {
        let menu = UIMenuController.shared
        
        if menu.isMenuVisible && menu.menuItems?.first?.action == #selector(copyText) {
            return menu.isMenuVisible
        }
        
        let item = UIMenuItem(title: "复制", action: #selector(copyText))
        menu.menuItems = [item]
        menu.setTargetRect(self.bounds, in: self)
        menu.setMenuVisible(true, animated: true)
        return menu.isMenuVisible
    }
    
    @objc func copyText() {
        UIPasteboard.general.string = self.text
    }
    
    open override var canBecomeFirstResponder: Bool {
        return copyAvailable
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(copyText)
    }
    
}

