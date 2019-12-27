//
//  LengthFit.swift
//  GIViewKit
//
//  Created by Tyrant on 2019/5/7.
//  Copyright © 2019 Rex. All rights reserved.
//

import UIKit
import struct GIKit.GI

fileprivate func LengthFit(_ origin:CGFloat ) -> CGFloat {
    
    let screenWidth = UIScreen.main.bounds.size.width;
    return origin * screenWidth/375.0;
    
}


extension NSLayoutConstraint {
    
    @IBInspectable public var lengthFit: Bool {
        set {
            if newValue == true {
                self.constant = self.constant.gi.lengthFit
            }
        }
        get {
            return false
        }
    }
    
}


extension GI where Base == CGFloat {
    
    public var lengthFit: CGFloat {
        
        return LengthFit(self.base)
        
    }
    
}

extension GI where Base == Float {
    
    public var lengthFit: CGFloat {
        
        return LengthFit(CGFloat(self.base))
        
    }
    
}

extension GI where Base: BinaryInteger {
    
    public var lengthFit: CGFloat {
        
        return LengthFit(CGFloat(self.base))
        
    }
    
}
