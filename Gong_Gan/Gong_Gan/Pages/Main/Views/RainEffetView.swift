//
//  RainEffetView.swift
//  Gong_Gan
//
//  Created by 이창형 on 12/13/23.
//

import UIKit
import SpriteKit
import SnapKit

class RainEffetView: UIView {
    lazy var rainView: SKView = {
        let view = SKView()
        view.backgroundColor = .clear
        let scene = RainFall()
        view.presentScene(scene)
        
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
    
    private func addViews() {
        self.addSubview(rainView)
    }
    
    private func setConstraints() {
        rainView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}

class RainFall: SKScene {
    override func sceneDidLoad() {
        // 화면 크기를 기기 크기로 설정
        size = UIScreen.main.bounds.size
        // 화면 크기를 모두 채우도록
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        
        // Rain.sks 파일을 들고와서 SKEmitterNode 생성
        let node = SKEmitterNode(fileNamed: "Rain.sks")!
        // 추가
        addChild(node)
        // 노드 위치 범위를 화면 너비로 설정
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}
