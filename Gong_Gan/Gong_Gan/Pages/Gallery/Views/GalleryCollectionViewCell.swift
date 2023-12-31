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
    
    private let backGroundView = MainView()
    
     let cellImageView: UIImageView = {
       let imageView = UIImageView()
         
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
        // downsampled 이미지를 사용하십시오.
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


func downsampleImage(_ image: UIImage, to pointSize: CGSize, scale: CGFloat) -> UIImage {
    // 이미지 소스 생성
    guard let imageSource = CGImageSourceCreateWithData(image.pngData() as! CFData, nil) else {
        return image
    }
    
    // 다운샘플 옵션 설정
    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
    let downsampleOptions: [CFString: Any] = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
    ]
    
    // 다운샘플된 이미지 생성
    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions as CFDictionary) else {
        return image
    }
    
    // UIImage로 변환 후 반환
    return UIImage(cgImage: downsampledImage)
}
