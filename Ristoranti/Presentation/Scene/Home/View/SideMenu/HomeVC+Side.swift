//
//  HomeVC+Side.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import UIKit
extension HomeVC {
    
    var options:[HomeSideMenueOption]{
        [
            .init(title: "My Orders", image: "Document"),
            .init(title: "My Profile", image: "Profile"),
            .init(title: "Delivery Address", image: "Location"),
            .init(title: "Payment Methods", image: "Wallet"),
            .init(title: "Contact Us", image: "Message"),
            .init(title: "Settings", image: "Settings"),
            .init(title: "Helps & FAQs", image: "Help"),
        ]
    }
    
    struct HomeSideMenueOption{
        var title:String
        var image:String
    }
    
    
    @objc func hideMenu() {
        isSideMenue = false
        UIView.animate(withDuration: 0.7) {
            self.uiContainerView.transform = self.homeState
            self.uiContainerView.layer.cornerRadius = 0
        }
    }
    
    @objc func showMenu() {
        isSideMenue = true
        self.uiContainerView.layer.cornerRadius = 40
        let x = uiContainerView.frame.width * 0.8
        let originalTransform = self.uiContainerView.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.8, y: 0.8)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x, y: 0)
        UIView.animate(withDuration: 0.7) {
            self.uiContainerView.transform = scaledAndTranslatedTransform
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.reuseIdentifier, for: indexPath) as! SideMenuCell
        cell.configure(option: options[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            let currentCell = (tableView.cellForRow(at: indexPath) ?? UITableViewCell()) as UITableViewCell
            currentCell.alpha = 0.5
            UIView.animate(withDuration: 1) {
                currentCell.alpha = 1
            }
            hideMenu()
            isSideMenue = false
            // navigation
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SideMenuHeader.reuseIdentifier) as? SideMenuHeader else {fatalError()}
        guard let profile = viewModel.profileData.value else {fatalError()}
        header.configure(profile:profile)
        let view:UIView = .init(frame: header.bounds)
        view.backgroundColor = .secondarySystemBackground
        header.backgroundView = view
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SideMenuHeader.contentHeight
    }
}
