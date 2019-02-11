//
//  QuestionsCollectionViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
//https://www.youtube.com/watch?v=Ko9oNhlTwH0
class QuestionsCollectionViewController: CoordinatedViewController {

    weak var coordinator: QuestionsCollectionViewControllerDelegate?
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.title = "Collection Sample"
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }
}

extension QuestionsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: UserTextCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath)  as! UserTextCollectionViewCell
        cell.backgroundColor = UIColor.init(displayP3Red: CGFloat.random(in: 0...256)/256,
                                            green: CGFloat.random(in: 0...256)/256,
                                            blue: CGFloat.random(in: 0...256)/256,
                                            alpha: CGFloat.random(in: 128...256)/256)
        return cell
    }
}

extension QuestionsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
}
