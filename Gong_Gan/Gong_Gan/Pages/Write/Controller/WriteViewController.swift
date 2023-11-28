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
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth


class WriteViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: WriteViewModel?
    var backgroundImage: UIImage?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let textViewColor: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        view.textColor = .white
        view.text = "터치하여 오늘의 일기를 작성하세요"
        view.font = UIFont(name: "ArialHebrew", size: 15)
        
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
            let image = UIImage(systemName: "chevron.backward")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
            button.setImage(image, for: .normal)

            button.tintColor = .white
            
            return button
    }()
    
    private let nowDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .light)
        
        return label
    }()
    
    private let saveMemoButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setNaviBar()
        setConstraints()
        setupControl()
    }
    
    private func addSubViews() {
        view.addSubview(backGroundView)
        backGroundView.addSubview(textViewColor)
        view.addSubview(memoTextView)
    }
    
    private func setNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView = nowDateLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveMemoButton)
    }
    
    private func setConstraints() {
        memoTextView.snp.makeConstraints({
            $0.leading.equalToSuperview().offset(31)
            $0.trailing.bottom.equalToSuperview().offset(-31)
            $0.top.equalToSuperview().offset(167)
        })
        
        textViewColor.snp.makeConstraints({
            $0.edges.equalToSuperview()
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
        
        viewModel?.nowDateText
                .bind(to: nowDateLabel.rx.text)
                .disposed(by: disposeBag)
    
        
        saveMemoButton.rx.tap
            .subscribe(onNext:{ [weak self] in
                self?.viewModel?.saveMemo { error in
                    if let error = error {
                        print("WriteViewController saveMemo Error: \(error.localizedDescription)")
                    }
                }
            }).disposed(by: disposeBag)

    }
    
}
