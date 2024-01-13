//
//  AlertBuilder.swift
//  MyMusic
//
//  Created by JUNHYEOK LEE on 1/13/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol AlertBuilder {
    func reset()
    func set(alertType: AlertType)
    func set(title: String)
    func set(message: String)
    func set(messageAlignment: NSTextAlignment)
    func set(confirmTitle: String)
    func set(cancelTitle: String)
    func add(confirmAction: @escaping ()->Void)
    func add(cancelAction: @escaping ()->Void)
    func build(_ viewController: UIViewController)
}

enum AlertType {
    case singleButton
    case horizontalButton
    case verticalButton
}

final class DefaultAlertBuilder: AlertBuilder {
    private var alertView: AlertBaseView = {
        let alertView = AlertBaseView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.alpha = 0
        return alertView
    }()
    
    private let dimmView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray.withAlphaComponent(0.75)
        view.alpha = 0
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    init() {
        setupAlertViewButtonActions()
    }
    
    private func setupAlertViewButtonActions() {
        alertView.confirmButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.removeAlert()
            })
            .disposed(by: disposeBag)
        
        alertView.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.removeAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func removeAlert() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.alertView.alpha = 0
                self.dimmView.alpha = 0
            },
            completion: { _ in
                self.dimmView.removeFromSuperview()
                self.alertView.removeFromSuperview()
            })
    }
}

extension DefaultAlertBuilder {
    func set(alertType: AlertType) {
        switch alertType {
        case .singleButton:
            alertView.removeCancelButton()
            
        case .horizontalButton:
            alertView.configure(buttonAxis: .horizontal)
            
        case .verticalButton:
            alertView.configure(buttonAxis: .vertical)
        }
    }
    
    func reset() {
        alertView = AlertBaseView()
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.alpha = 0
    }
    
    func set(title: String) {
        alertView.titleLabel.text = title
    }
    
    func set(message: String) {
        alertView.messageLabel.text = message
    }
    
    func set(messageAlignment alignment: NSTextAlignment) {
        alertView.messageLabel.textAlignment = alignment
    }
    
    func set(confirmTitle title: String) {
        alertView.confirmButton.setTitle(title, for: .normal)
    }
    
    func set(cancelTitle title: String) {
        alertView.cancelButton.setTitle(title, for: .normal)
    }
    
    func add(confirmAction: @escaping () -> Void) {
        alertView.confirmButton.rx.tap
            .asDriver()
            .drive(onNext: {
                confirmAction()
            })
            .disposed(by: disposeBag)
    }
    
    func add(cancelAction: @escaping () -> Void) {
        alertView.confirmButton.rx.tap
            .asDriver()
            .drive(onNext: {
                cancelAction()
            })
            .disposed(by: disposeBag)
    }
    
    func build(_ viewController: UIViewController) {
        viewController.view.addSubview(dimmView)
        viewController.view.addSubview(alertView)
        
        dimmView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        dimmView.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        dimmView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        dimmView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        
        alertView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor).isActive = true
        alertView.widthAnchor.constraint(equalTo: viewController.view.widthAnchor, multiplier: 0.8).isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.alertView.alpha = 1.0
            self.dimmView.alpha = 1.0
        }
    }
}
