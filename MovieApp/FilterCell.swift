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
    private var filterLabel : UILabel!
    private var underline: UIView!
    
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
        filterLabel = UILabel()
        addSubview(filterLabel)
        
        underline = UIView()
        addSubview(underline)
    }

    private func styleViews(){
        filterLabel.textAlignment = .center
        filterLabel.font = UIFont.systemFont(ofSize: 18)
        
        underline.backgroundColor = .black
        underline.isHidden = true
    }

    func addConstraints() {
        
        filterLabel.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(0)
            $0.leading.trailing.equalToSuperview().inset(0)
        }
        underline.snp.makeConstraints{
            $0.top.equalTo(filterLabel.snp.bottom).offset(0)
            $0.trailing.leading.equalToSuperview().inset(0)
            $0.height.equalTo(3)
        }
    }
    
    func setFilter(filters: FilterCellModel) {
        
        filterLabel.text = "\(filters.filters.title)"
        
        if filters.underline == true{
            underline.isHidden = false
            filterLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        } else {
            underline.isHidden = true
            filterLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        }
    }
}
