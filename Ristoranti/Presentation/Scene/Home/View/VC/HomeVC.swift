//
//  HomeVC.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit
import Combine
class HomeVC: UIViewController {
    @IBOutlet weak var uiSearchField: UIView!
    @IBOutlet weak var uiCollection: UICollectionView!
    
    
    private lazy var refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemGreen
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        return refreshControl
    }()
    
    
    @objc func refreshControlValueChanged(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){[weak self] in
            guard let self = self else {return}
            self.viewModel.onScreenAppeared.send(true)
            self.refreshControl.endRefreshing()
        }
    }
    
    var viewModel:HomeViewModelProtocol!
    private var cancellabels:Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.onScreenAppeared.send(false)
    }
    private func configure(){
        navigationController?.navigationBar.isHidden = true
        uiSearchField.layer.borderColor = UIColor.lightGray.cgColor
        configureCollection()
        bind()
    }
    private func configureCollection(){
        let header = UINib(nibName: HeaderView.nibName, bundle: nil)
        uiCollection.register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        uiCollection.register(UINib(nibName: MealCell.nibName, bundle: nil), forCellWithReuseIdentifier: MealCell.reuseIdentifier)
        uiCollection.register(UINib(nibName: ResultCell.nibName, bundle: nil), forCellWithReuseIdentifier: ResultCell.reuseIdentifier)
        
        
        
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        pinterestLayout.numberOfColumns = 2
        pinterestLayout.cellPadding = 6
        uiCollection.collectionViewLayout = pinterestLayout
        
        uiCollection.refreshControl = refreshControl
    }
    
//    private func generateLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(300))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(16)
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
//        section.interGroupSpacing = 16
//        
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        
//        section.boundarySupplementaryItems = [header]
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
    
    private func bind(){
        viewModel.showError.sink {[weak self] message in
            guard let self = self else {return}
            self.showError(message: message)
        }.store(in: &cancellabels)
        
        viewModel.showProgress.sink {[weak self] show in
            guard let self = self else {return}
            show ? showProgress() : hideProgress()
        }.store(in: &cancellabels)
        
        viewModel.modelData.sink {[weak self] _ in
            guard let self = self else {return}
            uiCollection.reloadData()
        }.store(in: &cancellabels)

    }
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modelData.value.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.reuseIdentifier, for: indexPath) as? ResultCell else {fatalError()}
            cell.configure(text: "30")
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCell.reuseIdentifier, for: indexPath) as? MealCell else {fatalError()}
            let product = viewModel.modelData.value[indexPath.item]
            cell.configure(product: product)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
            case PinterestLayout.PinterestElementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {fatalError()}
                header.frame = .init(x: 0, y: 0, width: uiCollection.frame.width, height: 100)
                return header
            default: return .init()
        }
    }
}
extension HomeVC:PinterestLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: PinterestLayout,heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat{
        
        guard indexPath.item != 0 else {
            return 100
        }
        let item = viewModel.modelData.value[indexPath.item]
        let title = item.name
        let desc = item.description
        
        let image = (180 * layout.cellWidth) / 180
        
        let padding = 32
        let font = UIFont(name: "SofiaProRegular", size: 15)!
        let labelHeight = desc?.heightFitting(width: layout.cellWidth, font: font) ?? 0
        let descHeight = title?.heightFitting(width: layout.cellWidth, font: font.withSize(18)) ?? 0
        
        return image + CGFloat(padding) + labelHeight + descHeight
    }
    func collectionViewHeaderSize(_ collectionView: UICollectionView) -> CGFloat {
        return 100
    }
}
