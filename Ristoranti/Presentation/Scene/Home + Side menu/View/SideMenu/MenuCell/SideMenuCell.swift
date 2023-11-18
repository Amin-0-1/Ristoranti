//
//  TableViewCell.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiLable: UILabel!
    func configure(option: HomeVC.HomeSideMenueOption) {
        uiLable.text = option.title
        uiImage.image = UIImage(named: option.image)
    }
    
}
