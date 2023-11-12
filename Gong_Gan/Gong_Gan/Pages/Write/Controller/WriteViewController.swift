//
//  WriteViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 11/12/23.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WriteViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: WriteViewModel?
    var backgroundImage: UIImage?
    
    lazy var backGroundView: UIImageView = {
        let view = UIImageView(frame: UIScreen.main.bounds)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        
        return view
    }()
    
//    private let scrollView: UIScrollView = {
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setupControl()
        
    }
    
    private func addSubViews() {
        view.addSubview(backGroundView)
    }
    
    private func setupControl() {
        view.backgroundColor = .white
        // WriteViewModel의 backgroundImage를 구독하여 값이 업데이트될 때마다 실행되는 클로저 정의
        viewModel?.backgroundImage
            .subscribe(onNext: { [weak self] image in
                // 값이 업데이트되면 받아온 이미지를 배경으로 설정
                self?.backGroundView.image = image
            })
    }
    
}
