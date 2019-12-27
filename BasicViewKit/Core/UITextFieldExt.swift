//
//  UITextFieldExt.swift
//  GIViewKit
//
//  Created by Ray on 2018/12/26.
//  Copyright © 2018 Rex. All rights reserved.
//


extension UITextField {
    
    /// 设置 占位字符串 的颜色
    @IBInspectable public var placeholderColor: UIColor {
        set {
            self.setValue(newValue, forKeyPath: "placeholderLabel.textColor")
//             [textField1 setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.textColor"];
            
//            let placeholserAttributes: [NSAttributedString.Key: UIColor] = [.foregroundColor : placeholderColor]
//            attributedPlaceholder = NSAttributedString(string:placeholder ?? "", attributes: placeholserAttributes)
        }
        get {
            return UIColor.white
        }
    }
}



import ReactiveCocoa
import ReactiveSwift

postfix operator ~|

//precedencegroup TextFieldNext { associativity: left }
//infix operator ~> : TextFieldNext
//infix operator >>> : TextFieldNext
//
extension UITextField {
 
    /// 下一个响应的输入法
    ///
    /// - Parameters:
    ///   - left: 目前响应的
    ///   - right: 下一个响应
    /// - Returns: 下一个响应
    @discardableResult
    public static func ~> (_ left: UITextField, _ right: UITextField) -> UITextField {
        right.reactive.becomeFirstResponder <~ left.didEndOnExit
        return right
    }
    
    
    
    /// 结束最后一个键盘的响应者
    ///
    /// - Parameter left: 最后一个
    postfix public static func ~| (_ left: UITextField) {
        left.reactive.resignFirstResponder <~ left.didEndOnExit
    }
    
    
    /// 键盘点击 `Return` 按钮
    private var didEndOnExit: Signal<(), Never> {
        return reactive.controlEvents(.editingDidEndOnExit).map(value: ()).take(duringLifetimeOf: self)
    }
    
}
