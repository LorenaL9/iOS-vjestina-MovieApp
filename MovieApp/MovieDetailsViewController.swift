//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Lorena Lazar on 3/29/22.
//

import Foundation
import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController{
    
    private var backgroundColor: UIColor
    private var imageBack: UIImage!
    private var rectangle: UIImageView!
    private var userScorePercentage: UILabel!
    private var userScore: UILabel!
    private var titleMovie: UILabel!
    private var overview: UILabel!
    private var overviewText: UILabel!
    private var dateText: UILabel!
    private var typeText: UILabel!
    private var durationText: UILabel!
    private var symbolImage: UIImageView!
    private var stackView1: UIStackView!
    private var stackView2: UIStackView!

    class tableLabel{
        var name: String
        var job: String
        
        init(name: String, job: String) {
                self.name = name
                self.job = job
        }
        func createTableLabel() -> UIStackView{
            let tableLabel = UIStackView()
            let label1 = UILabel()
            let label2 = UILabel()
            label1.text = name
            label2.text = job
            label1.font = .systemFont(ofSize: 14, weight: .bold)

            tableLabel.axis = .vertical
            tableLabel.alignment = .fill
            tableLabel.distribution = .equalSpacing
            tableLabel.addArrangedSubview(label1)
            tableLabel.addArrangedSubview(label2)
            return tableLabel
        }
    }
    
    init(backgroundColor: UIColor){
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(backgroundColor: .white)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
    }
    
    private func buildViews(){
        view.backgroundColor = .white
        createViews()
        styleViews()
        defineLayoutForViews()
        
    }
    private func createViews(){
        imageBack = UIImage(named: "iron-man1.jpg")
        
        
        rectangle = UIImageView()
        view.addSubview(rectangle)
        
        titleMovie = UILabel()
        titleMovie.text = "Iron man (2008)"
        view.addSubview(titleMovie)
        
        userScorePercentage = UILabel()
        view.addSubview(userScorePercentage)
        userScorePercentage.text = "76%"
        
        userScore = UILabel()
        view.addSubview(userScore)
        userScore.text = "User Score"
        
        overview = UILabel()
        view.addSubview(overview)
        overview.text = "Overview"
        
        overviewText = UILabel()
        view.addSubview(overviewText)
        overviewText.text = "After being held captive in an Afghan cave, billionare engineer Tony Stark creates a unique weaponized suit of armor to fight evil."
        
        dateText = UILabel()
        view.addSubview(dateText)
        dateText.text = "05/02/2008 (US)"
        
        typeText = UILabel()
        view.addSubview(typeText)
        typeText.text = "Action, Science Fiction, Adventure"
        
        durationText = UILabel()
        view.addSubview(durationText)
        durationText.text = "2h 6m"
        
        symbolImage =  UIImageView()
        rectangle.addSubview(symbolImage)
        symbolImage.image = UIImage(systemName: "star")
        
        stackView1 = UIStackView()
        view.addSubview(stackView1)
        
        let l1 = tableLabel(name: "Don Heck", job: "Characters")
        stackView1.addArrangedSubview(l1.createTableLabel())
        let l2 = tableLabel(name: "Jack Kirby", job: "Characters")
        stackView1.addArrangedSubview(l2.createTableLabel())
        let l3 = tableLabel(name: "Jon Favreau", job: "Director")
        stackView1.addArrangedSubview(l3.createTableLabel())
        
        stackView2 = UIStackView()
        view.addSubview(stackView2)
        
        let l4 = tableLabel(name: "Don Heck", job: "Screenplay")
        stackView2.addArrangedSubview(l4.createTableLabel())
        let l5 = tableLabel(name: "  Jack Marcum", job: "  Screenplay")
        stackView2.addArrangedSubview(l5.createTableLabel())
        let l6 = tableLabel(name: "Matt Holloway", job: "Screenplay")
        stackView2.addArrangedSubview(l6.createTableLabel())
    }
    
    private func styleViews(){
        rectangle.contentMode = .scaleAspectFill
        rectangle.clipsToBounds = true
        rectangle.image = imageBack
        
        let coverLayer = CAGradientLayer()
        coverLayer.colors = [
          UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
          UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        ]
        coverLayer.locations = [0, 1]
        coverLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        coverLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        coverLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
        coverLayer.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        coverLayer.position = rectangle.center
        coverLayer.opacity = 0.7
        rectangle.layer.addSublayer(coverLayer)
        
        titleMovie.textColor = .white
        titleMovie.font = .systemFont(ofSize: 24, weight: .bold)
        
        userScorePercentage.textColor = .white
        userScorePercentage.font = .systemFont(ofSize: 15, weight: .bold)

        userScore.textColor = .white
        userScore.font = .systemFont(ofSize: 14, weight: .bold)
        
        dateText.textColor = .white
        dateText.font = .systemFont(ofSize: 14)

        typeText.textColor = .white
        typeText.font = .systemFont(ofSize: 14)

        durationText.textColor = .white
        durationText.font = .systemFont(ofSize: 14, weight: .bold)

        overview.textColor = .black
        overview.font = .systemFont(ofSize: 20, weight: .bold)

        overviewText.textColor = .black
        overviewText.numberOfLines = 0
        overviewText.font = .systemFont(ofSize: 16)
        
        symbolImage.contentMode = .center
        symbolImage.tintColor = .white
        symbolImage.backgroundColor = .gray
        symbolImage.layer.cornerRadius = 15
        
        stackView1.axis = .horizontal
        stackView1.alignment = .fill
        stackView1.distribution = .fillProportionally
        stackView1.spacing = 10
        
        stackView2.axis = .horizontal
        stackView2.alignment = .fill
        stackView2.distribution = .fillProportionally
        stackView2.spacing = 10
    }
    
    private func defineLayoutForViews( ){
        rectangle.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(300)
        }
        userScorePercentage.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(rectangle.snp.top).offset(120)
        }
        userScore.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(80)
            $0.top.equalTo(rectangle.snp.top).offset(120)
        }
        titleMovie.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalTo(userScore.snp.bottom).offset(14)
        }
        dateText.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalTo(titleMovie.snp.bottom).offset(14)
        }
        typeText.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalTo(dateText.snp.bottom).offset(6)
        }
        durationText.snp.makeConstraints{
            $0.leading.equalTo(typeText.snp.trailing).inset(-6)
            $0.top.equalTo(dateText.snp.bottom).offset(6)
        }
        symbolImage.snp.makeConstraints{
            $0.leading.equalTo(rectangle.snp.leading).inset(20)
            $0.top.equalTo(typeText.snp.bottom).offset(15)
            $0.height.width.equalTo(30)
        }
        overview.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(18)
            $0.top.equalTo(rectangle.snp.bottom).offset(18)
        }
        overviewText.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(overview.snp.bottom).offset(10)
        }
        stackView1.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(overviewText.snp.bottom).offset(20)
        }
        stackView2.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(stackView1.snp.bottom).offset(20)
        }
    }
}
