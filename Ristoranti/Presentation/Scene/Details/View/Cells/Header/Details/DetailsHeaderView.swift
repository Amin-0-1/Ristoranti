//
//  DetailsHeaderView.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import UIKit

protocol DetailsHeaderViewDelegate:AnyObject{
    func changeOrder(count:Int)
}
class DetailsHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var uiTitle: UILabel!
    @IBOutlet private weak var uiImage: UIImageView!
    @IBOutlet private weak var uiSeeReview: UIButton!
    @IBOutlet private weak var uiRate: UILabel!
    @IBOutlet private weak var uiRateCount: UILabel!
    @IBOutlet private weak var uiPrice: UILabel!
    @IBOutlet private weak var uiOrderCount: UILabel!
    @IBOutlet private weak var uiDescription: UILabel!
    @IBOutlet private weak var uiFavouriteView: UIVisualEffectView!
    @IBOutlet weak var uiFavoriteImage: UIImageView!
    
    private var product:ProductDataModel!
    private weak var delegate: DetailsHeaderViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return size
    }
    
    func configure(product:ProductDataModel){
        self.product = product
        self.uiTitle.text = product.name
        let attributedText = NSAttributedString(string: "See Review", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        uiSeeReview.setAttributedTitle(attributedText, for: .normal)
        uiRate.text = product.rating?.rate?.rounded(toPlaces: 1).description ?? 0.description
        uiRateCount.text = "( \(product.rating?.count ?? 0) )"
        uiPrice.text = product.price?.description
        uiDescription.text = product.description
        let image = #imageLiteral(resourceName: "logo")
        if let url = product.image{
            uiImage.sd_setImage(with: URL(string: url), placeholderImage: image)
        }
        DispatchQueue.main.async {
            self.uiImage.transform = .init(scaleX: 0.4, y: 0.4).translatedBy(x: 0, y: -200)
            self.uiImage.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseOut) {
                self.uiImage.transform = .identity
                self.uiImage.alpha = 1
            }
        }
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
    @IBAction func uiSeeReviewPressed(_ sender: UIButton) {
        
    }
    @IBAction func orderRequest(_ sender: UIButton) {
        guard let count = Int(uiOrderCount.text ?? "") else {return}
        var orderCount = 0
        switch sender.tag{
            case 1: // decrese
                guard count > 1 else {return}
                orderCount = count - 1
                uiOrderCount.text = orderCount.description
                updatePrice(orderCount: orderCount,option: .transitionFlipFromBottom)
            case 2: // increase
                orderCount = count + 1
                uiOrderCount.text = orderCount.description
                updatePrice(orderCount: orderCount,option: .transitionFlipFromTop)
            default:
                break
        }
    }
    
    private func updatePrice(orderCount:Int,option:UIView.AnimationOptions){
        guard let price = product.price else {return}
        let newPrice = price * Double(orderCount)
        update(price: newPrice)
    }
    
    private func update(price:Double,option:UIView.AnimationOptions = .transitionFlipFromTop){
        DispatchQueue.main.async {
            UIView.transition(with: self.uiPrice, duration: 0.5,options: option) {
                self.uiPrice.text = price.description
            }
        }
    }
    func addPrice(value:Double){
        guard let currentPrice = Double(uiPrice.text ?? "") else {return}
        let newPrice = currentPrice + value
        self.update(price: newPrice)
    }
    func subtractPrice(value:Double){
        guard let currentPrice = Double(uiPrice.text ?? "") else {return}
        let newPrice = currentPrice - value
        self.update(price: newPrice,option:.transitionFlipFromBottom)
    }
}
