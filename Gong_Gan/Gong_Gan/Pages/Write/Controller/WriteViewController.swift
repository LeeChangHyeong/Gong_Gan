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
    
    private let memoTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.textColor = .white
        view.text = "Enter your text here"
        view.isEditable = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("뒤로가기", for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setConstraints()
        setupControl()
    }
    
    private func addSubViews() {
        view.addSubview(backGroundView)
        view.addSubview(memoTextView)
        view.addSubview(backButton)
    }
    
    private func setConstraints() {
        memoTextView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.bottom.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(200)
        })
        
        backButton.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    private func setupControl() {
        // WriteViewModel의 backgroundImage를 구독하여 값이 업데이트될 때마다 실행되는 클로저 정의
        viewModel?.backgroundImage
            .subscribe(onNext: { [weak self] image in
                // 값이 업데이트되면 받아온 이미지를 배경으로 설정
                self?.backGroundView.image = image
            })
        
        memoTextView.rx.text
            .bind(to: viewModel!.memoText)
            .disposed(by: disposeBag)
        
        memoTextView.rx.didBeginEditing
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.memoTextView.text = ""
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
             .subscribe(onNext: { [weak self] in
                 self?.navigationController?.popViewController(animated: true)
             })
             .disposed(by: disposeBag)
    }
    
}
