//
//  OnBoardingViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/7/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OnBoardingViewController: UIViewController {
    
    private var pages = [UIViewController]()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.backgroundColor = .brandColor
        button.layer.cornerRadius = 8
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackGroundColor
        view.addSubview(button)
        setConstraints()
        setButton()
    }
    
    private func setConstraints() {
        button.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-60)
            $0.height.equalTo(55)
        })
    }
    
    private func setButton() {
        
        button.rx.tap
            .subscribe(onNext: {
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true)
            })
    }
    


}
