//
//  SettingViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/2/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class SettingViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
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
        label.text = "설정"
        label.font = .systemFont(ofSize: 17, weight: .light)
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .galleryColor
        setNaviBar()
        setupControl()
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = titleLabel
    }
    
    private func setupControl() {
        backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

