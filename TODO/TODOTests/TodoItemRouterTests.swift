//
//  TodoItemRouterTests.swift
//  TODO
//
//  Created by Алеся Афанасенкова on 10.03.2026.
//

import UIKit
import Testing
@testable import TODO

final class TodoItemMockNavigationController: UINavigationController {
    var popToRootCalled = false
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        popToRootCalled = true
        return nil
    }
}

final class TodoItemMockViewController: UIViewController {
    var mockNavigation: TodoItemMockNavigationController?
    
    override var navigationController: UINavigationController? {
        return mockNavigation
    }
}

@Suite("Todo Item Router Tests")
@MainActor
struct TodoItemRouterTests {

    @Test("Verify pop to root navigation method")
    func testPopToRoot() {
        let testRouter = TodoItemRouter()
        let mockVC = TodoItemMockViewController()
        let mockNav = TodoItemMockNavigationController(rootViewController: mockVC)
        
        mockVC.mockNavigation = mockNav
        testRouter.viewController = mockVC
        
        testRouter.popToRoot()
        
        #expect(mockNav.popToRootCalled == true)
    }

    @Test("Verify module assembly (createModule)")
    func testCreateModule() {
        let vc = TodoItemRouter.createModule(with: nil)
        
        #expect(vc is TodoItemController)
    }
}
