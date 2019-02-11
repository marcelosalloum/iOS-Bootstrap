//
//  Coordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 01/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

// MARK: - Deintiable Coordinator
/// When a ViewController is removed from the stack, it's Coordinator is atomatically dealocated
protocol DeInitCallable: AnyObject {
    var onDeinit: (() -> Void)? { get set }
}

class CoordinatedViewController: UIViewController, DeInitCallable {

    var onDeinit: (() -> Void)?
    deinit {
        onDeinit?()
    }
}

protocol CoordinatorProtocol: AnyObject {
    // Start and stopdefault functions
    func start()
    var stop: (() -> Void)? { get set }
    // method and variable used to make coordinators easy to deallocate
    func setDeallocallable(with object: DeInitCallable)
    var deallocallable: DeInitCallable? { get set }

    /// The array containing any child Coordinators
    var childCoordinators: [Coordinator] { get set }
}

extension CoordinatorProtocol {
    /// Sets the key Deallocable object for a coordinator
    /// This enables dealloacation of the coordinator once the object gets deallocated via onDeinit closure.
    func setDeallocallable(with object: DeInitCallable) {
        deallocallable?.onDeinit = nil
        object.onDeinit = { [weak self] in
            self?.stop?()
        }
        deallocallable = object
    }

    /// Add a child coordinator to the parent
    func addChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }

    /// Remove a child coordinator from the parent
    func removeChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }

}

// MARK: - Declaring the cordinator base class
class Coordinator: NSObject, CoordinatorProtocol {

    // MARK: Properties
    func start() { }
    var stop: (() -> Void)?
    weak var deallocallable: DeInitCallable?

    var childCoordinators = [Coordinator]()

    func startCoordinator(_ childCoordinator: Coordinator) {
        childCoordinator.start()
        childCoordinator.stop = {
            self.removeChildCoordinator(childCoordinator: childCoordinator)
        }
        self.addChildCoordinator(childCoordinator: childCoordinator)
    }
}
