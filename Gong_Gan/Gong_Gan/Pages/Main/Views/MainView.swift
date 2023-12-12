//
//  MainView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/24.
//

//import UIKit
//
//class MainView: UIView {
//    
//    lazy var backGroundView: UIImageView = {
//        let view = UIImageView(frame: UIScreen.main.bounds)
//        view.image = UIImage(named: "도시")!
//        view.contentMode = UIView.ContentMode.scaleAspectFill
//        view.isUserInteractionEnabled = true
//
//        return view
//    }()
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func addViews() {
//        addSubview(backGroundView)
//    }
//}
//
//

import UIKit
import AVFoundation

class MainView: UIView {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var name = "1하늘"
    
    lazy var videoView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVideoView()
        playVideo(with: name)
        observePlayerDidPlayToEndTime()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVideoView() {
        addSubview(videoView)
    }
    
    func playVideo(with resourceName: String) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "mp4") else {
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        playerLayer.videoGravity = .resizeAspectFill
        player.play()

        // 클래스 프로퍼티에 할당
        self.player = player
        self.playerLayer = playerLayer
    }

    func observePlayerDidPlayToEndTime() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
}
