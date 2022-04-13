//
//  ListOfMovieCollectionView.swift
//  MovieApp
//
//  Created by Lorena Lazar on 4/10/22.
//

import Foundation
import UIKit
import SnapKit

class ListOfMoviesCollectionView: UICollectionView {
    
    
    
}
extension ListOfMoviesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        return CGSize(width: collectionViewWidth - 2 * 10, height: 170)
    }
}
extension ListOfMoviesCollectionView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListOfMoviesCollectionViewCell.reuseIdentifier, for: indexPath) as? ListOfMoviesCollectionViewCell
        else {
            fatalError()
        }
        return cell
    }

}
