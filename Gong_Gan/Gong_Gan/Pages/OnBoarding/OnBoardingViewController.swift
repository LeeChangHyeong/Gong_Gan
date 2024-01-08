//
//  OnBoardingViewController.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/7/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OnBoardingViewController: UIPageViewController {
    private var disposeBag = DisposeBag()
    private var pages = [UIViewController]()
    private var initialPage = 0
    private var pageControl: UIPageControl!
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .inactiveFalseColor
        button.setTitleColor(.inactiveFalseTextColor, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        
        return button
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        view.backgroundColor = .mainBackGroundColor
        setupPage()
        setConstraints()
        setButton()
        
    }
    
    
    
    private func setupPage() {
        let page1 =  OnBoardingPageViewController(imageName: "온보딩1",
                                                  title: "오늘은 어떤 순간을\n찍어볼까요?",
                                                  subTitle: "셔터를 눌러 사진을 찍고, 자유롭게 기록해보세요.")
        let page2 = OnBoardingPageViewController(imageName: "온보딩2",
                                                 title: "변화하는\n나만의 공간",
                                                 subTitle: "날씨와 시간에 따라 달라지는 풍경을 만나보세요.")
        let page3 = OnBoardingPageViewController(imageName: "온보딩3",
                                                 title: "변하지 않는\n그날의 기록들",
                                                 subTitle: "나의 기록을 한 눈에 볼 수 있어요.")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: false, completion: nil)
        
        // UIPageControl 추가
        pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        pageControl.currentPageIndicatorTintColor = .brandColor
        pageControl.pageIndicatorTintColor = .lightGray
    }
    
    private func setConstraints() {
        view.addSubview(button)
        button.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            $0.height.equalTo(55)
            
            view.addSubview(pageControl)
            pageControl.snp.makeConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            })
        })
    }
    
    private func setButton() {
        
        button.rx.tap
            .subscribe(onNext: {
                AppController.shared.routeToLogin()
            })
            .disposed(by: disposeBag)
    }
    
}

extension OnBoardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < (pages.count - 1) else {
            return nil
        }
        return pages[currentIndex + 1]
    }
    
    // 페이지 변경 시 UIPageControl 업데이트
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = viewControllers?.first, let index = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = index
            // 페이지가 끝에 도달하면 버튼 활성화
            if index == pages.count - 1 {
                button.isEnabled = true
                button.setTitleColor(.black, for: .normal)
                button.backgroundColor = .brandColor
            }
        }
    }
    
}
