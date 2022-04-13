//
//  SearchBarView.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/9/22.
//

import UIKit
import SnapKit

protocol SearchInFokusDelegate: AnyObject {
    func inFocus(bool: Bool)
}

class SearchBarView: UIView {
    private var searchImage: UIImageView!
    private var textInput: UITextField!
    private var xButton: UIButton!
    private var cancelButton: UIButton!
    private var grayLayout: UIView!
    private var grayLayout2: UIView!

    
    weak var delegate: SearchInFokusDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        buildViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews(){
        grayLayout = UIView()
        addSubview(grayLayout)
        
        grayLayout2 = UIView()
        addSubview(grayLayout2)
        
        searchImage = UIImageView()
        addSubview(searchImage)
        
        textInput = UITextField()
        addSubview(textInput)
        
        xButton = UIButton()
        addSubview(xButton)
        xButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        cancelButton = UIButton()
        addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
    }
    func styleViews(){
        grayLayout.layer.backgroundColor = UIColor(red: 0.917, green: 0.917, blue: 0.921, alpha: 1).cgColor
        grayLayout.layer.cornerRadius = 10
        
        grayLayout2.layer.backgroundColor = UIColor(red: 0.917, green: 0.917, blue: 0.921, alpha: 1).cgColor
        grayLayout2.layer.cornerRadius = 10
        
        
        textInput.placeholder = "Search"
        textInput.textColor = .gray
        textInput.delegate = self
        
        let imageMagnifyingGlass = UIImage(named: "magnifyingglass.png")
        searchImage.image = imageMagnifyingGlass

        let xmark = UIImage(systemName: "xmark")
        xButton.setImage(xmark, for: .normal)
        xButton.tintColor = .black
        xButton.isHidden = true
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.isHidden = true
        
    }
    func defineLayoutForViews(){
        grayLayout.snp.makeConstraints{
            $0.leading.top.trailing.bottom.equalToSuperview().inset(0)
        }
        grayLayout2.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview().inset(0)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(60)
        }
        
        textInput.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().inset(85)
            $0.top.equalToSuperview().offset(10)
        }
        
        searchImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        xButton.snp.makeConstraints{
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(70)
            $0.top.equalToSuperview().inset(10)
            
        }
        
        cancelButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(0)
            $0.top.equalToSuperview().offset(5)
        }
    }
    @objc func onClick(sender: UIButton!){
        print("KLIIK")
        textInput.text = nil
    }
    
    @objc func cancelAction() {
        print("cancel")
        textFieldDidEndEditing(textInput)
    }
}

extension SearchBarView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.inFocus(bool: true)
        print("POCELoo")
        xButton.isHidden = false
        cancelButton.isHidden = false
        grayLayout.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.inFocus(bool: false)
        print("gotovo")
        xButton.isHidden = true
        cancelButton.isHidden = true
        grayLayout.isHidden = false
        textInput.isEnabled = false
    }
}

