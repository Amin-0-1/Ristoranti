//
//  HomeVC.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit
import Combine
class HomeVC: UIViewController {
    @IBOutlet private weak var uiCollection: UICollectionView!
    @IBOutlet private weak var uiUserImage: UIImageView!
    @IBOutlet private weak var uiProfile: UIView!
    @IBOutlet private weak var uiTableView: UITableView!
    @IBOutlet private weak var uiLogoutButton:UIButton!
    @IBOutlet weak var uiContainerView: UIView!
    
    var homeState = CGAffineTransform()
    var isSideMenue = false
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
        configureSideMenue()
        configureCollection()
        bind()
    }
    private func configureCollection(){
        homeState = view.transform
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
    
    private func configureSideMenue(){
        let nib = UINib(nibName: SideMenuCell.nibName, bundle: nil)
        uiTableView.register(nib, forCellReuseIdentifier: SideMenuCell.reuseIdentifier)
        
        let header = UINib(nibName: SideMenuHeader.nibName, bundle: nil)
        uiTableView.register(header, forHeaderFooterViewReuseIdentifier: SideMenuHeader.reuseIdentifier)

        uiLogoutButton.layer.shadowColor = UIColor.accent.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(onProfileTapped))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        uiProfile.addGestureRecognizer(tap)
        uiContainerView.addGestureRecognizer(tap2)
    }
    @objc private func onProfileTapped(){
        isSideMenue ? hideMenu() : showMenu()
    }
    
    private func bind(){
        viewModel.showError.sink {[weak self] message in
            guard let self = self else {return}
            self.showError(message: message)
        }.store(in: &cancellabels)
        
        viewModel.showProgress.sink {[weak self] show in
            guard let self = self else {return}
            show ? showProgress() : hideProgress()
            show ? nil : self.refreshControl.endRefreshing()
        }.store(in: &cancellabels)
        
        viewModel.modelData.sink {[weak self] _ in
            guard let self = self else {return}
            uiCollection.reloadData()
        }.store(in: &cancellabels)
        
        viewModel.profileData.sink {[weak self] profile in
            guard let self = self else {return}
            if let url = profile?.image{
                let person = UIImage(systemName: "person.fill")
                person?.withTintColor(.accent)
                self.uiUserImage.sd_setImage(with: URL(string: url), placeholderImage: person)
            }
        }.store(in: &cancellabels)

    }
    @IBAction func uiLogoutPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.viewModel.onLogout.send()
        }
        alert.addAction(cancel)
        alert.addAction(yes)
        present(alert, animated: true)
    }
    
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modelData.value.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCell.reuseIdentifier, for: indexPath) as? ResultCell else {fatalError()}
            let val = viewModel.modelData.value.count
            cell.configure(value: val)
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
                header.frame = .init(x: 0, y: 0, width: uiCollection.frame.width, height: HeaderView.HeaderSize)
                header.configure()
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
        return HeaderView.HeaderSize
    }
}
