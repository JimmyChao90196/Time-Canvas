//
//  TabbarController.swift
//  TimeCanvas
//
//  Created by JimmyChao on 2024/2/5.
//

import Foundation
import UIKit

protocol TabProtocol {
    var defaultImage: UIImage { get }
    var selectedImage: UIImage { get }
    var bgColor: UIColor { get }
    var title: String { get }
    var viewController: UIViewController { get }
}

class TabbarController: UITabBarController {
    
    enum TabConfig: String, CaseIterable, TabProtocol {
        case kanban = "kanban"
        case chart = "analysis"
        case profile = "profile"
        
        var title: String {
            self.rawValue
        }
        
        var defaultImage: UIImage {
            switch self {
            case .kanban:
                UIImage(systemName: "list.bullet.clipboard")!
            case .chart:
                UIImage(systemName: "chart.bar")!
            case .profile:
                UIImage(systemName: "person.crop.circle")!
            }
        }
        
        var selectedImage: UIImage {
            switch self {
            case .kanban:
                UIImage(systemName: "list.bullet.clipboard.fill")!
            case .chart:
                UIImage(systemName: "chart.bar.fill")!
            case .profile:
                UIImage(systemName: "person.crop.circle.fill")!
            }
        }
        
        var bgColor: UIColor {
            switch self {
            case .kanban:
                UIColor.red
            case .chart:
                UIColor.blue
            case .profile:
                UIColor.green
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .kanban:
                return KanbanViewController()
            case .chart:
                return ChartViewController()
            case .profile:
                return ProfileViewController()
            }
        }
    }
    
    let tabConfigs: [TabConfig] = [.kanban, .chart, .profile]
    let navFactory = NavControllerFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = navFactory.createNavControllers(withEnumOfTabs: tabConfigs)
        
        // Setup Appearance
        let tabBarApearance = UITabBarAppearance()
        tabBarApearance.backgroundColor = .white
        tabBar.scrollEdgeAppearance = tabBarApearance
        tabBar.standardAppearance = tabBarApearance
    }
}

class NavControllerFactory {
    
    func createNavControllers(withEnumOfTabs tabConfigs: [TabProtocol]) -> [UINavigationController] {
        let navControllers: [UINavigationController] = tabConfigs.enumerated().map { index, tabConfig in
            let navigationController = createNavController(
                color: tabConfig.bgColor,
                tag: index,
                defaultImage: tabConfig.defaultImage,
                selectedImage: tabConfig.selectedImage,
                viewController: tabConfig.viewController
            )
            
            navigationController.viewControllers.first?.title = tabConfig.title
            return navigationController
        }
        return navControllers
    }
    
    private func createNavController(
        color: UIColor,
        tag: Int,
        defaultImage: UIImage,
        selectedImage: UIImage,
        viewController: UIViewController) -> UINavigationController{
            
            viewController.view.backgroundColor = color
            
            let newNavController = UINavigationController(rootViewController: viewController)
            newNavController.tabBarItem.tag = tag
            newNavController.tabBarItem.image = defaultImage
            newNavController.tabBarItem.selectedImage = selectedImage
            return newNavController
        }
}
