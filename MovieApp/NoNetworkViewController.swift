//
//  NoNetworkViewController.swift
//  MovieApp
//
//  Created by Lorena Lazar on 5/8/22.
//

import Foundation
import UIKit
import SnapKit

class NoNetworkViewController: UIViewController {
    private var router: AppRouterProtocol!
    private var text: UILabel!
    
    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "tmdb")
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = .white
        buildViews()
    }
    
    private func buildViews() {
        view.backgroundColor = .white
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        text = UILabel()
        view.addSubview(text)
    }
    
    func styleViews() {
        text.text = "There is no Internet connection"
        text.numberOfLines = 0
        text.textAlignment = .center
        text.textColor = .gray
    }
    
    func defineLayoutForViews() {
        text.snp.makeConstraints {
            $0.centerX.centerY.equalTo(self.view)
            $0.width.equalTo(300)
        }
        
    }
}
