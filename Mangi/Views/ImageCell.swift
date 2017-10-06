//
//  ImageCell.swift
//  Mangi
//
//  Created by Marco Mempin on 10/6/17.
//  Copyright © 2017 marcowesome. All rights reserved.
//

import UIKit
import IGListKit

func imageSectionController(with imageURL: String) -> ListSingleSectionController {
    
    let configureBlock = { (item: Any, cell: UICollectionViewCell) in
        guard let cell = cell as? ImageCell else { return }
        
        cell.imageView.imageFromServerURL(urlString: imageURL) {
            cell.activityLoader.stopAnimating()
        }
    }
    
    let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
        guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: context.containerSize.width / 2)
    }
    
    return ListSingleSectionController(cellClass: ImageCell.self,
                                       configureBlock: configureBlock,
                                       sizeBlock: sizeBlock)
}


class ImageCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    let activityLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader.startAnimating()
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(activityLoader)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        imageView.frame = bounds
        activityLoader.center = imageView.center
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        activityLoader.startAnimating()
    }
    
}