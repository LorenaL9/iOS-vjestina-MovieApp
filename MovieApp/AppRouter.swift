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
    private var movieListViewNC: UINavigationController!
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
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(red: 0.043, green: 0.145, blue: 0.247, alpha: 1)
        
        let movieListViewC = MovieListViewController(router: self)
        movieListViewNC = UINavigationController(rootViewController: movieListViewC)
        movieListViewNC.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "home"), tag: 0)
        movieListViewNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        movieListViewNC.navigationBar.standardAppearance = navBarAppearance
        
        let favoritesViewC = FavoritesViewController(router: self)
        let favoritesViewNC = UINavigationController(rootViewController: favoritesViewC)
        favoritesViewNC.tabBarItem = UITabBarItem.init(title: "Favorites", image: UIImage(named: "favorites"), tag: 1)
        favoritesViewNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        favoritesViewNC.navigationBar.standardAppearance = navBarAppearance
        
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [movieListViewNC, favoritesViewNC]
    
        
//        monitorNetwork()
//        sleep(1)
        
//        if checkNetwork == true {
            navigationController.pushViewController(tabBarController, animated: false)
            
//        } else {
//            noNetwork()
//        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    func showMovieDetailsViewController(url: URL) {
        let vc = MovieDetailsViewController(router: self, url: url)
//        monitorNetwork()
//        sleep(1)
//        if checkNetwork == true {
            movieListViewNC.pushViewController(vc, animated: true)
//        } else {
//            noNetwork()
//        }
    }

    func noNetwork() {
        let noNet = NoNetworkViewController(router: self)
        navigationController.pushViewController(noNet, animated: true)
    }
}
