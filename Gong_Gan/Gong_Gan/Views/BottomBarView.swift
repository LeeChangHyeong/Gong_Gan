//
//  BottomBarView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/09/14.
//

import UIKit

class BottomBarView: UIView {
    
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
        
        backgroundColor = .black
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(galleryButton)
        addSubview(containerView)
        containerView.addSubview(addMemoButton)
        addSubview(settingButton)
        
    }
    
    private func setConstraints() {
        galleryButtonConstraints()
        containerViewConstraints()
        addMemoButtonConstratints()
        settingButtonConstraints()
    }
    
    private func galleryButtonConstraints() {
        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            galleryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            galleryButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            galleryButton.widthAnchor.constraint(equalToConstant: 49),
            galleryButton.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
    
    private func containerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
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
            settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            settingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            settingButton.widthAnchor.constraint(equalToConstant: 49),
            settingButton.heightAnchor.constraint(equalToConstant: 49)
        ])
    }
}
