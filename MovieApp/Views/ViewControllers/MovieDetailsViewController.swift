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
    private var genresDurationText: UILabel!
    private var symbolImage: UIImageView!
    private var stackView1: UIStackView!
    private var stackView2: UIStackView!
    private var router: AppRouterProtocol!
    private var string: String!
    private var movieDetails: MovieDetailsModel!
    
    convenience init(router: AppRouterProtocol, string: String) {
            self.init()
            self.router = router
            self.string = string
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleMovie.transform = titleMovie.transform.translatedBy(x: view.frame.width, y: 0)
        dateText.transform = dateText.transform.translatedBy(x: view.frame.width, y: 0)
        genresDurationText.transform = dateText.transform.translatedBy(x: view.frame.width, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: .curveLinear,
            animations: {
                self.titleMovie.transform = .identity
            })
        
        UIView.animate(
            withDuration: 1,
            delay: 0.5,
            options: .curveLinear,
            animations: {
                self.dateText.transform = .identity
            })
        
        UIView.animate(
            withDuration: 1,
            delay: 0.75,
            options: .curveEaseInOut,
            animations: {
                self.genresDurationText.transform = .identity
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "tmdb")
        let imageView = UIImageView(image: logo)
        navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = .white
        let dataService = NetworkService()
        
        dataService.getMovieDetails(string: string) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                self.movieDetails = value
                DispatchQueue.main.async {
                    self.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        buildViews()
    }
    
    private func buildViews(){
        view.backgroundColor = .white
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews(){
        
        rectangle = UIImageView()
        view.addSubview(rectangle)
        
        titleMovie = UILabel()
        view.addSubview(titleMovie)
        
        userScorePercentage = UILabel()
        view.addSubview(userScorePercentage)
        
        userScore = UILabel()
        view.addSubview(userScore)
        userScore.text = "User Score"
        
        overview = UILabel()
        view.addSubview(overview)
        overview.text = "Overview"
        
        overviewText = UILabel()
        view.addSubview(overviewText)
        
        dateText = UILabel()
        view.addSubview(dateText)
        
        genresDurationText = UILabel()
        view.addSubview(genresDurationText)
        
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
        titleMovie.numberOfLines = 0
        titleMovie.font = .systemFont(ofSize: 24)
        
        
        userScorePercentage.textColor = .white
        userScorePercentage.font = .systemFont(ofSize: 15, weight: .bold)

        userScore.textColor = .white
        userScore.font = .systemFont(ofSize: 14, weight: .bold)
        
        dateText.textColor = .white
        dateText.font = .systemFont(ofSize: 14)

        genresDurationText.textColor = .white
        genresDurationText.numberOfLines = 0
        genresDurationText.font = .systemFont(ofSize: 14)
       

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
            $0.top.equalTo(userScore.snp.bottom).offset(10)
        }
        dateText.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(titleMovie.snp.bottom).offset(10)
        }
        genresDurationText.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(dateText.snp.bottom).offset(6)
        }
        symbolImage.snp.makeConstraints{
            $0.leading.equalTo(rectangle.snp.leading).inset(20)
            $0.top.equalTo(genresDurationText.snp.bottom).offset(10)
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
    
    private func reloadData(){
        let path = "https://image.tmdb.org/t/p/original\(movieDetails.poster_path)"
        imageBack = UIImage(named: path)
        
        rectangle.load(urlString: path)

        userScorePercentage.text = String(movieDetails.vote_average)

        overviewText.text = movieDetails.overview

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        let date: Date = dateFormatter.date(from: movieDetails.release_date)!
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateText.text = "\(dateFormatter.string(from: date)) (\(movieDetails.original_language.uppercased()))"
        
        var attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)]
        let name = NSMutableAttributedString(string: "\(movieDetails.title) ", attributes:attrs)
        let year = NSMutableAttributedString(string: "")
        let attributedString = NSMutableAttributedString()
        attributedString.append(name)
        attributedString.append(year)
        titleMovie.attributedText = attributedString
        
        attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .bold)]
        var genres = ""
        for genre in movieDetails.genres {
            genres = genres + genre.name + ", "
        }
        genres.removeLast(2)
        let type = NSMutableAttributedString(string: "\(genres) ")
        let (h, m) = minutesToHoursMinutes(min: movieDetails.runtime)
        let runtime = "\(h)h \(m)m"
        let duration = NSMutableAttributedString(string: runtime, attributes:attrs)
        let attributedString2 = NSMutableAttributedString()
        attributedString2.append(type)
        attributedString2.append(duration)
        genresDurationText.attributedText = attributedString2
    }
    
    func minutesToHoursMinutes(min: Int) -> (Int, Int) {
        return (min / 60, (min % 60))
    }
}
