//
//  GalleryViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/28/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SnapKit
import RxSwift
import RxCocoa

class GalleryViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let viewModel = GalleryViewModel()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "내 일기"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private let galleryIsEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "작성된 일기가 없습니다."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .galleryLabelColor
        
        return label
    }()
    
    private let galleryCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cellSpacing: CGFloat = 3
        let numberOfItemsPerRow: CGFloat = 3
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - (cellSpacing * (numberOfItemsPerRow - 1) + cellSpacing * 2)) / numberOfItemsPerRow
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        //
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainBackGroundColor
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        //
        collectionView.isHidden = true
        // 이미 설정된 delegate와 dataSource를 제거
        
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchGalleryData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackGroundColor
        addSubViews()
        setNaviBar()
        setConstraints()
        setupControl()
        galleryCollectionView.delegate = nil
        galleryCollectionView.dataSource = nil
        setCollectionView()
    }
    
    private func addSubViews() {
        view.addSubview(galleryIsEmptyLabel)
        view.addSubview(galleryCollectionView)
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleLabel
    }
    
    private func setConstraints() {
        galleryIsEmptyLabel.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        })
        
        galleryCollectionView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        })
    }
    
    private func setupControl() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setCollectionView() {
        //        viewModel.fetchGalleryData()
        
        viewModel.galleryData
            .observe(on: MainScheduler.instance)
            .bind(to: galleryCollectionView.rx.items(cellIdentifier: GalleryCollectionViewCell.identifier, cellType: GalleryCollectionViewCell.self)) { [weak self] index, element, cell in
                guard let self else {
                    return
                }
                let cellSpacing: CGFloat = 3
                let numberOfItemsPerRow: CGFloat = 3
                let screenWidth = UIScreen.main.bounds.width
                let cellWidth = (screenWidth - (cellSpacing * (numberOfItemsPerRow - 1) + cellSpacing * 2)) / numberOfItemsPerRow
                self.galleryCollectionView.isHidden = false
                
//                if let galleryCell = cell as? GalleryCollectionViewCell {
//                    let imageName = UIImage(named: "지하철")?.preparingThumbnail(of: CGSize(width: cellWidth, height: cellWidth))?.jpegData(compressionQuality: 1)
//                    
//                    galleryCell.cellImageView.image = UIImage(data: imageName!)
//                }
                
                cell.cellImageView.image = UIImage(systemName: "pencil")
//
//                cell.cellImageView.image = downsampleImage(UIImage(named: "지하철")!, to: CGSize(width: cellWidth, height: cellWidth), scale: UIScreen.main.scale)
//                
            }
            .disposed(by: disposeBag)
        
        galleryCollectionView.rx.modelSelected(GalleryDataModel.self)
            .subscribe(onNext: { [weak self] selectedGalleryData in
                guard let self else {
                    return
                }
                let readViewController = ReadViewController()
                readViewController.selectedGalleryData = selectedGalleryData
                
                self.navigationController?.pushViewController(readViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
