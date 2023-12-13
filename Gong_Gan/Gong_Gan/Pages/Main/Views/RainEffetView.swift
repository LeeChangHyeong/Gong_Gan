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
        size = UIScreen.main.bounds.size
        scaleMode = .resizeFill
        anchorPoint = CGPoint(x: 0.5, y: 1)
        backgroundColor = .clear
        
        let node = SKEmitterNode(fileNamed: "Rain.sks")!
        addChild(node)
        
        node.particlePositionRange.dx = UIScreen.main.bounds.width
    }
}
