//
//  HeaderView.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit
import BetterSegmentedControl

@objc protocol HeaderViewDelegate:AnyObject{
    @objc func onChangedSegment()
}

class HeaderView: UICollectionReusableView {
    static let HeaderSize:CGFloat = 165
    private weak var delegate:HeaderViewDelegate!
    
    @IBOutlet weak var uiSegmented: BetterSegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(delegate:HeaderViewDelegate){
        self.delegate = delegate
        uiSegmented.segments = LabelSegment.segments(withTitles: ["Food Item","Resturant"],
                                                     normalTextColor: .accent,
                                                     selectedTextColor: .white)
        
        uiSegmented.addTarget(delegate, action: #selector(delegate.onChangedSegment), for: .valueChanged)
    }
    
}
