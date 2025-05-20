import UIKit

class HomeViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let selectBossButton = UIButton()
    private let upgradeButton = UIButton()
    private let howToPlayButton = UIButton()
    private let resetButton = UIButton()
    private let settingsButton = UIButton()
    private let coinsView = UIView()
    private let coinsLabel = UILabel()
    private let coinImageView = UIImageView()
    private let gameManager = GameManager.shared
    private let dataManager = DataManager.shared
    
    // Timer for continuous animations
    private var animationTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCoinsDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTitleAnimations()
//        animateButtonsSequentially()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop animations when view disappears
        stopTitleAnimations()
    }
    
    private func setupUI() {
        // 添加游戏背景
        view.addGameBackground()
        
        // Setup title label
        titleLabel.text = "Defeat Slot Monster"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // Add shadow to make text pop
        titleLabel.layer.shadowColor = UIColor.red.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowRadius = 10
        titleLabel.layer.masksToBounds = false
        view.addSubview(titleLabel)
        
        // 设置金币显示视图
        setupCoinsView()
        
        // Setup buttons
        setupButton(selectBossButton, title: "SELECT BOSS", action: #selector(selectBossPressed))
        setupButton(upgradeButton, title: "UPGRADE", action: #selector(upgradePressed))
        setupButton(howToPlayButton, title: "HOW TO PLAY", action: #selector(howToPlayPressed))
        
        // Setup settings button
//        settingsButton.setImage(UIImage(named: "settings"), for: .normal)
//        settingsButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 0.7)
//        settingsButton.layer.cornerRadius = 25
//        settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
//        settingsButton.addPressAnimation()
//        settingsButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(settingsButton)
        
        // 重置按钮 - 样式与其他按钮略有不同
        resetButton.setTitle("RESET GAME", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        resetButton.layer.cornerRadius = 10
        resetButton.addTarget(self, action: #selector(resetGamePressed), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Title constraints
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            // Coins view constraints
            coinsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            coinsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            coinsView.heightAnchor.constraint(equalToConstant: 40),
            
            // Select boss button constraints
            selectBossButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectBossButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            selectBossButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            selectBossButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Upgrade button constraints
            upgradeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upgradeButton.topAnchor.constraint(equalTo: selectBossButton.bottomAnchor, constant: 20),
            upgradeButton.widthAnchor.constraint(equalTo: selectBossButton.widthAnchor),
            upgradeButton.heightAnchor.constraint(equalTo: selectBossButton.heightAnchor),
            
            // How to play button constraints
            howToPlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            howToPlayButton.topAnchor.constraint(equalTo: upgradeButton.bottomAnchor, constant: 20),
            howToPlayButton.widthAnchor.constraint(equalTo: selectBossButton.widthAnchor),
            howToPlayButton.heightAnchor.constraint(equalTo: selectBossButton.heightAnchor),
            
            
            // Reset button constraints
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            resetButton.widthAnchor.constraint(equalToConstant: 120),
            resetButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // MARK: - Animations
    
    private func startTitleAnimations() {
        // Initial animation
        animateTitleEntrance()
        
        // Setup repeating animations
        animationTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.animateTitlePulse()
        }
    }
    
    private func animateButtonsSequentially() {
        // Hide all buttons initially
        [selectBossButton, upgradeButton, howToPlayButton, resetButton, settingsButton].forEach { 
            $0.alpha = 0
            $0.transform = CGAffineTransform(scaleX: 0.1, y: 0.1) 
        }
        
        // Animate buttons with delay
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.selectBossButton.alpha = 1
            self.selectBossButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.8, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.upgradeButton.alpha = 1
            self.upgradeButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.howToPlayButton.alpha = 1
            self.howToPlayButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.resetButton.alpha = 1
            self.resetButton.transform = .identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 1.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.settingsButton.alpha = 1
            self.settingsButton.transform = .identity
        })
    }
    
    private func stopTitleAnimations() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func animateTitleEntrance() {
        // Initial state
        titleLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        titleLabel.alpha = 0
        
        // Animate to normal state with bounce effect
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.titleLabel.transform = .identity
            self.titleLabel.alpha = 1
        }, completion: nil)
    }
    
    private func animateTitlePulse() {
        // Series of animations for a pulsing effect
        UIView.animate(withDuration: 0.2, animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.titleLabel.layer.shadowColor = UIColor.orange.cgColor
            self.titleLabel.layer.shadowOpacity = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.titleLabel.layer.shadowColor = UIColor.yellow.cgColor
            }, completion: { _ in
                UIView.animate(withDuration: 0.8, animations: {
                    self.titleLabel.layer.shadowColor = UIColor.red.cgColor
                    self.titleLabel.layer.shadowOpacity = 0.8
                })
            })
        })
    }
    
    private func setupCoinsView() {
        // 设置金币视图容器
        coinsView.translatesAutoresizingMaskIntoConstraints = false
        coinsView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 0.7)
        coinsView.layer.cornerRadius = 20
        view.addSubview(coinsView)
        
        // 设置金币图标
        coinImageView.image = UIImage(named: "coin")
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinsView.addSubview(coinImageView)
        
        // 设置金币数量标签
        coinsLabel.textColor = .yellow
        coinsLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        coinsLabel.textAlignment = .left
        coinsLabel.translatesAutoresizingMaskIntoConstraints = false
        coinsView.addSubview(coinsLabel)
        
        // 更新金币显示
        updateCoinsDisplay()
        
        // 添加约束
        NSLayoutConstraint.activate([
            // 金币图标约束
            coinImageView.leadingAnchor.constraint(equalTo: coinsView.leadingAnchor, constant: 10),
            coinImageView.centerYAnchor.constraint(equalTo: coinsView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 30),
            coinImageView.heightAnchor.constraint(equalToConstant: 30),
            
            coinsLabel.centerXAnchor.constraint(equalTo: coinsView.centerXAnchor),
            coinsLabel.centerYAnchor.constraint(equalTo: coinsView.centerYAnchor),
            
            // Set fixed width to avoid layout recalculation
            coinsView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func updateCoinsDisplay() {
        // Simply update the text without recalculating layout
        coinsLabel.text = "\(gameManager.player.coins)"
    }
    
    private func setupButton(_ button: UIButton, title: String, action: Selector) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        // 使用扩展方法应用背景图片
        button.applyBackgroundImage(named: "button_bg")
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        // Add press animation
        button.addPressAnimation()
        view.addSubview(button)
    }
    
    @objc private func selectBossPressed() {
        let bossSelectionVC = BossSelectionViewController()
        bossSelectionVC.modalPresentationStyle = .fullScreen
        present(bossSelectionVC, animated: true)
    }
    
    @objc private func upgradePressed() {
        let upgradeVC = UpgradeViewController()
        upgradeVC.modalPresentationStyle = .fullScreen
        present(upgradeVC, animated: true)
    }
    
    @objc private func howToPlayPressed() {
        let howToPlayVC = HowToPlayViewController()
        howToPlayVC.modalPresentationStyle = .fullScreen
        present(howToPlayVC, animated: true)
    }
    
    @objc private func settingsPressed() {
        // 设置功能已被移除
        let alert = UIAlertController(title: "提示", message: "设置功能已被移除", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func resetGamePressed() {
        let alert = UIAlertController(
            title: "Reset Game Data",
            message: "Are you sure you want to reset all game progress? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // 删除存储的游戏数据
            self.dataManager.deleteGameData()
            
            // 显示确认提示
            let confirmAlert = UIAlertController(
                title: "Game Reset",
                message: "Your game data has been reset. The app will now restart.",
                preferredStyle: .alert
            )
            
            confirmAlert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                // 重启应用 - 在iOS中我们无法完全重启应用，但可以重置视图层次结构
                // 这里我们简单地让用户重新启动应用
                exit(0)
            })
            
            self.present(confirmAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
} 
