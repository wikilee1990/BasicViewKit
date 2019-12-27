//
//  TransitionButton.swift
//  GIKit
//
//  Created by Ray on 2018/12/12.
//  Copyright © 2018 Rex. All rights reserved.
//

import UIKit

public enum Animation: Int {
    case spin = 0, shrink
}

public protocol GIAnimation {
    func animation(_ start: Bool, _ way: BasicViewKit.Animation?)
    var start: Bool { set get }
}

extension GIAnimation {
    public var start: Bool {
        set (start) {
            animation(start, .spin)
        }
        get {
            return true
        }
    }
}

extension CABasicAnimation {

    convenience init(keyPath: String?,
           distance: CGPoint,
           duration d: CFTimeInterval,
           media: CAMediaTimingFunction = CAMediaTimingFunction(name: .linear),
           fill: CAMediaTimingFillMode = .forwards,
           removedOnCompletion: Bool = false )
    {
        self.init(keyPath: keyPath)
        fromValue = distance.x
        toValue = distance.y
        duration = d
        timingFunction = media
        fillMode = fill
        isRemovedOnCompletion = removedOnCompletion
    }
}

extension CAShapeLayer: GIAnimation {

    public func animation(_ start: Bool, _ way: Animation?) {
        
//        guard way == .spin else { return }
        
        isHidden = !start
        guard start else {
            removeAllAnimations()
            return
        }
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z",
                                      distance: CGPoint(x: 0.0, y: CGFloat.pi * 2),
                                      duration: 0.6)
        rotate.repeatCount = Float.infinity
        
        self.add(rotate, forKey: rotate.keyPath!)
    }
    
    
    convenience init(_ frame: CGRect, _ color: UIColor) {
        self.init()
        
        self.drawPath(frame: frame)
        
        func genesis() {
            isHidden = true
            fillColor = nil
            strokeColor = color.cgColor
            lineWidth = 1
            strokeEnd = 0.4
        }
        genesis()
    }
    public func drawPath(frame: CGRect) {
        
        let radius = (frame.height / 2) * 0.5
        
        self.frame = CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
        
        let center = CGPoint(x: frame.height / 2, y: bounds.height / 2)
        let startAngle = 0 - CGFloat.pi / 2
        let endAngle = CGFloat.pi * 2 - CGFloat.pi / 2
        
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
        
    }
}


import ObjectiveC.runtime

import Dispatch

extension UIButton: GIAnimation {
    
    
    private struct AssociatedKeys {
        static var wayAnimating = "wayAnimating"
        static var indicator = "indicator"
        static var animating = "animating"
        static var depository = "depository"
    }
    
    private var ind: CAShapeLayer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.indicator) as? CAShapeLayer
        }
        set {
            guard let value = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.indicator, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.addSublayer(value)
        }
    }
    
    
   /// 动画方式
   public var wayAnimating: Animation {
        get {
            let a = objc_getAssociatedObject(self, &AssociatedKeys.wayAnimating) as? Int ?? 1
            return Animation(rawValue: a) ?? .shrink
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.wayAnimating, newValue.rawValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    /// 动画指示器 o
    fileprivate var indicator: GIAnimation {
        get {
            if let i = ind { return i }
            ind = CAShapeLayer(frame, titleColor(for: .normal) ?? UIColor.white)
            return ind!
        }
    }
    
    internal struct Storage {
        var title: String?
        var icon: UIImage?
        var corner: CGFloat
        var backimage: UIImage?
        
        func pour(out: Bool, button: UIButton) {
            let newtitle = out ? title : ""
            let newIcon = out ? icon : nil
            let newcorner = out ? corner : 0
            let newback = out ? backimage : nil
            button.setTitle(newtitle, for: .normal)
            button.setImage(newIcon, for: .normal)
            button.setBackgroundImage(newback, for: .normal)
            button.layer.cornerRadius = newcorner
        }
        
        init(_ btn: UIButton) {
            self.title = btn.title(for: .normal)
            self.icon = btn.image(for: .normal)
            self.corner = btn.layer.cornerRadius
            self.backimage = btn.backgroundImage(for: .normal)
            pour(out: false, button: btn)
        }
    }
    
    internal var depository: Storage? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.depository) as? Storage
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.depository, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    /// 贮藏或还原 原始属性
    fileprivate func storage(while store: Bool) {
        if store {
            depository = Storage(self)
        } else {
            depository?.pour(out: true, button: self)
        }
    }
    
    
    /// 动画
    ///
    /// - Parameters:
    ///   - start: 是否执行动画
    ///   - way: 动画的方式
    public func animation(_ start: Bool, _ way: Animation?) {
        
        if start, self.start { return }
        
        ind?.strokeColor = titleColor(for: .normal)?.cgColor
        
        switch way! {
        case .shrink:
            /// 贮藏
            storage(while: start)
            /// 执行缩小
            shrink(while: start)
        case .spin: break
            /// 缩小
//            animation(start, .shrink)
            /// 旋转
//            indicator.animation(start, way!)
        }

        indicator.animation(start, way!)
    }
    
    
    
    /// 缩放动画
    ///
    /// - Parameter small: 是否是缩小
    public func shrink(while small: Bool) {
        
        let from = small ? frame.width : bounds.height
        let to = small ? frame.height : bounds.width
        
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width",
                                          distance: CGPoint(x: from, y: to),
                                          duration: 0.1)
        
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath!)
        
        if small {
            layer.cornerRadius = frame.height / 2;
        }
    }
    
    
    private var isAnimating: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.animating, newValue, .OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.animating) as? Bool ?? false
        }
    }

    public var start: Bool {
        set {
            
            if newValue == start { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.isUserInteractionEnabled = !newValue
                self.animation(newValue, self.wayAnimating)
                self.isAnimating = newValue
            }
            
        }
        get {
            return self.isAnimating
        }
        
    }
    
}

import ReactiveCocoa
import ReactiveSwift

extension Reactive where Base: UIButton {
    
    public var start: BindingTarget<Bool> {
        return makeBindingTarget { $0.start = $1 }
    }
    
    public var startWtihTitle: BindingTarget<(Bool, String)> {
        return makeBindingTarget { base, value in
            
            
            /// 如果有贮藏的数据 改变贮藏的数据
            if let _ = base.depository {
                base.depository?.title = value.1
            }
            else {
                base.setTitle(value.1, for: .normal)
            }
            
            base.start = value.0
            
        }
    }
}


