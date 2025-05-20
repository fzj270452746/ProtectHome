import Foundation

// 定义伤害结果枚举
enum DamageResult {
    case dead       // 致命伤害，角色死亡
    case damaged    // 受到伤害，但未死亡
    case absorbed   // 伤害被盾牌吸收
}

protocol Character {
    var name: String { get }
    var maxHealth: Int { get }
    var currentHealth: Int { get set }
    var attack: Int { get }
    var shields: Int { get set }
    var isPlayer: Bool { get }
    
    mutating func takeDamage(_ damage: Int) -> DamageResult
    mutating func heal(_ amount: Int)
    mutating func addShield(_ count: Int)
    func useSpecialSkill() -> Int
}

class Player: Character {
    let name: String
    let maxHealth: Int
    var currentHealth: Int
    let attack: Int
    var shields: Int
    let isPlayer = true
    var maxShields: Int
    var coins: Int
    
    // Add upgrade counters
    var healthUpgradeCount: Int = 0
    var attackUpgradeCount: Int = 0
    var shieldUpgradeCount: Int = 0
    
    init(name: String, health: Int, attack: Int, maxShields: Int = 1, coins: Int = 0, healthUpgradeCount: Int = 0, attackUpgradeCount: Int = 0, shieldUpgradeCount: Int = 0) {
        self.name = name
        self.maxHealth = health
        self.currentHealth = health
        self.attack = attack
        self.shields = 0
        self.maxShields = maxShields
        self.coins = coins
        self.healthUpgradeCount = healthUpgradeCount
        self.attackUpgradeCount = attackUpgradeCount
        self.shieldUpgradeCount = shieldUpgradeCount
    }
    
    func takeDamage(_ damage: Int) -> DamageResult {
        if shields > 0 {
            shields -= 1
            return .absorbed
        } else {
            let oldHealth = currentHealth
            currentHealth -= damage
            if currentHealth < 0 {
                currentHealth = 0
            }
            
            if currentHealth <= 0 {
                return .dead
            } else {
                return .damaged
            }
        }
    }
    
    func heal(_ amount: Int) {
        let healAmount = Int(Float(maxHealth) * 0.05)
        currentHealth += healAmount
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
    }
    
    func addShield(_ count: Int) {
        let shieldsToAdd = min(count, maxShields)
        shields += shieldsToAdd
    }
    
    func useSpecialSkill() -> Int {
        return attack * 2
    }
    
    func upgrade(health: Int = 0, attack: Int = 0, maxShields: Int = 0, cost: Int) -> Bool {
        if coins >= cost {
            coins -= cost
            
            // Increment counters based on what was upgraded
            if health > 0 { healthUpgradeCount += 1 }
            if attack > 0 { attackUpgradeCount += 1 }
            if maxShields > 0 { shieldUpgradeCount += 1 }
            
            return true
        }
        return false
    }
}

class Boss: Character {
    let name: String
    let maxHealth: Int
    var currentHealth: Int
    let attack: Int
    var shields: Int
    let isPlayer = false
    let rewardCoins: Int
    var isUnlocked: Bool
    
    init(name: String, health: Int, attack: Int, rewardCoins: Int, isUnlocked: Bool = false) {
        self.name = name
        self.maxHealth = health
        self.currentHealth = health
        self.attack = attack
        self.shields = 0
        self.rewardCoins = rewardCoins
        self.isUnlocked = isUnlocked
    }
    
    func takeDamage(_ damage: Int) -> DamageResult {
        if shields > 0 {
            shields -= 1
            return .absorbed
        } else {
            let oldHealth = currentHealth
            currentHealth -= damage
            if currentHealth < 0 {
                currentHealth = 0
            }
            
            if currentHealth <= 0 {
                return .dead
            } else {
                return .damaged
            }
        }
    }
    
    func heal(_ amount: Int) {
        let healAmount = Int(Float(maxHealth) * 0.05)
        currentHealth += healAmount
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
    }
    
    func addShield(_ count: Int) {
        shields += 1
    }
    
    func useSpecialSkill() -> Int {
        return attack * 2
    }
} 