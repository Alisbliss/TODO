//
//  TodoListRouterTests.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 10.03.2026.
//

import Testing
import UIKit
@testable import TODO

// MARK: - Mocks
final class ListMockNavigationController: UINavigationController {
    var pushedVC: UIViewController?
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

final class ListMockViewController: UIViewController {
    var presentedVC: UIViewController?
    var mockNav: ListMockNavigationController?
    
    override var navigationController: UINavigationController? { mockNav }
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedVC = viewControllerToPresent
    }
}

// MARK: - Tests
@Suite("Todo List Router Tests")
@MainActor
struct TodoListRouterTests {
    
    @Test("Verify showing menu overlay")
    func testShowMenu() {
        let testRouter = TodoListRouter()
        let mockVC = ListMockViewController()
        testRouter.viewController = mockVC
        let item = TodoItem(id: 1, todo: "Test", description: "", completed: false, date: "")
        testRouter.showTodoMenu(for: item)
        
        #expect(mockVC.presentedVC is TodoDetailOverlayViewController)
    }

    @Test("Verify navigation to creation screen")
    func testNavigateToCreate() {
        let testRouter = TodoListRouter()
        let mockVC = ListMockViewController()
        let mockNav = ListMockNavigationController(rootViewController: mockVC)
        mockVC.mockNav = mockNav
        testRouter.viewController = mockVC
        testRouter.navigateToCreate()
        
        #expect(mockNav.pushedVC is TodoItemController)
    }
}
