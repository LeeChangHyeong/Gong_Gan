//
//  GalleryCollectionViewCell.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/28/23.
//

import UIKit
import SnapKit

class GalleryCollectionViewCell: UICollectionViewCell {
    static let identifier = "GalleryCollectionViewCell"
    
     let cellImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "일본")
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func addSubViews() {
        contentView.addSubview(cellImageView)
    }
    
    private func setConstraints() {
        cellImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
}
