//
//  MainViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/23.
//

import UIKit

class MainViewController: UIViewController {
    
    // 백그라운드 터치 여부 확인
    var backGroundTap = false
    
    private let mainView = MainView()
    private let bottomBarView = BottomBarView()
    private let topBarView = TopBarView()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backGroundViewTapped)))
        
        addSubView()
        setConstraints()
    }
    
    private func addSubView() {
        view.addSubview(topBarView)
        view.addSubview(bottomBarView)
    }
    
    private func setConstraints() {
        bottomBarViewConstraints()
        topBarViewConstraints()
    }
    
    private func topBarViewConstraints() {
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 127)
        ])
    }
    
    private func bottomBarViewConstraints() {
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 166)
        ])
    }
    
        // 백그라운드 터치시 topBar, bottomBar 사라지면서 backGround가 전체화면으로 보임
        @objc private func backGroundViewTapped(_ recognizer: UITapGestureRecognizer) {
            backGroundTap.toggle()
    
            if backGroundTap == true {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                    self.topBarView.alpha = 0.0
                    self.bottomBarView.alpha = 0.0
                }
    
            } else if backGroundTap == false {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                    self.topBarView.alpha = 1.0
                    self.bottomBarView.alpha = 1.0
                }
            }
        }
}

