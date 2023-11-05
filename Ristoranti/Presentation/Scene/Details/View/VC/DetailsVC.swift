//
//  DetailsVC.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import UIKit
import Combine
class DetailsVC: UIViewController {

    @IBOutlet private weak var uiTableView: UITableView!
    @IBOutlet private weak var uiBackView: UIView!
    @IBOutlet private weak var uiButton: UIButton!
    
    private let headerTitle = "Choice of Add On"
    
    var viewModel:DetailsViewModelProtocol!
    private var cancellabels:Set<AnyCancellable> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure(){
        uiButton.imageView?.backgroundColor = .white
        configureBackButton()
        configureTableView()
        bind()
        viewModel.onScreenAppeared.send(false)
    }
    
    private func bind(){
        viewModel.showError.sink { [weak self] error in
            guard let self = self else {return}
            self.showError(message: error)
        }.store(in: &self.cancellabels)
        viewModel.showProgress.sink {[weak self] show in
            guard let self = self else {return}
            show ? showProgress() : hideProgress()
        }.store(in: &cancellabels)
        viewModel.dataModel.sink { [weak self] _ in
            guard let self = self else {return}
            uiTableView.reloadData()
        }.store(in: &cancellabels)
    }
    
    private func configureBackButton(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackPressed))
        uiBackView.addGestureRecognizer(tap)
    }
    
    private func configureTableView(){
        
        let cellNib = UINib(nibName: AddOnCell.nibName, bundle: nil)
        uiTableView.register(cellNib, forCellReuseIdentifier: AddOnCell.reuseIdentifier)
        
        let headerNib = UINib(nibName: DetailsHeaderView.nibName, bundle: nil)
        uiTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: DetailsHeaderView.reuseIdentifier)
        
        let titleHeaderNib = UINib(nibName: TitleHeaderView.nibName, bundle: nil)
        uiTableView.register(titleHeaderNib, forHeaderFooterViewReuseIdentifier: TitleHeaderView.reuseIdentifier)
    }
    
    @objc private func onBackPressed(){
        viewModel.onBackPressed.send()
    }

}

extension DetailsVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return viewModel.dataModel.value?.addons?.count ?? 0 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddOnCell.reuseIdentifier, for: indexPath) as? AddOnCell else {fatalError()}
        if let model = viewModel.dataModel.value?.addons?[indexPath.row]{
            cell.configure(addOne: model)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let header = tableView.headerView(forSection: 0) as? DetailsHeaderView else {return}
        
        if let value = viewModel.dataModel.value?.addons?[indexPath.row], let price = value.price{
            header.addPrice(value: price)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let header = tableView.headerView(forSection: 0) as? DetailsHeaderView else {return}
        
        if let value = viewModel.dataModel.value?.addons?[indexPath.row], let price = value.price{
            header.subtractPrice(value: price)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let _ = viewModel.dataModel.value else {return nil}
        // MARK: - Top Static Header
        if section == 0 {
            guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailsHeaderView.reuseIdentifier) as? DetailsHeaderView else {fatalError()}
            if let model = viewModel.dataModel.value{
                cell.configure(product: model)
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: TitleHeaderView.reuseIdentifier) as? TitleHeaderView else {fatalError()}
        cell.configure(title: headerTitle)
        if viewModel.dataModel.value?.addons?.count ?? 0 == 0{
            cell.isHidden = true
        }else{
            cell.isHidden = false
        }
        return cell

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if let header = tableView.headerView(forSection: 0) as? DetailsHeaderView{
                let targetSize = CGSize(width: tableView.frame.size.width, height: UIView.layoutFittingCompressedSize.height)
                return header.systemLayoutSizeFitting(targetSize).height
            }
        }
        if let header = tableView.headerView(forSection: section) as? TitleHeaderView{
            let targetSize = CGSize(width: tableView.frame.size.width, height: UIView.layoutFittingCompressedSize.height)
            return header.systemLayoutSizeFitting(targetSize).height
        }
        
        return UITableView.automaticDimension
    }
    
}


