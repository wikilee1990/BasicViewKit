//
//  GradientButton+Reactive.swift
//  GIViewKit
//
//  Created by Tyrant on 2019/5/6.
//


import ReactiveCocoa
import ReactiveSwift

extension Reactive where Base == GradientButton {
    
    public var startWtihTitleColors: BindingTarget<(Bool, String, [CGColor])> {
        return makeBindingTarget { base, value in
            
            
            /// 如果有贮藏的数据 改变贮藏的数据
            if let _ = base.depository {
                base.depository?.title = value.1
            }
            else {
                base.setTitle(value.1, for: .normal)
            }
            
            base.new(colors: value.2)
            
            base.start = value.0
            
        }
    }
}
