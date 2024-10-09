import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "tab_trackers"), selectedImage: nil)
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "tab_stats"), selectedImage: nil)
        
        self.viewControllers = [trackersViewController, statsViewController]
        tabBar.backgroundColor = .white
    }
}
