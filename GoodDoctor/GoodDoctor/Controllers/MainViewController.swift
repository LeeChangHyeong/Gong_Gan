//
//  MainViewController.swift
//  GoodDoctor
//
//  Created by 이창형 on 2023/08/25.
//

import UIKit

class MainViewController: UIViewController {
    
    var textArray: [String] = ["서울・강남구","영업중", "야간약국", "토요약국", "휴일약국"]
    var pharmacyNameArray: [String] = ["착한약국", "희망약국", "보람약국", "건강약국", "힘내약국", "탈출약국", "진짜약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국", "희망약국"]
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonTapped))
        button.tintColor = .black
        
        return button
    }()
        
    lazy var pharmacyCountLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 \(pharmacyNameArray.count)개"
        label.font = UIFont(name: "NanumSquareEB", size: 15)
        label.textColor = .gray
        
        return label
    }()
    
    lazy var settingCollectionView: UICollectionView = {
        // 컬렉션뷰의 레이아웃을 담당하는 객체
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
        // 옆에 스크롤 선 false하면 꺼짐
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        
        return collectionView
    }()
    
    lazy var locationCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = CVCell.spacingHeight
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    let noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nodata")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        locationCollectionView.delegate = self
        locationCollectionView.dataSource = self
        settingCollectionView.delegate = self
        settingCollectionView.dataSource = self
        
        setupNaviBar()
        addViews()
        setConstraints()
    }
    
    func setupNaviBar() {
        navigationItem.title = "약국"
        
        // 네비게이션바 설정관련
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NanumSquareR", size: 15) as Any]
        
        
        // 네비게이션바 왼쪽 상단 버튼 설정
        self.navigationItem.leftBarButtonItem = self.backButton
    }
    
    func addViews() {
        settingCollectionView.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: Idf.settingCollectionViewCellIdentifier)
        locationCollectionView.register(LocationCollectionViewCell.self, forCellWithReuseIdentifier: Idf.locationCollectionViewCellIdentifier)
        
        view.addSubview(settingCollectionView)
        if pharmacyNameArray.count == 0 {
            view.addSubview(noDataImageView)
        } else {
            view.addSubview(pharmacyCountLabel)
            view.addSubview(locationCollectionView)
        }
    }
    
    func setConstraints() {
        settingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pharmacyCountLabel.translatesAutoresizingMaskIntoConstraints = false
        locationCollectionView.translatesAutoresizingMaskIntoConstraints = false
        noDataImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            settingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            settingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            settingCollectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        if pharmacyNameArray.count == 0 {
            NSLayoutConstraint.activate([
                noDataImageView.topAnchor.constraint(equalTo: settingCollectionView.bottomAnchor, constant: 172.5),
                noDataImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noDataImageView.widthAnchor.constraint(equalToConstant: 279),
                noDataImageView.heightAnchor.constraint(equalToConstant: 252)
                
            ])
        } else {
            NSLayoutConstraint.activate([
                pharmacyCountLabel.topAnchor.constraint(equalTo: settingCollectionView.bottomAnchor, constant: 6),
                pharmacyCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
            ])
            
            NSLayoutConstraint.activate([
                locationCollectionView.topAnchor.constraint(equalTo: pharmacyCountLabel.bottomAnchor, constant: 10),
                locationCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                locationCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                locationCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        }
    }
    
    @objc func backButtonTapped() {
        // 앱 종료
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == settingCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Idf.settingCollectionViewCellIdentifier, for: indexPath) as? SettingCollectionViewCell else {
                return .zero
            }
            
            cell.mainLabel.text = textArray[indexPath.row]
            cell.mainLabel.sizeToFit()
            
            let cellWidth = cell.mainLabel.frame.width + 30
            
            return CGSize(width: cellWidth, height: 36)
            
        } else {
            return CGSize(width: collectionView.frame.width, height: 108)
        }
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == settingCollectionView {
            return textArray.count
        } else {
            return pharmacyNameArray.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == locationCollectionView {
            let locationCell = collectionView.dequeueReusableCell(withReuseIdentifier: Idf.locationCollectionViewCellIdentifier, for: indexPath) as! LocationCollectionViewCell
            
            locationCell.titleLabel.text = pharmacyNameArray[indexPath.item]
            
            return locationCell
            
        } else {
            
            let settingCell = collectionView.dequeueReusableCell(withReuseIdentifier: Idf.settingCollectionViewCellIdentifier, for: indexPath) as! SettingCollectionViewCell
            
            settingCell.mainLabel.text = textArray[indexPath.item]
            
            if indexPath.row == 0 {
                settingCell.mainLabel.textColor = UIColor.cellText
                settingCell.contentView.backgroundColor = UIColor.cellBackGround
                settingCell.contentView.layer.borderColor = UIColor.cellBorderColor.cgColor
                
            }
            return settingCell
        }
    }
}

