import UIKit

class BossSelectionViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private var bossCollectionView: UICollectionView!
    private let gameManager = GameManager.shared
    private var bosses: [Boss] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 每次界面出现时都刷新boss数据
        bosses = gameManager.bosses
        bossCollectionView.reloadData()
    }
    
    private func setupUI() {
        // 添加游戏背景
        view.addGameBackground()
        
        // Setup title label
        titleLabel.text = "SELECT BOSS"
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
        
        // Setup collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 280)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        bossCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bossCollectionView.backgroundColor = .clear
        bossCollectionView.delegate = self
        bossCollectionView.dataSource = self
        bossCollectionView.showsHorizontalScrollIndicator = false
        bossCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bossCollectionView.register(BossCollectionViewCell.self, forCellWithReuseIdentifier: "BossCell")
        view.addSubview(bossCollectionView)
        
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
            
            // Collection view constraints
            bossCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            bossCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bossCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bossCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func backButtonPressed() {
        // Use completion handler to ensure proper cleanup after dismissal
        dismiss(animated: true) { [weak self] in
            // Cleanup if needed after dismissal
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BossSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bosses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BossCell", for: indexPath) as! BossCollectionViewCell
        let boss = bosses[indexPath.item]
        cell.configure(with: boss)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let boss = bosses[indexPath.item]
        
        if boss.isUnlocked {
            let battleVC = BattleViewController(boss: boss)
            battleVC.modalPresentationStyle = .fullScreen
            present(battleVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Boss Locked", 
                                         message: "You need to defeat the previous boss to unlock this one.", 
                                         preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

// MARK: - Boss Collection View Cell
class BossCollectionViewCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let healthLabel = UILabel()
    private let attackLabel = UILabel()
    private let imageView = UIImageView()
    private let lockImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        
        // Setup image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // Setup lock image view
        lockImageView.image = UIImage(systemName: "lock.fill")
        lockImageView.tintColor = .white
        lockImageView.contentMode = .scaleAspectFit
        lockImageView.translatesAutoresizingMaskIntoConstraints = false
        lockImageView.isHidden = true
        contentView.addSubview(lockImageView)
        
        // Setup name label
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        // Setup health label
        healthLabel.textColor = .white
        healthLabel.font = UIFont.systemFont(ofSize: 16)
        healthLabel.textAlignment = .center
        healthLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(healthLabel)
        
        // Setup attack label
        attackLabel.textColor = .white
        attackLabel.font = UIFont.systemFont(ofSize: 16)
        attackLabel.textAlignment = .center
        attackLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(attackLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Image view constraints
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Lock image view constraints
            lockImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lockImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lockImageView.widthAnchor.constraint(equalToConstant: 60),
            lockImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Health label constraints
            healthLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            healthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            healthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Attack label constraints
            attackLabel.topAnchor.constraint(equalTo: healthLabel.bottomAnchor, constant: 10),
            attackLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            attackLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func configure(with boss: Boss) {
        nameLabel.text = boss.name
        healthLabel.text = "Health: \(boss.maxHealth)"
        attackLabel.text = "Attack: \(boss.attack)"
        
        // 根据boss名称或索引分配对应的monster图像
        let bossIndex = getBossIndex(for: boss.name)
        let imageName = "monster\(bossIndex)"
        
        // 使用新的monster图像
        if let monsterImage = UIImage(named: imageName) {
            imageView.image = monsterImage
        } else {
            // 如果找不到特定图像，使用默认图标
            imageView.image = UIImage(systemName: "person.fill")
            imageView.tintColor = .white
        }
        
        if boss.isUnlocked {
            contentView.layer.borderColor = UIColor.white.cgColor
            contentView.alpha = 1.0
            lockImageView.isHidden = true
        } else {
            contentView.layer.borderColor = UIColor.darkGray.cgColor
            contentView.alpha = 0.5
            lockImageView.isHidden = false
        }
    }
    
    // 根据boss名称获取索引
private func getBossIndex(for bossName: String) -> Int {
    // 预设boss名称的索引映射
    let bossNameToIndex: [String: Int] = [
        "Goblin King": 1,
        "Shadow Dragon": 2,
        "Chaos Demon": 3,
        "Elder Titan": 4,
        "Void Lord": 5,
        "Forest Guardian": 6,
        "Flame Behemoth": 7,
        "Frost Giant": 8,
        "Storm Elemental": 9,
        "Death Emperor": 10
    ]
        
        // 如果找到映射，返回对应索引；否则从名称中提取数字或返回默认值
        if let index = bossNameToIndex[bossName] {
            return index
        }
        
        // 尝试从名称中提取数字
        if let match = bossName.range(of: #"\d+"#, options: .regularExpression),
           let number = Int(bossName[match]) {
            return min(number, 10) // 最大不超过10
        }
        
        // 如果都不符合，返回随机索引(1-10)
        return Int.random(in: 1...10)
    }
} 