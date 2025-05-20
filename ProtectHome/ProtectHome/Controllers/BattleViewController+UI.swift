import UIKit

// MARK: - UI Setup
extension BattleViewController {
    
    func setupUI() {
        // 添加游戏背景
        view.addGameBackground()
        
        // Setup player info view
        playerInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerInfoView)
        
        // Setup boss info view
        bossInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bossInfoView)
        
        // Setup turn label
        turnLabel.text = "PLAYER TURN"
        turnLabel.textColor = .white
        turnLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        turnLabel.textAlignment = .center
        turnLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(turnLabel)
        
        // Setup exit button
        exitButton.setTitle("", for: .normal) // 移除文字
        exitButton.setImage(UIImage(named: "exit"), for: .normal) // 使用exit图片
        exitButton.imageView?.contentMode = .scaleAspectFit // 保持图片原始比例
        exitButton.backgroundColor = .clear // 移除背景色
        exitButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) // 添加内边距
        exitButton.layer.cornerRadius = 0 // 移除圆角
        exitButton.clipsToBounds = true
        exitButton.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        exitButton.addPressAnimation()
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        // Setup spin button
        spinButton.setTitle("SPIN", for: .normal)
        spinButton.setTitleColor(.white, for: .normal)

        // 使用扩展方法应用背景图片
        spinButton.applyBackgroundImage(named: "button_bg")
        spinButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        spinButton.addTarget(self, action: #selector(spinButtonPressed), for: .touchUpInside)
        spinButton.addPressAnimation()
        spinButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinButton)
        
        // Setup player slot machine view
        playerSlotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerSlotView)
        
        // Setup boss slot machine view
        bossSlotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bossSlotView)
        
        // Setup notification label
        notificationLabel.textColor = .white
        notificationLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        notificationLabel.textAlignment = .center
        notificationLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        notificationLabel.layer.cornerRadius = 10
        notificationLabel.clipsToBounds = true
        notificationLabel.isHidden = true
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notificationLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Player info view constraints
            playerInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            playerInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            playerInfoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            playerInfoView.heightAnchor.constraint(equalToConstant: 110),
            
            // Boss info view constraints
            bossInfoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            bossInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bossInfoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            bossInfoView.heightAnchor.constraint(equalToConstant: 110),
            
            // Turn label constraints
            turnLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            turnLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            // Exit button constraints
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            exitButton.widthAnchor.constraint(equalToConstant: 60), // 放大一倍
            exitButton.heightAnchor.constraint(equalToConstant: 60), // 放大一倍
            
            // Spin button constraints
            spinButton.centerXAnchor.constraint(equalTo: playerInfoView.centerXAnchor),
            spinButton.topAnchor.constraint(equalTo: playerSlotView.bottomAnchor, constant: 20),
            spinButton.widthAnchor.constraint(equalToConstant: 200),
            spinButton.heightAnchor.constraint(equalToConstant: 100),
            
            // Player slot machine view constraints
            playerSlotView.topAnchor.constraint(equalTo: playerInfoView.bottomAnchor, constant: 15),
            playerSlotView.leadingAnchor.constraint(equalTo: playerInfoView.leadingAnchor),
            playerSlotView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            playerSlotView.heightAnchor.constraint(equalToConstant: 130),
            
            // Boss slot machine view constraints
            bossSlotView.topAnchor.constraint(equalTo: bossInfoView.bottomAnchor, constant: 15),
            bossSlotView.trailingAnchor.constraint(equalTo:bossInfoView.trailingAnchor),
            bossSlotView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            bossSlotView.heightAnchor.constraint(equalToConstant: 130),
            
            // Notification label constraints
            notificationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            notificationLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            notificationLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
} 
