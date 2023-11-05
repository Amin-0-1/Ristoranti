//
//  HeaderView.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit
import BetterSegmentedControl

@objc protocol HeaderViewDelegate:AnyObject,UITextFieldDelegate{
    @objc func onChangedSegment(_ sender: BetterSegmentedControl)
//    @objc func onSearchValueChanged(_ sender:UITextField)
}

class HeaderView: UICollectionReusableView {
    
    @IBOutlet private weak var uiTexField: UITextField!
    @IBOutlet private weak var uiSegmented: BetterSegmentedControl!
    
    
    static let HeaderSize:CGFloat = 165
    private weak var delegate:HeaderViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(delegate:HeaderViewDelegate,selectedIndex:Int, searchText:String){
        self.delegate = delegate
        uiSegmented.segments = LabelSegment.segments(withTitles: ["Food Item","Resturant"],
                                                     normalTextColor: .accent,
                                                     selectedTextColor: .white)
        
        self.setSelected(index: selectedIndex)
        self.setSearch(text:searchText)
        
        uiTexField.delegate = delegate
        uiSegmented.addTarget(delegate, action: #selector(delegate.onChangedSegment(_:)), for: .valueChanged)
        
    }
    func setSelected(index:Int){
        self.uiSegmented.setIndex(index)
    }
    private func setSearch(text:String){
        self.uiTexField.text = text
        _ = !text.isEmpty ? uiTexField.becomeFirstResponder() : uiTexField.resignFirstResponder()
    }
    
}
