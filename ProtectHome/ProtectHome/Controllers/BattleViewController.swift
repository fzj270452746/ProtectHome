import UIKit

class BattleViewController: UIViewController {
    
    // UI Elements
    let playerInfoView = CharacterInfoView()
    let bossInfoView = CharacterInfoView()
    let turnLabel = UILabel()
    let exitButton = UIButton()
    let spinButton = UIButton()
    let playerSlotView = SlotMachineView()
    let bossSlotView = SlotMachineView()
    let notificationLabel = UILabel()
    
    // Game data
    let gameManager = GameManager.shared
    var boss: Boss
    var battleLog = [String]()
    var spinningInProgress = false
    
    // MARK: - Initialization
    
    init(boss: Boss) {
        self.boss = boss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGameManager()
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        animateInterfaceElements()
    }
    
    // MARK: - Animations
    
    private func animateInterfaceElements() {
        // Prepare elements for animation
        [playerInfoView, bossInfoView].forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: -50)
        }
        
        [playerSlotView, bossSlotView].forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        turnLabel.alpha = 0
        spinButton.alpha = 0
        spinButton.transform = CGAffineTransform(translationX: 0, y: 50)
        
        // Animate player & boss info views
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
            self.playerInfoView.alpha = 1
            self.playerInfoView.transform = .identity
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.bossInfoView.alpha = 1
            self.bossInfoView.transform = .identity
        })
        
        // Animate slot machines
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.playerSlotView.alpha = 1
            self.playerSlotView.transform = .identity
            self.bossSlotView.alpha = 1
            self.bossSlotView.transform = .identity
        })
        
        // Animate turn label and spin button
        UIView.animate(withDuration: 0.5, delay: 0.7, options: [], animations: {
            self.turnLabel.alpha = 1
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.9, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.spinButton.alpha = 1
            self.spinButton.transform = .identity
        })
    }
    
    // MARK: - Game Methods
    
    private func setupGameManager() {
        gameManager.gameStateDelegate = self
        gameManager.battleDelegate = self
    }
    
    private func startGame() {
        gameManager.startGame(withBoss: boss)
        
        // Update UI with initial stats
        updateCharacterInfoViews()
    }
    
    func updateCharacterInfoViews() {
        // Update player info
        playerInfoView.configure(with: gameManager.player)
        
        // Update boss info
        if let boss = gameManager.currentBoss {
            bossInfoView.configure(with: boss)
        }
    }
    
    // MARK: - Actions
    
    @objc func spinButtonPressed() {
        guard !spinningInProgress else { return }
        guard gameManager.gameInProgress && gameManager.playerTurn else { return }
        
        spinningInProgress = true
        spinButton.isEnabled = false
        
        // 先获取游戏逻辑的随机符号结果
        let gameSymbols = gameManager.preparePlayerSpin()
        
        // 使用游戏逻辑生成的符号结果来驱动UI动画
        playerSlotView.spin(withFinalSymbols: gameSymbols) { [weak self] symbols in
            guard let self = self else { return }
            
            // 使用预先准备的符号执行游戏逻辑
            self.gameManager.executePlayerSpin(with: gameSymbols)
            self.spinningInProgress = false
            self.spinButton.isEnabled = self.gameManager.gameInProgress && self.gameManager.playerTurn
        }
    }
    
    @objc func exitButtonPressed() {
        dismiss(animated: true)
    }
    
    // MARK: - Helper Methods
    
    func showNotification(_ message: String, duration: TimeInterval = 2.0) {
        notificationLabel.text = message
        notificationLabel.isHidden = false
        
        // Reset any ongoing animations
        notificationLabel.layer.removeAllAnimations()
        
        // Initial state
        notificationLabel.alpha = 0
        notificationLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Appear with spring animation
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
            self.notificationLabel.alpha = 1
            self.notificationLabel.transform = .identity
        })
        
        // Hide notification after duration with fade out
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
                self?.notificationLabel.alpha = 0
                self?.notificationLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
                self?.notificationLabel.isHidden = true
            })
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

 
