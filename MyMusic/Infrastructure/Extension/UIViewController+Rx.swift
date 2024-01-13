//
//  UIViewController+Rx.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/11/24.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - UIViewController
public enum ViewControllerState {
    case notloaded, hidden, hiding, showing, shown
}

extension Reactive where Base: UIViewController {
    public var viewDidLoad: Observable<Void> {
        return sentMessage(#selector(base.viewDidLoad)).mapToVoid()
    }
    public var viewWillAppear: Observable<Void> {
        return sentMessage(#selector(base.viewWillAppear(_:))).mapToVoid()
    }
    public var viewDidAppear: Observable<Void> {
        return sentMessage(#selector(base.viewDidAppear(_:))).mapToVoid()
    }
    public var viewDidDisappear: Observable<Void> {
        return sentMessage(#selector(base.viewDidDisappear(_:))).mapToVoid()
    }
    public var viewWillDisappear: Observable<Void> {
        return sentMessage(#selector(base.viewWillDisappear(_:))).mapToVoid()
    }
    public var viewDidLayoutSubviews: Observable<Void> {
        return sentMessage(#selector(base.viewDidLayoutSubviews)).mapToVoid()
    }
    public var viewEvent: Observable<ViewControllerState> {
        let willAppear = viewWillAppear.map{ _ -> ViewControllerState in return .showing }
        let didAppear = viewDidAppear.map{ _ -> ViewControllerState in return .shown }
        let willDisappear = viewWillDisappear.map{ _ -> ViewControllerState in return .hiding }
        let didDisappear = viewDidDisappear.map{ _ -> ViewControllerState in return .hidden }
        return  Observable.of(willAppear,didAppear,willDisappear,didDisappear).merge()
    }
}

// MARK: - UIView
extension Reactive where Base: UIView {
    public var layoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(UIView.layoutSubviews))
    }
}
