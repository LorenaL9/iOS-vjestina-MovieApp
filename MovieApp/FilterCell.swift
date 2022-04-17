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


protocol FilterCellDelegate: AnyObject{
    func clickedOn(cell: FilterCell)
}

class FilterCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: FilterCell.self)
    private var filterLabel : UIButton!
    private var underline: UILabel!
    
    weak var delegate: FilterCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
        styleViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                underline.isHidden = false
                filterLabel.titleLabel!.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            } else {
                underline.isHidden = true
                filterLabel.titleLabel!.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            }
         }
    }
    
    func buildViews() {
        filterLabel = UIButton()
        addSubview(filterLabel)
        filterLabel.addTarget(self, action: #selector(onClickButton), for: .touchUpInside)
        
        underline = UILabel()
        addSubview(underline)
    }

    private func styleViews(){
        filterLabel.setTitleColor(.black, for: .normal)
        
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
    
    func setFilter(index: Int, group: MovieGroup) {
        
        filterLabel.setTitle("\(group.filters[index].title)", for: .normal)
        if index == 0{
            underline.isHidden = false
            filterLabel.titleLabel!.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        }
    }
    
    @objc func onClickButton() {
        isSelected = true
        delegate?.clickedOn(cell: self)
    }
}

