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
    
    private var imageBack: UIImage!
    private var rectangle: UIImageView!
    private var userScorePercentage: UILabel!
    private var userScore: UILabel!
    private var titleMovie: UILabel!
    private var overview: UILabel!
    private var overviewText: UILabel!
    private var dateText: UILabel!
    private var typeDurationText: UILabel!
    private var symbolImage: UIImageView!
    private var stackView1: UIStackView!
    private var stackView2: UIStackView!
    
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
        
        typeDurationText = UILabel()
        view.addSubview(typeDurationText)
        
        symbolImage =  UIImageView()
        rectangle.addSubview(symbolImage)
        symbolImage.image = UIImage(named: "star.png")
        
        stackView1 = UIStackView()
        view.addSubview(stackView1)
        
        let l1 = TablePersonRole(name: "Don Heck", job: "Characters")
        stackView1.addArrangedSubview(l1)
        let l2 = TablePersonRole(name: "Jack Kirby", job: "Characters")
        stackView1.addArrangedSubview(l2)
        let l3 = TablePersonRole(name: "Jon Favreau", job: "Director")
        stackView1.addArrangedSubview(l3)
        
        stackView2 = UIStackView()
        view.addSubview(stackView2)
        
        let l4 = TablePersonRole(name: "Don Heck", job: "Screenplay")
        stackView2.addArrangedSubview(l4)
        let l5 = TablePersonRole(name: "Jack Marcum", job: "Screenplay")
        stackView2.addArrangedSubview(l5)
        let l6 = TablePersonRole(name: "Matt Holloway", job: "Screenplay")
        stackView2.addArrangedSubview(l6)
    }
    
    private func styleViews(){
        rectangle.contentMode = .scaleAspectFill
        rectangle.clipsToBounds = true
        rectangle.image = imageBack
        rectangle.frame = CGRect(x: 0, y: 0, width: 100, height: 300)
        
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
        rectangle.layer.insertSublayer(coverLayer, at: 0)
        
        titleMovie.textColor = .white
        titleMovie.font = .systemFont(ofSize: 24)
        var attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)]
        let name = NSMutableAttributedString(string: "Iron man ", attributes:attrs)
        let year = NSMutableAttributedString(string: "(2008)")
        let attributedString = NSMutableAttributedString()
        attributedString.append(name)
        attributedString.append(year)
        titleMovie.attributedText = attributedString
        
        userScorePercentage.textColor = .white
        userScorePercentage.font = .systemFont(ofSize: 15, weight: .bold)

        userScore.textColor = .white
        userScore.font = .systemFont(ofSize: 14, weight: .bold)
        
        dateText.textColor = .white
        dateText.font = .systemFont(ofSize: 14)

        typeDurationText.textColor = .white
        typeDurationText.font = .systemFont(ofSize: 14)
        attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .bold)]
        let type = NSMutableAttributedString(string: "Action, Science Fiction, Adventure ")
        let duration = NSMutableAttributedString(string: "2h 6m", attributes:attrs)
        let attributedString2 = NSMutableAttributedString()
        attributedString2.append(type)
        attributedString2.append(duration)
        typeDurationText.attributedText = attributedString2

        overview.textColor = .black
        overview.font = .systemFont(ofSize: 20, weight: .bold)

        overviewText.textColor = .black
        overviewText.numberOfLines = 0
        overviewText.font = .systemFont(ofSize: 14)
        
        symbolImage.contentMode = .center
        symbolImage.layer.cornerRadius = 15
        
        stackView1.axis = .horizontal
        stackView1.alignment = .fill
        stackView1.distribution = .fillEqually
        stackView1.spacing = 10
        
        stackView2.axis = .horizontal
        stackView2.alignment = .fill
        stackView2.distribution = .fillEqually
        stackView2.spacing = 10
    }
    
    private func defineLayoutForViews( ){
        rectangle.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
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
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(userScore.snp.bottom).offset(14)
        }
        dateText.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(titleMovie.snp.bottom).offset(14)
        }
        typeDurationText.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(dateText.snp.bottom).offset(6)
        }
        symbolImage.snp.makeConstraints{
            $0.leading.equalTo(rectangle.snp.leading).inset(20)
            $0.top.equalTo(typeDurationText.snp.bottom).offset(15)
        }
        overview.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(18)
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
