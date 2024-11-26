import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        let trackersNavController = UINavigationController(rootViewController: trackersViewController)
        trackersNavController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tab_trackers"),
            selectedImage: nil
        )
        
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tab_stats"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersNavController, statsViewController]
        tabBar.backgroundColor = .white
        
        // дивайдер
        let divider = CALayer()
        divider.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        divider.backgroundColor = UIColor(named: "Gray")?.cgColor
        tabBar.layer.addSublayer(divider)
    }
}
