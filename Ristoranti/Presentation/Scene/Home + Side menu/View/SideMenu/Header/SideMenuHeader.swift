//
//  SideMenuHeader.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import UIKit
import SDWebImage
class SideMenuHeader: UITableViewHeaderFooterView {
    static let contentHeight: CGFloat = 185
    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiName: UILabel!
    @IBOutlet private weak var uiContact: UILabel!
    func configure(profile: UserResponseModel) {
        if let url = profile.image {
            let image = #imageLiteral(resourceName: "logo")
            uiImage.sd_setImage(with: URL(string: url), placeholderImage: image)
        }
        uiName.text = profile.name
        uiContact.text = profile.phone
    }
}
