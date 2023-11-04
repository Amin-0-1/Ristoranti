//
//  MealCell.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit
import SDWebImage
class MealCell: UICollectionViewCell {

    @IBOutlet weak var uiTitle: UILabel!
    @IBOutlet weak var uiDescription: UILabel!
    @IBOutlet weak var uiFavouriteView: UIVisualEffectView!
    @IBOutlet weak var uiFavoriteImage: UIImageView!
    @IBOutlet weak var uiProductImage: UIImageView!
    @IBOutlet weak var uiRate: UILabel!
    @IBOutlet weak var uiRateCount: UILabel!
    @IBOutlet weak var uiPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(product:FoodItemProduct){
        
        uiDescription.text = product.description
        uiTitle.text = product.name
        let image = #imageLiteral(resourceName: "logo")
        let url = URL(string: product.image ?? "")
        uiProductImage.sd_setImage(with: url, placeholderImage: image)
        uiPrice.text = product.price?.rounded(toPlaces: 1).description
        uiRate.text = product.rating?.rate?.rounded(toPlaces: 1).description
        uiRateCount.text = "( \(product.rating?.count?.description ?? uiRateCount.text ?? "") )"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        uiFavouriteView.addGestureRecognizer(tap)
    }
    @objc private func favoriteTapped(){
        let xPosition = center.x - uiFavouriteView.frame.width * 0.5
        let yPosition = center.y + uiFavouriteView.frame.height * 0.5
        uiFavouriteView.transform = .init(translationX: xPosition, y: yPosition)
        uiFavouriteView.transform = .init(scaleX: 2, y: 2)
        let current = uiFavoriteImage.tintColor
        let desired:UIColor = current == .red ? .white : .red
        UIView.animate(withDuration: 0.5,delay: 0) {
            self.uiFavouriteView.transform = .identity
            self.uiFavoriteImage.tintColor = desired
        }
    }

}
