//
//  MainView.swift
//  Gong_Gan
//
//  Created by 이창형 on 2023/08/24.
//

import UIKit
import AVFoundation

class MainView: UIView {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var name = "1한강"
    let hour = Calendar.current.component(.hour, from: Date())
    
    lazy var videoView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        switch hour {
        case 1...3:
            name = "1한강"
        case 4...6:
            name = "2한강"
        case 7...11:
            name = "3한강"
        case 12...16:
            name = "4한강"
        case 17...18:
            name = "5한강"
        case 19...20:
            name = "6한강"
        case 21...24, 0:
            name = "7한강"
        default:
            name = "1한강"
        }
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
