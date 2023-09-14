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
    var cameraModePicker: UIPickerView!
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    private let mainView = MainView()
    private let bottomBarView = BottomBarView()
    private let topBarView = TopBarView()
    let captureModesList = ["Default","Sepia","Warm","Cool","Vivid", "Noir"]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backGroundViewTapped)))
        
        cameraModePicker = UIPickerView()
        cameraModePicker.dataSource = self
        cameraModePicker.delegate = self
        cameraModePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        addSubView()
        setConstraints()
    }
    
    private func addSubView() {
        view.addSubview(topBarView)
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(cameraModePicker)
    }
    
    private func setConstraints() {
        bottomBarViewConstraints()
        topBarViewConstraints()
        cameraModePickerViewConstraints()
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
    
    private func cameraModePickerViewConstraints() {
        cameraModePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cameraModePicker.widthAnchor.constraint(equalToConstant: 100),
            cameraModePicker.heightAnchor.constraint(equalToConstant: 500),
            cameraModePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraModePicker.centerYAnchor.constraint(equalTo: bottomBarView.topAnchor, constant: 16)
        ])
        
    }
    
    // 백그라운드 터치시 topBar, bottomBar 사라지면서 backGround가 전체화면으로 보임
    @objc private func backGroundViewTapped(_ recognizer: UITapGestureRecognizer) {
        backGroundTap.toggle()
        
        if backGroundTap == true {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.topBarView.alpha = 0.0
                self.bottomBarView.alpha = 0.0
            }
            
        } else if backGroundTap == false {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self.topBarView.alpha = 1.0
                self.bottomBarView.alpha = 1.0
            }
        }
    }
}



extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return captureModesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let modeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        modeLabel.textColor = .white
        modeLabel.text = captureModesList[row]
        modeLabel.textAlignment = .center
        modeView.addSubview(modeLabel)
        
        // 피커 회전
        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))

        return modeView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 100
    }
}
