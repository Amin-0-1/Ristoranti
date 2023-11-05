//
//  HomeVC.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit
import Combine
import BetterSegmentedControl
class HomeVC: UIViewController {
    @IBOutlet private weak var uiCollection: UICollectionView!
    @IBOutlet private weak var uiUserImage: UIImageView!
    @IBOutlet private weak var uiProfile: UIView!
    @IBOutlet private weak var uiTableView: UITableView!
    @IBOutlet private weak var uiLogoutButton:UIButton!
    @IBOutlet weak var uiContainerView: UIView!
    
    enum SectionIdentifier:Hashable{
        case main
    }
    private var datasource:UICollectionViewDiffableDataSource<SectionIdentifier,FoodItemProduct>!
    private var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, FoodItemProduct>()
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
        homeState = view.transform
        registerKeyboardDismissel()
        navigationController?.navigationBar.isHidden = true
        configureSideMenue()
        configureCollection()
        bind()
    }
    // MARK: - Collection
    private func configureCollection(){
        uiCollection.allowsSelection = true
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
        configureCellForRow()
        configureSupplementaryViewProvider()
        self.snapshot = datasource.snapshot()
        self.snapshot.appendSections([.main])
        self.datasource.apply(snapshot, animatingDifferences: false)
    }
    private func configureCellForRow(){
        datasource = UICollectionViewDiffableDataSource<SectionIdentifier, FoodItemProduct>(collectionView: uiCollection) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else {fatalError()}
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
    }
    
    private func configureSupplementaryViewProvider(){
        datasource.supplementaryViewProvider = { [weak self] collection, kind, indexPath in
            guard let self = self else {fatalError()}
            switch kind{
                case PinterestLayout.PinterestElementKindSectionHeader:
                    guard let header = collection.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {fatalError()}
                    header.frame = .init(x: 0, y: 0, width: uiCollection.frame.size.width, height: HeaderView.HeaderSize)
                    header.configure(delegate: self,selectedIndex: viewModel.selectSegment,searchText: viewModel.searchText)
                    return header
                default: return .init()
            }
        }
    }
    private func configureSideMenue(){
        let nib = UINib(nibName: SideMenuCell.nibName, bundle: nil)
        uiTableView.register(nib, forCellReuseIdentifier: SideMenuCell.reuseIdentifier)
        
        let header = UINib(nibName: SideMenuHeader.nibName, bundle: nil)
        uiTableView.register(header, forHeaderFooterViewReuseIdentifier: SideMenuHeader.reuseIdentifier)

        uiLogoutButton.layer.shadowColor = UIColor.accent.cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(onProfileTapped))
        tap.cancelsTouchesInView = false
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(hideMenu))
        tap2.cancelsTouchesInView = false
        uiProfile.addGestureRecognizer(tap)
        uiContainerView.addGestureRecognizer(tap2)
    }
    @objc private func onProfileTapped(){
        isSideMenue ? hideMenu() : showMenu()
        isSideMenue ?  uiTableView.reloadData() :nil  
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
        
        viewModel.modelData.sink {[weak self] model in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.snapshot.deleteAllItems()
                self.snapshot.appendSections([.main])
                self.snapshot.appendItems(model)
                self.datasource.apply(self.snapshot, animatingDifferences: true) {
                    guard let cell = self.uiCollection.visibleCells.first as? ResultCell else {return}
                    self.uiCollection.layoutIfNeeded()
                    cell.configure(value: model.count)
                    cell.layoutIfNeeded()
                }
            }
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
        let alert = UIAlertController(title: "Logout", message: "Are you sure ?\n all your saved data will be deleted forever.", preferredStyle: .alert)
        alert.view.tintColor = .systemBlue
        alert.addAction(.init(title: "Yes", style: .destructive, handler: {[weak self] _ in
            guard let self = self else {return}
            self.viewModel.onLogout.send()
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}

// MARK: - Collection view layout delegate
extension HomeVC:UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            dismissKeyboard()
            return
        }
        viewModel.onTapCell.send(indexPath.row)
    }
}

// MARK: - Pinterest layout delegate
extension HomeVC:PinterestLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, layout: PinterestLayout,heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat{
        
        guard indexPath.item != 0 else {
            return 100
        }
        let item = viewModel.modelData.value[indexPath.item]
        let title = item.name
        let desc = item.description
        
        let image = (180 * layout.contentWidth) / 180
        
        let padding = 32
        let font = UIFont(name: "SofiaProRegular", size: 15)!
        let descHeight = desc?.pinterestHeightFitting(width: layout.contentWidth - 32, font: font) ?? 0
        let titleHeigh = title?.pinterestHeightFitting(width: layout.contentWidth - 32, font: font.withSize(18)) ?? 0
        
        return image + CGFloat(padding) + titleHeigh + descHeight
    }
    func collectionViewHeaderSize(_ collectionView: UICollectionView) -> CGFloat {
        return HeaderView.HeaderSize
    }
}

// MARK: - Header view delegate
extension HomeVC:HeaderViewDelegate{
    @objc func onChangedSegment(_ sender: BetterSegmentedControl) {
        dismissKeyboard()
        viewModel.onChangedSegment.send(sender.index)
    }
    func onSearchValueChanged(_ sender: UITextField) {
        viewModel.onSearching.send(sender.text)
    }
}

extension HomeVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        viewModel.onSearching.send(updatedText)
        return true
    }
}
