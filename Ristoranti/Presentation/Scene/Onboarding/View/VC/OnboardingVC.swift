//
//  OnboardingVC.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBOutlet private weak var uiCollection: UICollectionView!
    @IBOutlet private weak var uiStatusImage: UIImageView!
    @IBOutlet private weak var uiCaption: UILabel!
    @IBOutlet private weak var uiButton: LoaderButton!
    private  var currentVisibleIndex = 0
    var coordinator: OnboardingCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
    }
    
    private func configureCollection() {
        let nib = UINib(nibName: OnboardingCell.nibName, bundle: nil)
        uiCollection.register(nib, forCellWithReuseIdentifier: OnboardingCell.reuseIdentifier)
        uiCollection.isUserInteractionEnabled = false

        let layout = UICollectionViewCompositionalLayout { section, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
            group.interItemSpacing = .fixed(0)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
        
        uiCollection.collectionViewLayout = layout
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        navigate(next: true)
    }
    private func navigate(next: Bool) {
        
        let newValue = next ? currentVisibleIndex + 1 : currentVisibleIndex - 1
        guard OnboardingViewDataModel(rawValue: newValue) != nil else {
            if next {
                uiButton.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.uiButton.isLoading = false
                    self.coordinator?.onFinishedOnboarding()
                    
                }
            }
            return
        }
        uiCollection.scrollToItem(at: .init(item: newValue, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCell.reuseIdentifier,
            for: indexPath
        ) as? OnboardingCell else {
            print("unable to dequeue cell for identifier \(OnboardingCell.reuseIdentifier)")
            return .init()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.currentVisibleIndex = indexPath.item
        if let cell = cell as? OnboardingCell {
            guard let state = OnboardingViewDataModel(rawValue: currentVisibleIndex) else {
                if indexPath.item > 0 {
                    coordinator?.onFinishedOnboarding()
                }
                return
            }
            
            UIView.transition(with: uiStatusImage, duration: 0.5, options: .transitionCrossDissolve) {
                self.uiStatusImage.image = UIImage(named: state.stepImgage)
            }
            
            UIView.transition(with: uiCaption, duration: 0.5, options: .transitionCrossDissolve) {
                self.uiCaption.text = state.description
            }
            
            cell.configure(state: state)
        }
    }
    
}
