//
//  MainView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/24.
//

import UIKit

class MainView: UIView {
    let backGroundView: UIImageView = {
        let view = UIImageView(frame: UIScreen.main.bounds)
        view.image = UIImage(named: "1")!
        view.contentMode =  UIView.ContentMode.scaleAspectFill
        
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
    }
    
    
    private func setConstraints() {
        topBarViewConstraints()
        bottomBarViewConstraints()
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
    
    
}
