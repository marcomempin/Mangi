//
//  ButtonCell.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import UIKit
import IGListKit
import SafariServices

func buttonSectionController() -> ListSingleSectionController {
    let configureBlock = { (item: Any, cell: UICollectionViewCell) in
        guard let cell = cell as? ButtonCell else { return }
        
        cell.actionButton.addTarget(cell, action: #selector(ButtonCell.openWebView), for: .touchUpInside)
    }
    
    let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
        guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: 50)
    }
    
    return ListSingleSectionController(nibName: "ButtonCell",
                                       bundle: nil,
                                       configureBlock: configureBlock,
                                       sizeBlock: sizeBlock)

}

class ButtonCell: UICollectionViewCell {
    @IBOutlet weak var actionButton: UIButton!
    
    public func openWebView() {
        let safariViewController = SFSafariViewController(url: URL(string: "http://www.cathaycineplexes.com.sg/")!)
        UIApplication.shared.keyWindow?.rootViewController?.present(safariViewController, animated: true)
    }
}
