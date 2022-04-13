//
//  FilterCell.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/10/22.
//

import Foundation
import UIKit
import SnapKit
import MovieAppData


class FilterCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FilterCell.self)

    private var filterLabel : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
        styleViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildViews() {
        filterLabel = UIButton()
        addSubview(filterLabel)

    }
    func setFilter(index: Int, group: MovieGroup) {
    //    let group = ["On TV", "Streaming", "For Rent"]
        
//        let imageUrl = movies.map { $0.imageUrl}
        filterLabel.setTitle("\(group.filters[index])", for: .normal)
        filterLabel.setTitleColor(.black, for: .normal)

        
    }

    private func styleViews(){

    }

    func addConstraints() {
        filterLabel.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(0)
            $0.leading.trailing.equalToSuperview().inset(0)
        }
    }
}

