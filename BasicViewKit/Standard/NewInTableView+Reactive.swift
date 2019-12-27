//
//  NewInTableView+Reactive.swift
//  GIViewKit
//
//  Created by Tyrant on 2019/5/9.
//  Copyright © 2019 Rex. All rights reserved.
//


import MJRefresh



extension UITableView {
    
    
    /// 停止更新动作
    ///
    /// - Parameter outOfData: 是否已无更多数据
    public func endRefresh(outOfData: Bool) {
        if let head = self.mj_header {
            head.endRefreshing()
        }
        if let foot = self.mj_footer {
            if outOfData {
                foot.endRefreshingWithNoMoreData()
            }
            else {
                foot.endRefreshing()
            }
        }
    }
}

import ReactiveSwift
import ReactiveCocoa
//import enum XKit.Pages
//import GIKit// GIKit.List
//
//extension UITableView {
//    
//    private struct AssociatedKeys {
//        static var header = "newheader"
//        static var footer = "newfooter"
//    }
//    
//    var headerSignal: MutableProperty<Pages> {
//        get {
//            let signal = objc_getAssociatedObject(self, &AssociatedKeys.header) as? MutableProperty<Pages>
//            if let s = signal { return s }
//            let new = MutableProperty(Pages.cover)
////            self.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak new] in
////                new?.swap(.cover)
////            })
//            
//            objc_setAssociatedObject(self, &AssociatedKeys.header, new, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            
//            return new
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedKeys.header, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    
//    fileprivate var footer_signal: MutableProperty<Pages> {
//        get {
//            let signal = objc_getAssociatedObject(self, &AssociatedKeys.footer) as? MutableProperty<Pages>
//            if let s = signal { return s }
//            let new = MutableProperty(Pages.cover)
//            
//            objc_setAssociatedObject(self, &AssociatedKeys.footer, new, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            
//            return new
//        }
//        set {
//            //            guard let value = newValue else { return }
//            objc_setAssociatedObject(self, &AssociatedKeys.footer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    
//    public typealias capturePages = () -> Pages
//    
//    
//    /// 上拉的信号
//    ///
//    /// - Parameter value: 最新的页面
//    /// - Returns: 需要请求的页面信息
//    public func footerSignal(_ value: @escaping capturePages) -> MutableProperty<Pages> {
//        
//        if let _ = mj_footer { return footer_signal }
//        
//        self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
//            self?.footer_signal.swap(value())
//        })
//        
//        return footer_signal
//    }
//    
//    public func header_Signal() -> MutableProperty<Pages> {
//        
//        if let _ = mj_header { return headerSignal }
//        
//        self.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
//            self?.headerSignal.swap(.cover)
//        })
//        
//        return headerSignal
//    }
//    
//    
//    /// 聚合了上拉和下拉的信号
//    ///
//    /// - Parameter value: 最新的页面(下拉默认为 *.cover*)
//    /// - Returns: 需要请求的页面信息
//    public func searching(_ value: @escaping capturePages) -> Signal<Pages, Never> {
//        return header_Signal().signal.merge(with: footerSignal(value).signal).skipRepeats()
//    }
//    
//}
//
extension Reactive where Base == UITableView {
    
    
    /// 绑定背景图片
    public var tableViewImage: BindingTarget<UIImageView?> {
        return makeBindingTarget { $0.backgroundView = $1 }
    }
    
    
    /// 绑定数据已无更多
    public var outOfData: BindingTarget<Bool> {
        return makeBindingTarget { tableView, outOfData  in
            tableView.endRefresh(outOfData: outOfData)
        }
    }
    
    public var error: BindingTarget<String> {
        return makeBindingTarget { tableView, error in
            tableView.reloadData()
            tableView.endRefresh(outOfData: true)
        }
    }
    
    
    /// 新值进入直接刷新
    @available(*, deprecated, message: "此方法已被废弃。使用 `reload: BindingTarget<Bool>` 进行替换")
    public var newValues: BindingTarget<Int> {
        
        return makeBindingTarget { tableView, _ in
            
            if let head = tableView.mj_header {
                head.endRefreshing()
            }
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }
    }
    
    
    /// 是否刷新 `reload`
    public var reload: BindingTarget<Bool> {
        return makeBindingTarget({ (table, value) in
            DispatchQueue.main.async {
            if !value { return }
            if let head = table.mj_header {
                head.endRefreshing()
            }
            
            
                table.reloadData()
            }
            
        })
    }
    
    
    /// 是否刷新 `reload`
    @available(*, message: "此方法正在测试中，不建议使用")
    public var reloadSection: BindingTarget<Int> {
        return makeBindingTarget({ (table, value) in
            
            if let head = table.mj_header {
                head.endRefreshing()
            }
            
            DispatchQueue.main.async {
                table.beginUpdates()
                table.reloadSections(IndexSet(integer: value), with: .automatic)
                table.endUpdates()
            }
            
        })
    }
}
