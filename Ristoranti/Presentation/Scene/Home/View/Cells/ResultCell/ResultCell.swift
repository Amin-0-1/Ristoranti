//
//  ResultCell.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit

class ResultCell: UICollectionViewCell {

    @IBOutlet private weak var uiLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(text:String){
        uiLabel.text = text
    }

}
