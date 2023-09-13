//
//  MainView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/24.
//

import UIKit

class MainView: UIView {
    
    // 백그라운드 터치 여부 확인
    var backGroundTap = false{
        didSet {
            topBarView.reloadInputViews()
        }
    }
    lazy var backGroundView: UIImageView = {
        let view = UIImageView(frame: UIScreen.main.bounds)
        view.image = UIImage(named: "1")!
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backGroundViewTapped)))
        view.isUserInteractionEnabled = true

        return view
    }()
    
    let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    let bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    let galleryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.setImage(UIImage(systemName: "book.closed.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    let addMemoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        
        return button
    }()
    
    private let containerView: UIView = {
      let view = UIView()
      view.backgroundColor = .clear
      view.layer.borderWidth = 3
      view.layer.cornerRadius = 35
      view.layer.borderColor = UIColor.buttonColor.cgColor
      
      return view
    }()
    
    let settingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(backGroundView)
        backGroundView.addSubview(topBarView)
        backGroundView.addSubview(bottomBarView)
        bottomBarView.addSubview(galleryButton)
        bottomBarView.addSubview(containerView)
        containerView.addSubview(addMemoButton)
        bottomBarView.addSubview(settingButton)
        
    }
    
    private func setConstraints() {
        topBarViewConstraints()
        bottomBarViewConstraints()
        galleryButtonConstraints()
        containerViewConstraints()
        addMemoButtonConstratints()
        settingButtonConstraints()
    }
    
    private func topBarViewConstraints() {
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: backGroundView.topAnchor, constant: 0),
            topBarView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor, constant: 0),
            topBarView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: 0),
            topBarView.heightAnchor.constraint(equalToConstant: 127)
        ])
    }
    
    private func bottomBarViewConstraints() {
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomBarView.bottomAnchor.constraint(equalTo: backGroundView.bottomAnchor, constant: 0),
            bottomBarView.leadingAnchor.constraint(equalTo: backGroundView.leadingAnchor, constant: 0),
            bottomBarView.trailingAnchor.constraint(equalTo: backGroundView.trailingAnchor, constant: 0),
            bottomBarView.heightAnchor.constraint(equalToConstant: 166)
        ])
    }
    
    private func galleryButtonConstraints() {
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            galleryButton.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 50),
            galleryButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            galleryButton.widthAnchor.constraint(equalToConstant: 49),
            galleryButton.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
    
    
    private func containerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: bottomBarView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 70),
            containerView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addMemoButtonConstratints() {
        addMemoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addMemoButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addMemoButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            addMemoButton.widthAnchor.constraint(equalToConstant: 60),
            addMemoButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func settingButtonConstraints() {
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -50),
            settingButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            settingButton.widthAnchor.constraint(equalToConstant: 49),
            settingButton.heightAnchor.constraint(equalToConstant: 49)
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


