//
//  NewInTableView.swift
//  GIViewKit
//
//  Created by Ray on 2019/1/2.
//  Copyright © 2019 Rex. All rights reserved.
//

import UIKit
import GIKit


extension UITableView {
    
    
    /// 是否不显示尾部占位cell
    @IBInspectable public var emptyFooter: Bool {
        set {
            tableFooterView = newValue ? UIView() : nil
        }
        get {
            return tableFooterView != nil
        }
    }
    
    
}

extension GI where Base: UITableViewCell {
    
    
    /// 起始位置
    /// - left: 一整条线
    /// - right: 没有线
    public enum Leading {
        
        case left, right
        
        var inset: UIEdgeInsets {
            switch self {
            case .left: return UIEdgeInsets(top: UIScreen.main.bounds.width, left: 0, bottom: 0, right: 0)
            case .right: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            }
        }
    }
    
    
    /// 分割线起始位置
    ///
    /// - Parameter to: 起始
    public func separator(leading to: Leading) {
        base.separatorInset = to.inset
    }
}
