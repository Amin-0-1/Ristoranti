//
//  HeaderView.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit
import BetterSegmentedControl
class HeaderView: UICollectionReusableView {
    static let HeaderSize:CGFloat = 165
    @IBOutlet weak var uiSegmented: BetterSegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(){
        uiSegmented.segments = LabelSegment.segments(withTitles: ["Food Item","Resturant"],
                                                     normalTextColor: .accent,
                                                     selectedTextColor: .white)
    }
    
}
