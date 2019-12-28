//
//  Pallet.swift
//  BasicViewKit
//
//  Created by Ray on 2019/1/2.
//  Copyright © 2019 Rex. All rights reserved.
//

import UIKit

import BasicKit

public enum ColorFor { case text, view }


public protocol Pallet {
    /// 黑 #
    static func black(_ cCase: ColorFor) -> UIColor
    /// 白 #ced3e9
    static func white(_ cCase: ColorFor) -> UIColor
    /// 浅灰 #6780a1
    static func lightGray(_ cCase: ColorFor) -> UIColor
    /// 灰 #6c85a8
    static func gray(_ cCase: ColorFor) -> UIColor
    /// 蓝 #213a58
    static func blue(_ cCase: ColorFor) -> UIColor
    /// 深蓝 #101F31 通常为背景色
    static func darkBlue(_ cCase: ColorFor) -> UIColor
    /// 深蓝  #071724
    static func deepBlue(_ cCase: ColorFor) -> UIColor
    /// 深蓝 #101F31 通常为背景色
    static func background(_ cCase: ColorFor) -> UIColor
    /// 红色 #BA3545
    static func red(_ cCase: ColorFor) -> UIColor

    ///渐变 ["#0f83fe".colorful().cgColor, "#37C6F9".colorful().cgColor]
    static func otc_gradient(_ type: BasicViewKit.Gradient) -> [CGColor]
}

public enum Gradient {
    case blue_blue, gray_gray, yellow_yellow
}

extension BK: Pallet where Base == UIColor {
    
    public static func black(_ cCase: ColorFor = .view) -> UIColor {
        return PalletBoard.black(cCase)
    }

    public static func white(_ cCase: ColorFor = .view) -> UIColor {
        return PalletBoard.white(cCase)
    }
    
    public static func lightGray(_ cCase: ColorFor = .view) -> UIColor {
        return PalletBoard.lightGray(cCase)
    }

    public static func gray(_ cCase: ColorFor = .view) -> UIColor {
        return PalletBoard.gray(cCase)
    }

    public static func blue(_ cCase: ColorFor = .view) -> UIColor {
        return PalletBoard.blue(cCase)
    }
    
    public static func darkBlue(_ cCase: ColorFor = .view) -> UIColor {
        return PalletBoard.darkBlue(cCase)
    }
    
    public static func deepBlue(_ cCase: ColorFor) -> UIColor {
        return PalletBoard.deepBlue(cCase)
    }
    
    public static func background(_ cCase: ColorFor = .view) -> UIColor {
        return PalletBoard.background(cCase)
    }
    
    public static func red(_ cCase: ColorFor = .view) -> UIColor {
        return PalletBoard.red(cCase)
    }
    
    public static func otc_gradient(_ type: Gradient = .blue_blue) -> [CGColor] {
        return PalletBoard.otc_gradient(type)
    }
}

/// MARK: -

internal struct ColorPackage {
    let _text: UIColor
    let _view: UIColor
    subscript(_ cCase: ColorFor) -> UIColor {
        return cCase == .text ? _text : _view
    }
    init(_ text: UIColor, _ view: UIColor) {
        _text = text
        _view = view
    }
}

class PalletBoard: Pallet {

    static let Pallet = PalletBoard()
    
    private let _black = ColorPackage(UIColor.black, UIColor.black)
    static func black(_ cCase: ColorFor) -> UIColor {
        return Pallet._black[cCase]
    }
    
    private let _white = ColorPackage("CED3E9".colorful(), UIColor.white)
    static func white(_ cCase: ColorFor) -> UIColor {
        return Pallet._white[cCase]
    }
    
    private let _lightGray = ColorPackage("6780A1".colorful(), UIColor.lightGray)
    static func lightGray(_ cCase: ColorFor) -> UIColor {
        return Pallet._lightGray[cCase]
    }
    
    private let _gray = ColorPackage("6C85A8".colorful(), UIColor.gray)
    static func gray(_ cCase: ColorFor) -> UIColor {
        return Pallet._gray[cCase]
    }
    
    private let _blue = ColorPackage(UIColor.blue, "213A58".colorful())
    static func blue(_ cCase: ColorFor) -> UIColor {
        return Pallet._blue[cCase]
    }

    private let _darkBlue = ColorPackage("101F31".colorful(), "101F31".colorful())
    static func darkBlue(_ cCase: ColorFor) -> UIColor {
        return Pallet._darkBlue[cCase]
    }
    
    
    static func background(_ cCase: ColorFor) -> UIColor {
        return Pallet._darkBlue[cCase]
    }
    
    
    private let _deepBlue = ColorPackage("071724".colorful(), "071724".colorful())
    static func deepBlue(_ cCase: ColorFor) -> UIColor {
        return Pallet._deepBlue[cCase]
    }
    
    private let _red = ColorPackage("BA3545 ".colorful(), "BA3545 ".colorful())
    static func red(_ cCase: ColorFor) -> UIColor {
        return Pallet._red[cCase]
    }

    static func otc_gradient(_ type: Gradient = .blue_blue) -> [CGColor] {
        switch type {
            case .blue_blue: return ["0f83fe".colorful().cgColor, "37C6F9".colorful().cgColor]
            case .gray_gray: return ["4C6076".colorful().cgColor, "3C4E67".colorful().cgColor]
            case .yellow_yellow: return ["F56B41".colorful().cgColor, "F7BB41".colorful().cgColor]
        }
    }
}
