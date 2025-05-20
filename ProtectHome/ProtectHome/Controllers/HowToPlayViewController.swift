import UIKit

class HowToPlayViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let instructionsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // 添加游戏背景
        view.addGameBackground()
        
        // Setup title label
        titleLabel.text = "HOW TO PLAY"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
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
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Setup content view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Title constraints
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            // Back button constraints
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 80), // 放大一倍
            backButton.heightAnchor.constraint(equalToConstant: 80), // 放大一倍
            
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add instructions to content view
        setupInstructions()
    }
    
    private func setupInstructions() {
        let instructionsText = """
        HOW TO PLAY:
        
        1. Select a boss to battle from the boss selection screen.
        
        2. During battle, press the SPIN button to spin the slot machine.
        
        3. Getting three matching symbols will activate different effects:
           - 3 Attack Symbols: Deal damage to your opponent
           - 3 Shield Symbols: Gain a shield that blocks the next attack
           - 3 Heal Symbols: Recover some health
           - 3 Special Symbols: Deal double damage to your opponent
        
        4. After winning battles, use your earned coins to upgrade your character's stats.
        
        5. Defeat bosses to unlock more challenging opponents.
        
        6. Your game progress is automatically saved, so you can continue your adventure next time you play!
        """
        
        // 设置说明标签
        instructionsLabel.text = instructionsText
        instructionsLabel.textColor = .white
        instructionsLabel.font = UIFont.systemFont(ofSize: 18)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(instructionsLabel)
        
        // 添加约束
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            instructionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func backButtonPressed() {
        dismiss(animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
} 