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

//class GalleryViewController: UIViewController {
//    private var disposeBag = DisposeBag()
//    private let viewModel = GalleryViewModel()
//
//    private let backButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
//        button.setImage(image, for: .normal)
//        button.tintColor = .white
//
//        return button
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.text = "내 일기"
//        label.font = .systemFont(ofSize: 17, weight: .bold)
//
//        return label
//    }()
//
//    private let galleryIsEmptyLabel: UILabel = {
//        let label = UILabel()
//        label.text = "작성된 일기가 없습니다."
//        label.font = .systemFont(ofSize: 16, weight: .regular)
//        label.textColor = .galleryLabelColor
//
//        return label
//    }()
//
//    private let galleryCollectionView: UICollectionView = {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let cellSpacing: CGFloat = 3
//        let numberOfItemsPerRow: CGFloat = 3
//        let screenWidth = UIScreen.main.bounds.width
//        let cellWidth = (screenWidth - (cellSpacing * (numberOfItemsPerRow - 1) + cellSpacing * 2)) / numberOfItemsPerRow
//
//        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
//        layout.minimumLineSpacing = cellSpacing
//        layout.minimumInteritemSpacing = cellSpacing
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .mainBackGroundColor
//        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
//
//        collectionView.isHidden = true
//
//        return collectionView
//    }()
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        viewModel.fetchGalleryData()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .mainBackGroundColor
//        addSubViews()
//        setNaviBar()
//        setConstraints()
//        setupControl()
//        galleryCollectionView.delegate = nil
//        galleryCollectionView.dataSource = nil
//        setCollectionView()
//    }
//
//    private func addSubViews() {
//        view.addSubview(galleryIsEmptyLabel)
//        view.addSubview(galleryCollectionView)
//    }
//
//    private func setNaviBar() {
//        navigationController?.isNavigationBarHidden = false
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//        navigationItem.titleView = titleLabel
//    }
//
//    private func setConstraints() {
//        galleryIsEmptyLabel.snp.makeConstraints({
//            $0.centerY.equalToSuperview()
//            $0.centerX.equalToSuperview()
//        })
//
//        galleryCollectionView.snp.makeConstraints({
//            $0.leading.trailing.bottom.equalToSuperview()
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//        })
//    }
//
//    private func setupControl() {
//        backButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: disposeBag)
//
//    }
//
//    private func setCollectionView() {
//        viewModel.galleryData
//            .observe(on: MainScheduler.instance)
//            .bind(to: galleryCollectionView.rx.items(cellIdentifier: GalleryCollectionViewCell.identifier, cellType: GalleryCollectionViewCell.self)) { [weak self] index, element, cell in
//                guard let self else {
//                    return
//                }
//                let cellSpacing: CGFloat = 3
//                let numberOfItemsPerRow: CGFloat = 3
//                let screenWidth = UIScreen.main.bounds.width
//                let cellWidth = (screenWidth - (cellSpacing * (numberOfItemsPerRow - 1) + cellSpacing * 2)) / numberOfItemsPerRow
//                self.galleryCollectionView.isHidden = false
//
////                if let galleryCell = cell as? GalleryCollectionViewCell {
////                    let imageName = UIImage(named: "지하철")?.preparingThumbnail(of: CGSize(width: cellWidth, height: cellWidth))?.jpegData(compressionQuality: 1)
////
////                    galleryCell.cellImageView.image = UIImage(data: imageName!)
////                }
//
//                cell.cellImageView.image = UIImage(systemName: "pencil")
////
////                cell.cellImageView.image = downsampleImage(UIImage(named: "지하철")!, to: CGSize(width: cellWidth, height: cellWidth), scale: UIScreen.main.scale)
////
//            }
//            .disposed(by: disposeBag)
//
//        galleryCollectionView.rx.modelSelected(GalleryDataModel.self)
//            .subscribe(onNext: { [weak self] selectedGalleryData in
//                guard let self else {
//                    return
//                }
//                let readViewController = ReadViewController()
//                readViewController.selectedGalleryData = selectedGalleryData
//
//                self.navigationController?.pushViewController(readViewController, animated: true)
//            })
//            .disposed(by: disposeBag)
//    }
//}


class GalleryViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        
        return button
    }()
    private var galleryData: [GalleryDataModel] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "내 일기"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        return collectionView
    }()
    
    
    private let galleryIsEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "작성된 일기가 없습니다."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGalleryData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .black
        addSubViews()
        setNaviBar()
        setConstraints()
        setupControl()
        updateCollectionView()
    }
    
    private func addSubViews() {
        view.addSubview(galleryIsEmptyLabel)
        view.addSubview(collectionView)
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
        
        collectionView.snp.makeConstraints({
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
    
    
    private func fetchGalleryData() {
            // 여기에 Firestore 등을 이용하여 데이터를 가져오는 로직을 구현
            // 패치데이터로 받은 정보를 galleryData에 저장
            let uid = UserData.shared.getUserUid()
            let userDocumentRef = Firestore.firestore().collection("users").document(uid)
            
            userDocumentRef.getDocument { [weak self] document, error in
                guard let self else {return}
                if let document = document, document.exists {
                    if let memosArray = document["memos"] as? [[String: Any]] {
                        
                        let reversedMemosArray = memosArray.reversed()
                        // 모든 데이터를 저장할 배열 초기화
                        var galleryDataArray: [GalleryDataModel] = []
                        
                        for memoDict in reversedMemosArray {
                            guard
                                let memoID = memoDict["memoID"] as?
                                    String,
                                let date = memoDict["date"] as? String,
                                let imageName = memoDict["imageName"] as? String,
                                let location = memoDict["location"] as? String,
                                let memo = memoDict["memo"] as? String,
                                let time = memoDict["time"] as? String,
                                let weather = memoDict["weather"] as? String,
                                let thumnailImage = memoDict["thumnailImage"] as? String
                            else {
                                continue
                            }
                            
                            // 모든 데이터를 GalleryDataModel로 만들어 배열에 저장
                            let galleryData = GalleryDataModel(memoID: memoID, date: date, imageName: imageName, location: location, memo: memo, time: time, weather: weather, thumnailImage: thumnailImage)
                            
                            galleryDataArray.append(galleryData)
                        }
                        self.galleryData = galleryDataArray
                        
                        print("Gallery data array: \(galleryData)")
                        
                        self.updateCollectionView()
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
    
    private func updateCollectionView() {
        collectionView.reloadData()
    }
    
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as! GalleryCollectionViewCell

        
        cell.cellImageView.image = UIImage(systemName: "pencil")
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpacing: CGFloat = 3
        let numberOfItemsPerRow: CGFloat = 3
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - (cellSpacing * (numberOfItemsPerRow - 1) + cellSpacing * 2)) / numberOfItemsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = galleryData[indexPath.item]
        let readViewController = ReadViewController()
        readViewController.selectedGalleryData = selectedData
        navigationController?.pushViewController(readViewController, animated: true)
    }

    
}
