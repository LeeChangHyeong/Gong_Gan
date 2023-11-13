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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let textViewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.isHidden = true
        
        return view
    }()
    
    lazy var backGroundView: UIImageView = {
        let view = UIImageView(frame: UIScreen.main.bounds)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        
        return view
    }()
    
    private let memoTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textColor = .black
        view.text = "터치하여 오늘의 일기를 작성하세요"
        view.font = UIFont(name: "ArialHebrew", size: 15)
        
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("뒤로가기", for: .normal)
        
        return button
    }()
    
    private let saveMemoButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        
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
        backGroundView.addSubview(textViewColor)
        view.addSubview(memoTextView)
        view.addSubview(backButton)
    }
    
    private func setConstraints() {
        memoTextView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(31)
            $0.trailing.bottom.equalToSuperview().offset(-31)
            $0.top.equalToSuperview().offset(125)
        })
        
        textViewColor.snp.makeConstraints({
            $0.edges.equalToSuperview()
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
                self?.backGroundView.image = UIImage(named: image!)
            })
            .disposed(by: disposeBag)
        
        memoTextView.rx.text
            .bind(to: viewModel!.memoText)
            .disposed(by: disposeBag)
        
        memoTextView.rx.didBeginEditing
            .take(1)
            .subscribe(onNext: { [weak self] in
                self?.memoTextView.text = ""
            })
            .disposed(by: disposeBag)
        
        memoTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] in
                self?.textViewColor.isHidden = false
            })
            .disposed(by: disposeBag)
        
        memoTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.textViewColor.isHidden = true
            })
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
