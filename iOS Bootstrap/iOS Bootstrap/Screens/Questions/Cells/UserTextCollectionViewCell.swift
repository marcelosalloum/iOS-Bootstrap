//
//  UserTextCollectionViewCell.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 07/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit

class UserTextCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var innerCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        innerCollectionView.delegate = self
        innerCollectionView.dataSource = self
    }
}

extension UserTextCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: InnerCardCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! InnerCardCollectionViewCell
        cell.backgroundColor = UIColor.init(displayP3Red: CGFloat.random(in: 0...256)/256,
                                            green: CGFloat.random(in: 0...256)/256,
                                            blue: CGFloat.random(in: 0...256)/256,
                                            alpha: CGFloat.random(in: 128...256)/256)
        return cell
    }
}

extension UserTextCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4.0, height: 150)
    }
}
