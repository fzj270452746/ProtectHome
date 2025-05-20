import UIKit

class UpgradeViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let coinsView = UIView()
    private let coinsLabel = UILabel()
    private let coinImageView = UIImageView()
    private let backButton = UIButton()
    
    private let healthUpgradeView = UpgradeOptionView()
    private let attackUpgradeView = UpgradeOptionView()
    private let shieldUpgradeView = UpgradeOptionView()
    
    private let gameManager = GameManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIWithPlayerStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIWithPlayerStats()
    }
    
    private func setupUI() {
        // 添加游戏背景
        view.addGameBackground()
        
        // Setup title label
        titleLabel.text = "UPGRADE"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Setup coins view container
        setupCoinsView()
        
        // Setup back button
        backButton.setTitle("", for: .normal)
        backButton.setImage(UIImage(named: "exit"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.backgroundColor = .clear
        backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        backButton.layer.cornerRadius = 0
        backButton.clipsToBounds = true
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        // Setup upgrade options
        setupUpgradeOption(healthUpgradeView, title: "HEALTH", description: "Increase max health by 20", cost: 50, action: #selector(upgradeHealth))
        setupUpgradeOption(attackUpgradeView, title: "ATTACK", description: "Increase attack by 5", cost: 50, action: #selector(upgradeAttack))
        setupUpgradeOption(shieldUpgradeView, title: "SHIELD", description: "Increase max shields by 1", cost: 100, action: #selector(upgradeShield))
        
        view.addSubview(healthUpgradeView)
        view.addSubview(attackUpgradeView)
        view.addSubview(shieldUpgradeView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Title constraints
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            // Coins view constraints
            coinsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            coinsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            coinsView.heightAnchor.constraint(equalToConstant: 40),
            
            // Back button constraints
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 80), // 放大一倍
            backButton.heightAnchor.constraint(equalToConstant: 80), // 放大一倍
            
            // Health upgrade view constraints
            healthUpgradeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            healthUpgradeView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45),
            healthUpgradeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            healthUpgradeView.heightAnchor.constraint(equalToConstant: 80),
            
            // Attack upgrade view constraints
            attackUpgradeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attackUpgradeView.topAnchor.constraint(equalTo: healthUpgradeView.bottomAnchor, constant: 20),
            attackUpgradeView.widthAnchor.constraint(equalTo: healthUpgradeView.widthAnchor),
            attackUpgradeView.heightAnchor.constraint(equalTo: healthUpgradeView.heightAnchor),
            
            // Shield upgrade view constraints
            shieldUpgradeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shieldUpgradeView.topAnchor.constraint(equalTo: attackUpgradeView.bottomAnchor, constant: 20),
            shieldUpgradeView.widthAnchor.constraint(equalTo: healthUpgradeView.widthAnchor),
            shieldUpgradeView.heightAnchor.constraint(equalTo: healthUpgradeView.heightAnchor)
        ])
    }
    
    private func setupUpgradeOption(_ upgradeView: UpgradeOptionView, title: String, description: String, cost: Int, action: Selector) {
        upgradeView.titleLabel.text = title
        upgradeView.descriptionLabel.text = description
        
        // 更新成本标签 - 将在updateUIWithPlayerStats()中设置真实的成本
        upgradeView.costLabel.text = "\(cost) COINS"
        upgradeView.upgradeButton.addTarget(self, action: action, for: .touchUpInside)
        upgradeView.translatesAutoresizingMaskIntoConstraints = false
        
        // 根据类型设置对应的图标
        switch title {
        case "HEALTH":
            upgradeView.setIcon(named: "symbol_heal")
        case "ATTACK":
            upgradeView.setIcon(named: "symbol_attack")
        case "SHIELD":
            upgradeView.setIcon(named: "symbol_shield")
        default:
            break
        }
    }
    
    private func setupCoinsView() {
        // Setup coins view container
        coinsView.translatesAutoresizingMaskIntoConstraints = false
        coinsView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 0.7)
        coinsView.layer.cornerRadius = 20
        view.addSubview(coinsView)
        
        // Setup coin image
        coinImageView.image = UIImage(named: "coin")
        coinImageView.contentMode = .scaleAspectFit
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinsView.addSubview(coinImageView)
        
        // Setup coins label
        coinsLabel.textColor = .yellow
        coinsLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        coinsLabel.textAlignment = .left
        coinsLabel.translatesAutoresizingMaskIntoConstraints = false
        coinsView.addSubview(coinsLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Coin image constraints
            coinImageView.leadingAnchor.constraint(equalTo: coinsView.leadingAnchor, constant: 10),
            coinImageView.centerYAnchor.constraint(equalTo: coinsView.centerYAnchor),
            coinImageView.widthAnchor.constraint(equalToConstant: 30),
            coinImageView.heightAnchor.constraint(equalToConstant: 30),
            
            coinsLabel.centerXAnchor.constraint(equalTo: coinsView.centerXAnchor),
            coinsLabel.centerYAnchor.constraint(equalTo: coinsView.centerYAnchor),
            
            // Set fixed width to avoid layout recalculation
            coinsView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        // Update coins display
        updateCoinsDisplay()
    }
    
    private func updateCoinsDisplay() {
        // Simply update the text without recalculating layout
        coinsLabel.text = "\(gameManager.player.coins)"
    }
    
    private func updateUIWithPlayerStats() {
        // Perform UI updates in a single operation for better performance
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Update coins display
            self.updateCoinsDisplay()
            
            // Update upgrade options based on current stats
            self.healthUpgradeView.currentValueLabel.text = "Current: \(self.gameManager.player.maxHealth)"
            self.attackUpgradeView.currentValueLabel.text = "Current: \(self.gameManager.player.attack)"
            self.shieldUpgradeView.currentValueLabel.text = "Current: \(self.gameManager.player.maxShields)"
            
            // Calculate and update upgrade costs
            let healthCost = self.gameManager.calculateUpgradeCost(type: .health)
            let attackCost = self.gameManager.calculateUpgradeCost(type: .attack)
            let shieldCost = self.gameManager.calculateUpgradeCost(type: .shield)
            
            self.healthUpgradeView.costLabel.text = "\(healthCost) COINS"
            self.attackUpgradeView.costLabel.text = "\(attackCost) COINS"
            self.shieldUpgradeView.costLabel.text = "\(shieldCost) COINS"
            
            // Update button states based on available coins
            let coins = self.gameManager.player.coins
            let healthEnabled = coins >= healthCost
            let attackEnabled = coins >= attackCost
            let shieldEnabled = coins >= shieldCost
            
            self.healthUpgradeView.upgradeButton.isEnabled = healthEnabled
            self.attackUpgradeView.upgradeButton.isEnabled = attackEnabled
            self.shieldUpgradeView.upgradeButton.isEnabled = shieldEnabled
            
            // Update button alpha based on enabled state
            self.healthUpgradeView.upgradeButton.alpha = healthEnabled ? 1.0 : 0.5
            self.attackUpgradeView.upgradeButton.alpha = attackEnabled ? 1.0 : 0.5
            self.shieldUpgradeView.upgradeButton.alpha = shieldEnabled ? 1.0 : 0.5
        }
    }
    
    @objc private func upgradeHealth() {
        if gameManager.upgradePlayer(health: 20, attack: 0, maxShields: 0, upgradeType: .health) {
            updateUIWithPlayerStats()
            showUpgradeSuccessMessage(for: "health")
        }
    }
    
    @objc private func upgradeAttack() {
        if gameManager.upgradePlayer(health: 0, attack: 5, maxShields: 0, upgradeType: .attack) {
            updateUIWithPlayerStats()
            showUpgradeSuccessMessage(for: "attack")
        }
    }
    
    @objc private func upgradeShield() {
        if gameManager.upgradePlayer(health: 0, attack: 0, maxShields: 1, upgradeType: .shield) {
            updateUIWithPlayerStats()
            showUpgradeSuccessMessage(for: "shield capacity")
        }
    }
    
    @objc private func backButtonPressed() {
        // Use completion handler to ensure proper cleanup after dismissal
        dismiss(animated: true) { [weak self] in
            // Cleanup if needed after dismissal
        }
    }
    
    private func showUpgradeSuccessMessage(for stat: String) {
        let alert = UIAlertController(title: "Upgrade Successful", 
                                     message: "Your \(stat) has been upgraded!", 
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

// MARK: - Upgrade Option View
class UpgradeOptionView: UIView {
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let currentValueLabel = UILabel()
    let costLabel = UILabel()
    let upgradeButton = UIButton()
    let iconImageView = UIImageView()
    private var iconName: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        layer.cornerRadius = 10
        
        // 设置图标图像视图
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Setup title label
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Setup description label
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        
        // Setup current value label
        currentValueLabel.textColor = .white
        currentValueLabel.font = UIFont.systemFont(ofSize: 14)
        currentValueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currentValueLabel)
        
        // Setup cost label
        costLabel.textColor = .yellow
        costLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(costLabel)
        
        // Setup upgrade button
        upgradeButton.setTitle("UPGRADE", for: .normal)
        upgradeButton.setTitleColor(.white, for: .normal)

        // 使用扩展方法应用背景图片
        upgradeButton.applyBackgroundImage(named: "button_bg", cornerRadius: 5)
        upgradeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        upgradeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(upgradeButton)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // 图标约束
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Title label constraints - 修改使它放在图标右侧
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            
            // Description label constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            
            // Current value label constraints
            currentValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            currentValueLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            
            // Cost label constraints
            costLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            costLabel.trailingAnchor.constraint(equalTo: upgradeButton.leadingAnchor, constant: -20),
            
            // Upgrade button constraints
            upgradeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            upgradeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            upgradeButton.widthAnchor.constraint(equalToConstant: 100),
            upgradeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // 设置图标的方法
    func setIcon(named iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
    }
} 
