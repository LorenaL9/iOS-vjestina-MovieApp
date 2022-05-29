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
    func showMovieDetailsViewController(string: String)
    func showMovieDetailsViewControllerFavorites(string: String)
    func noNetwork()
}

class AppRouter: AppRouterProtocol {
    private let navigationController: UINavigationController!
    private var movieListViewNC: UINavigationController!
    private var favoritesViewNC: UINavigationController!
    private var networkStatus: NetworkStatus!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.networkStatus = NetworkStatus()
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
        favoritesViewNC = UINavigationController(rootViewController: favoritesViewC)
        favoritesViewNC.tabBarItem = UITabBarItem.init(title: "Favorites", image: UIImage(named: "favorites"), tag: 1)
        favoritesViewNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        favoritesViewNC.navigationBar.standardAppearance = navBarAppearance
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [movieListViewNC, favoritesViewNC]
        
        networkStatus.monitorNetwork()
        navigationController.pushViewController(tabBarController, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    func showMovieDetailsViewController(string: String) {
        let vc = MovieDetailsViewController(router: self, string: string)

        movieListViewNC.pushViewController(vc, animated: true)

    }

    func showMovieDetailsViewControllerFavorites(string: String) {
        let vc = MovieDetailsViewController(router: self, string: string)
        favoritesViewNC.pushViewController(vc, animated: true)
    }
    func noNetwork() {
        let noNet = NoNetworkViewController(router: self)
        navigationController.pushViewController(noNet, animated: true)
    }
}
