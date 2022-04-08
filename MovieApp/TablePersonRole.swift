//
//  TablePersonRole.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/8/22.
//

import UIKit

class TablePersonRole: UIStackView {
    var name: String
    var job: String

    init(name: String, job: String) {
        self.name = name
        self.job = job
        super.init(frame: .zero)

        let label1 = UILabel()
        let label2 = UILabel()

        label1.text = name
        label2.text = job
        label1.font = .systemFont(ofSize: 14, weight: .bold)
        label2.font = .systemFont(ofSize: 14)

        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        addArrangedSubview(label1)
        addArrangedSubview(label2)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
