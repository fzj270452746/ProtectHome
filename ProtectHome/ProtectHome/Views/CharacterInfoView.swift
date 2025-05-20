import UIKit

class CharacterInfoView: UIView {
    private let nameLabel = UILabel()
    private let healthLabel = UILabel()
    private let attackLabel = UILabel()
    private let shieldsLabel = UILabel()
    private let characterImageView = UIImageView()
    
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
        
        // Setup image view
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(characterImageView)
        
        // Setup name label
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        
        // Setup health label
        healthLabel.textColor = .green
        healthLabel.font = UIFont.systemFont(ofSize: 14)
        healthLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(healthLabel)
        
        // Setup attack label
        attackLabel.textColor = .red
        attackLabel.font = UIFont.systemFont(ofSize: 14)
        attackLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(attackLabel)
        
        // Setup shields label
        shieldsLabel.textColor = .cyan
        shieldsLabel.font = UIFont.systemFont(ofSize: 14)
        shieldsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shieldsLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Character image view constraints
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 80),
            characterImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Name label constraints
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Health label constraints
            healthLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            healthLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            healthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Attack label constraints
            attackLabel.topAnchor.constraint(equalTo: healthLabel.bottomAnchor, constant: 5),
            attackLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            attackLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Shields label constraints
            shieldsLabel.topAnchor.constraint(equalTo: attackLabel.bottomAnchor, constant: 5),
            shieldsLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            shieldsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        healthLabel.text = "HP: \(character.currentHealth)/\(character.maxHealth)"
        attackLabel.text = "ATK: \(character.attack)"
        shieldsLabel.text = "Shields: \(character.shields)"
        
        if character.isPlayer {
            // 玩家使用默认图标
            characterImageView.image = UIImage(systemName: "person.fill")
            characterImageView.tintColor = .white
        } else if let boss = character as? Boss {
            // 为Boss使用monster图像
            let bossIndex = getBossIndex(for: boss.name)
            let imageName = "monster\(bossIndex)"
            
            if let monsterImage = UIImage(named: imageName) {
                characterImageView.image = monsterImage
                characterImageView.tintColor = nil // 恢复原始颜色
            } else {
                // 如果找不到图像，使用默认
                characterImageView.image = UIImage(systemName: "bolt.fill")
                characterImageView.tintColor = .white
            }
        } else {
            // 兜底逻辑
            characterImageView.image = UIImage(systemName: "bolt.fill")
            characterImageView.tintColor = .white
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