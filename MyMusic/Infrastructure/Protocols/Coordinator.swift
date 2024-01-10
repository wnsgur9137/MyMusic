//
//  Coordinator.swift
//  MyMusic
//
//  Created by JunHyeok Lee on 1/10/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType { get }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

enum CoordinatorType {
    case tab, home, setting
}

