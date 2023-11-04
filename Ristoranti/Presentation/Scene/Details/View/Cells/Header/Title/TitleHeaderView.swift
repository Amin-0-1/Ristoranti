//
//  TitleHeaderView.swift
//  Ristoranti
//
//  Created by Amin on 04/11/2023.
//

import UIKit

class TitleHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var uiTitle: UILabel!

    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let size = contentView.systemLayoutSizeFitting(targetSize,withHorizontalFittingPriority: .required,verticalFittingPriority: .fittingSizeLevel)
        return size
    }
    
    func configure(title:String){
        uiTitle.text = title
    }

}
