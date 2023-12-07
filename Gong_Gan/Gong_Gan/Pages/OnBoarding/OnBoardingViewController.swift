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
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("홈으로", for: .normal)
        button.backgroundColor = .green
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubview(button)
        button.snp.makeConstraints({
            $0.centerY.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        })
        
        button.rx.tap
            .subscribe(onNext: {
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true)
            })
    }
    


}
