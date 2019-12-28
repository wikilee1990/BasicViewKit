//
//  NewInButton.swift
//  BasicViewKit
//
//  Created by Ray on 2019/3/6.
//  Copyright © 2019 Rex. All rights reserved.
//

import UIKit

import BasicKit

/// 图片相对于Title的位置
///
/// - top: 顶部
/// - left: 左边
/// - bottom: 底部
/// - right: 右边
public enum ImageAt {
    
    public typealias Offsets = CGFloat
    
    case top(Offsets), left(Offsets), bottom(Offsets), right(Offsets)
    
    fileprivate var half: CGFloat {
        switch self {
        case let .top(offset): return offset / 2
        case let .left(offset): return offset / 2
        case let .bottom(offset): return offset / 2
        case let .right(offset): return offset / 2
        }
        
    }
}

extension BK where Base: UIButton {
    
    /// 图片位于Title的相对位置
    ///
    /// - Parameter at: 相对位置
    public func image(at: BasicViewKit.ImageAt) {
        
        let btn = self.base
    
        var labelSize: CGSize = CGSize.zero
        
        let imageSize: CGSize = btn.imageView?.frame.size ?? CGSize.zero
        
        if #available(iOS 8.0, *) {
            labelSize = btn.titleLabel?.intrinsicContentSize ?? CGSize.zero
        }
        else {
            labelSize = btn.titleLabel?.frame.size ?? CGSize.zero
        }
        
        var imageInsets = UIEdgeInsets.zero
        var labelInsets = UIEdgeInsets.zero
        
        let offset = at.half
        
        switch at {
        case .top:
            imageInsets = UIEdgeInsets(top: 0 - labelSize.height - offset, left: 0, bottom: 0, right: 0 - labelSize.width)
            labelInsets = UIEdgeInsets(top: 0, left: 0 - imageSize.width, bottom: 0 - imageSize.height - offset, right: 0)
        case .left:
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: offset)
            labelInsets = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0 - offset)
        case .bottom:
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0 - labelSize.height - offset, right: 0 - labelSize.width)
            labelInsets = UIEdgeInsets(top: 0 - imageSize.height - offset, left: 0 - imageSize.width, bottom: 0, right: 0)
        case .right:
            imageInsets = UIEdgeInsets(top: 0, left: labelSize.width + offset, bottom: 0, right: 0 - labelSize.width - offset)
            labelInsets = UIEdgeInsets(top: 0, left: 0 - imageSize.width - offset, bottom: 0, right: imageSize.width + offset)
        }
        
        btn.titleEdgeInsets = labelInsets
        btn.imageEdgeInsets = imageInsets
        
    }
    
    
    
    
}

import ReactiveCocoa
import ReactiveSwift
extension Reactive where Base: UIButton {
    
    /// 更改Button Title的同时更改图片位置
    ///
    /// - Parameter state: UIControl.State
    /// - Returns: BindingTarget<(String, GI<UIButton>.ImageAt)>
    public func titleThenIcon(for state: UIControl.State) -> BindingTarget<(String, BasicViewKit.ImageAt)> {
        return makeBindingTarget {
            $0.setTitle($1.0, for: state)
            $0.bk.image(at: $1.1)
        }
    }
    
    
    /// 按钮的点击事件
    ///
    /// - Parameter tap: 点击 touchUpInside
    public func tap(_ tap: @escaping (UIButton) -> ()) {
        self.controlEvents(.touchUpInside).observeValues{ tap($0) }
    }
    
    /// 点击后的信号
    ///
    /// - Parameter value: 需要传递的值
    /// - Returns: 信号<T, NoError>
    @available(*, deprecated, message: "使用`tap(value:)替换")
    public func tapSignal<T>(_ value: T) -> Signal<T, Never> {
        return controlEvents(.touchUpInside).map(value: value)
    }
    
    /// 点击后的信号
    ///
    /// - Parameter value: 需要传递的值
    /// - Returns: 信号<T, NoError>
    public func tap<T>(value: T) -> Signal<T, Never> {
        return controlEvents(.touchUpInside).map(value: value)
    }
}


extension UIButton {
    
    
    /// 交换2个Button的点击状态 点击左侧 置非选于右侧
    ///
    /// - Parameters:
    ///   - lhs: 左侧按钮
    ///   - rhs: 右侧按钮
    public static func swapSelected(_ lhs: UIButton, _ rhs: UIButton) {
        
        lhs.reactive.isSelected <~ lhs.reactive.controlEvents(.touchUpInside).filter { !$0.isSelected }.map(value: true)
        rhs.reactive.isSelected <~ rhs.reactive.controlEvents(.touchUpInside).filter { !$0.isSelected }.map(value: true)
        
        lhs.reactive.isSelected <~ rhs.reactive.signal(for: \UIButton.isSelected).filter { $0 }.negate()
        rhs.reactive.isSelected <~ lhs.reactive.signal(for: \UIButton.isSelected).filter { $0 }.negate()
        
    }

    
}




