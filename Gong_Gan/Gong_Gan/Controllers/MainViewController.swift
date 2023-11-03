//
//  MainViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/23.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // 백그라운드 터치 여부 확인
    var backGroundTap = false
    var cameraModePicker: UIPickerView!
    var rotationAngle: CGFloat! = -90  * (.pi/180)
    
    private let mainView = MainView()
    private let bottomBarView = BottomBarView()
    private let topBarView = TopBarView()
    
    let captureModesList = ["도시","방","일본","지하철","야경"]
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backGroundViewTapped)))
        self.navigationController?.isNavigationBarHidden = true
        
        setCameraModePicker()
        addSubView()
        setConstraints()
    }
    
    private func addSubView() {
        view.addSubview(topBarView)
        view.addSubview(bottomBarView)
        bottomBarView.addSubview(cameraModePicker)
    }
    
    private func setCameraModePicker() {
        cameraModePicker = UIPickerView()
        cameraModePicker.dataSource = self
        cameraModePicker.delegate = self
        cameraModePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    private func setConstraints() {
        bottomBarViewConstraints()
        topBarViewConstraints()
        cameraModePickerViewConstraints()
    }
    
    private func topBarViewConstraints() {
        
        topBarView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(127)
        })
    }
    
    private func bottomBarViewConstraints() {
        
        bottomBarView.snp.makeConstraints({
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(166)
        })
    }
    
    private func cameraModePickerViewConstraints() {
        
        cameraModePicker.snp.makeConstraints({
            $0.width.equalTo(40)
            $0.height.equalTo(300)
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(bottomBarView.snp.topMargin).offset(16)
        })
        
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



extension MainViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return captureModesList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
            label.textColor = .white
            label.text = captureModesList[row]
            label.textAlignment = .center
            label.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        
        pickerView.subviews.forEach {
               $0.backgroundColor = UIColor.clear
           }
            
            return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 100
    }
}

extension MainViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        mainView.backGroundView.image = UIImage(named: captureModesList[row])
    }
}
