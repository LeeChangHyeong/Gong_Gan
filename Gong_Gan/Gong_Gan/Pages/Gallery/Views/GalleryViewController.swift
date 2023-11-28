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
    private let disposeBag = DisposeBag()
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
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .galleryColor
        addSubViews()
        setNaviBar()
        setConstraints()
        setupControl()
        setCollectionView()
        
        // Do any additional setup after loading the view.
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
//        let uid = UserData.shared.getUserUid()
//        
//        let userDocumentRef = Firestore.firestore().collection("users").document(uid)
//        
//        userDocumentRef.getDocument { document, error in
//            if let error = error {
//                print("갤러리 서버 통신 에러: \(error.localizedDescription)")
//            } else if let document = document, document.exists {
//                // 데이터가 있을때
//                self.galleryCollectionView.isHidden = false
//                let data = document.data()
//                print(data)
//            } else {
//                // 데이터가 없을때
//                self.galleryCollectionView.isHidden = true
//            }
//        }
        
        viewModel.fetchData()
        viewModel.galleryImageNames
            .bind(to: galleryCollectionView.rx.items(cellIdentifier: GalleryCollectionViewCell.identifier, cellType: GalleryCollectionViewCell.self)) { index, element, cell in
                cell.cellImageView.image = UIImage(named: "\(element)")
                print(element)
            }
            .disposed(by: disposeBag)
        
        // UICollectionViewFlowLayout을 사용하여 셀을 가로 3칸씩 표시
              if let layout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                  let cellSpacing: CGFloat = 8
                  let numberOfItemsPerRow: CGFloat = 3

                  let width = (galleryCollectionView.frame.width - (cellSpacing * (numberOfItemsPerRow - 1))) / numberOfItemsPerRow
                  layout.itemSize = CGSize(width: width, height: width)
                  layout.minimumInteritemSpacing = cellSpacing
                  layout.minimumLineSpacing = cellSpacing
              }
        
    }
    
}
