//
//  AppRouter.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/6/22.
//

import Foundation
import UIKit
import Network

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showMovieDetailsViewController(url: URL)
    func noNetwork()
    func monitorNetwork()
}

class AppRouter: AppRouterProtocol {
    private let navigationController: UINavigationController!
    private var checkNetwork: Bool!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func monitorNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.checkNetwork = true
            } else {
                print("No connection.")
                self.checkNetwork = false
            }

            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
  
    
    func setStartScreen(in window: UIWindow?) {
        
        let movieListViewC = MovieListViewController(router: self)
        movieListViewC.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "home"), tag: 0)

        let favoritesViewC = FavoritesViewController(router: self)
        favoritesViewC.tabBarItem = UITabBarItem.init(title: "Favorites", image: UIImage(named: "favorites"), tag: 1)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [movieListViewC, favoritesViewC]
        
        let logo = UIImage(named: "tmdb")
        let imageView = UIImageView(image: logo)
        tabBarController.navigationItem.titleView = imageView
        
        monitorNetwork()
        sleep(1)
        
        if checkNetwork == true {
            navigationController.pushViewController(tabBarController, animated: false)

        } else {
            noNetwork()
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    func showMovieDetailsViewController(url: URL) {
        let vc = MovieDetailsViewController(router: self, url: url)
        monitorNetwork()
        sleep(1)
        if checkNetwork == true {
            navigationController.pushViewController(vc, animated: true)
        } else {
            noNetwork()
        }
    }

    func noNetwork() {
        let noNet = NoNetworkViewController(router: self)
        navigationController.pushViewController(noNet, animated: true)
    }
}
