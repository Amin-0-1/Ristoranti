//
//  OnboardingCell.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import UIKit

class OnboardingCell: UICollectionViewCell {

    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiStepImage: UIImageView!
    @IBOutlet private weak var uiTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(state:OnboardingViewDataModel){
        uiImage.transform = .init(scaleX: 0.3, y: 0.3)
        self.uiImage.image = UIImage(named: state.coverImage)
        UIView.animate(withDuration: 0.3) {
            self.uiImage.transform = .identity
        }
                
    }

}
