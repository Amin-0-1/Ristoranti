//
//  AddOnCell.swift
//  Ristoranti
//
//  Created by Amin on 04/11/2023.
//

import UIKit
import SDWebImage
class AddOnCell: UITableViewCell {

    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiTitle: UILabel!
    @IBOutlet private weak var uiPrice: UILabel!
    @IBOutlet private weak var uiSelectionOut: UIView!
    @IBOutlet private weak var uiSelectionIn: UIView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if isSelected {
            UIView.animate(withDuration: 0.5) {
                self.uiSelectionIn.backgroundColor = .accent
                self.uiSelectionOut.UIBorderColor = .accent
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.uiSelectionIn.backgroundColor = .white
                self.uiSelectionOut.UIBorderColor = .systemGray4
            }
        }
    }
    func configure(addOne: DrinkDataModel) {
        
        DispatchQueue.main.async {[unowned self] in
            self.uiTitle.isHidden = true
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 10,
                options: .transitionCrossDissolve
            ) {
                self.uiTitle.text = addOne.name
                self.uiTitle.isHidden = false
            }
        }
        uiPrice.text = addOne.price?.description
        
        let image = #imageLiteral(resourceName: "logo")
        if let url = addOne.image {
            uiImage.sd_setImage(with: URL(string: url), placeholderImage: image)
        }
    }
    
}
