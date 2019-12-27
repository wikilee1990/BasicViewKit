//
//  Themes.swift
//  GIKit
//
//  Created by Ray on 2018/12/6.
//  Copyright © 2018 Rex. All rights reserved.
//

import UIKit

import XKit

import GIKit

final public class Themes {

    public static func make() {
        
        UITableView.appearance().separatorColor = UIColor.gi.lightGray()
        UITableViewCell.appearance().selectedBackgroundView = UIView()
        UITabBar.appearance().barTintColor = UIColor.gi.red()
    }
    
}

/// Mark - Make255

public protocol Make255 {
    var dev255: CGFloat { get }
}

public protocol MakeColor {
    func colorful(alpha: CGFloat) -> UIColor
}

extension CGFloat: Make255 {
    public var dev255: CGFloat {
        return self / 255
    }
}

extension Int: Make255 {
    public var dev255: CGFloat {
        return CGFloat(self).dev255
    }
}

extension Double: Make255 {
    public var dev255: CGFloat {
        return CGFloat(self).dev255
    }
}

extension UInt64: Make255 {
    public var dev255: CGFloat {
        return CGFloat(self).dev255
    }
}

extension Array: MakeColor where Element: Make255 {
    
    /// RGB color -- r/255, g/255, b/255
    ///
    /// - Parameter alpha: 透明度
    /// - Returns: r/255, g/255, b/255
    public func colorful(alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: self.first?.dev255 ?? 0,
                       green: self.second?.dev255 ?? 0,
                       blue: self.third?.dev255 ?? 0,
                       alpha: alpha)
    }
}


extension String: MakeColor {
    
    /// RGB color -- r/255, g/255, b/255
    ///
    /// - Parameter alpha: 透明度
    /// - Returns: r/255, g/255, b/255
    public func colorful(alpha: CGFloat = 1) -> UIColor {
        return self.hex().colorful(alpha: alpha)
    }
    
    public func hex() -> [UInt64] {
        var k = self
        k.removeFirst(if: "#")
        
        let scanner = Scanner(string: k)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        return [r, g, b]
    }
    
    
    /// 如果该字符符合条件则移除
    ///
    /// - Parameter char: 字符
    public mutating func removeFirst(if char: String) {
        if self.hasPrefix(char) {
            self = String(self.dropFirst())
        }
    }
    
}





extension GI where Base == String {
    
    /// 文字图片化
    public var image: UIImage? {
        return UIImage(named: self.base)
    }
    
}



/// 本地化
public protocol Localization: CustomStringConvertible {
    
    /// 本地化
    var local: String { get }
}


public protocol Stuff {
    /// 图标
    var icon: UIImage? { get }
    
    /// 主题色
    var themes: UIColor? { get }
    
    /// 主题渐变 ["#0f83fe".colorful().cgColor, "#37C6F9".colorful().cgColor]
    var gradient: [CGColor] { get }
    
    /// 别称，通常为 description
    var alias: String { get }
}

/// 用于view展示通用协议
public protocol ShowingOff: Localization & Stuff { }

extension ShowingOff {
    
    
    /// 渐变
    public var gradient: [CGColor] {
        return UIColor.gi.otc_gradient()
    }
    
    /// 主题颜色
    public var themes: UIColor? {
        return UIColor.gi.blue()
    }
    
    /// 主题图标
    public var icon: UIImage? {
        return description.gi.image
    }
    
    /// 别名
    public var alias: String {
        return description
    }
    
}



public protocol Stage {
    func display(_ show: ShowingOff)
}
