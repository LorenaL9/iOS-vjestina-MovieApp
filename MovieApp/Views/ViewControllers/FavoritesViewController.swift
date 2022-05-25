//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/3/22.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController{
    
    private var router: AppRouterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "tmdb")
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
        buildViews()
    }
    
    private func buildViews(){
        view.backgroundColor = .white
       
    }
    
    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
}
