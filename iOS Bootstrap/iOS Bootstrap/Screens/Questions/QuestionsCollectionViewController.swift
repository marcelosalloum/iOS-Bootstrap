//
//  QuestionsCollectionViewController.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 05/02/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import PKHUD
//https://www.youtube.com/watch?v=Ko9oNhlTwH0
class QuestionsCollectionViewController: CoordinatedViewController {

    var viewModel: QuestionCollectionViewModel!
    weak var coordinator: QuestionsCollectionViewControllerDelegate?
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Collection View
        collectionView.dataSource = self
        collectionView.delegate = self

        // View Model
        viewModel.updateDataSource()

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
        return viewModel.tags.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = String(describing: UserTextCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath)  as! UserTextCollectionViewCell
        cell.articlesTag = QuestionCollectionViewModel.getObject(from: viewModel.tags, with: indexPath)
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

extension QuestionsCollectionViewController: QuestionCollectionProtocol {
    func updateData(tags: [Tag], endRefreshing: Bool) {
        self.collectionView.reloadData()
    }

    func displayError(error: Error, endRefreshing: Bool) {
        HUD.flash(.labeledError(title: "Error", subtitle: error.localizedDescription), delay: 2.0)
    }

    func displayMessage(_ message: String) {
        self.toastr(message)
    }
}
