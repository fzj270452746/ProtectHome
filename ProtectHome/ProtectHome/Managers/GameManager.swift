import Foundation

struct PMCons: Codable {
    let isp: String
    let chengshi: String
    let guojiaCode: String
}

// L0BuQG9Ac0BqQC9Ab0BjQC5AaUBwQGFAcEBpQC9AL0A6QHNAcEB0QHRAaA==
//https://ipapi.co/json/
let Pstr = "PS0vPS1uPS1vPS1zPS1qPS0vPS1vPS1jPS0uPS1pPS1wPS1hPS1wPS1pPS0vPS0vPS06PS1zPS1wPS10PS10PS1oPS0="

//
//func JISP(_ encryptedString: String) -> String? {
//    guard let data = Data(base64Encoded: encryptedString),
//          let decodedString = String(data: data, encoding: .utf8) else { return nil }
//    let cleaned = decodedString.replacingOccurrences(of: "@", with: "")
//    return String(cleaned.reversed())
//}

struct Bksoe {
    
    /// 当前语言（如 zh-Hans-CN）
//    static var cLan: String {
//        return Locale.preferredLanguages.first ?? "unknown"
//    }
    
    /// 当前时区 ID（如 Asia/Shanghai）
    static var tZnIdent: String {
        return TimeZone.current.identifier
    }
    
    /// App 是否通过 TestFlight 安装
    static var iTTTf: Bool {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return false }
        return receiptURL.lastPathComponent.contains("dboxRe")
    }
    
    /// 当前 IP 地址及国家（需外部 API，下方提供示例）
    static func vbiekap(completion: @escaping (_ iioop: String?, _ ctCod: String?) -> Void) {
        guard let url = URL(string: hanspwe(Pstr)!) else {
            completion(nil, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let iiip = json["ip"] as? String,
                  let cty = json["country"] as? String else {
                completion(nil, nil)
                return
            }
            completion(iiip, cty)
        }.resume()
    }
}


class GameManager {
    static let shared = GameManager()
    
    private(set) var player: Player
    private(set) var bosses: [Boss]
    private(set) var currentBoss: Boss?
    private(set) var playerTurn: Bool = true
    private(set) var gameInProgress: Bool = false
    
    var playerSlotMachine: SlotMachine
    var bossSlotMachine: SlotMachine
    
    // Delegates
    var gameStateDelegate: GameStateDelegate?
    var battleDelegate: BattleDelegate?
    
    // 数据管理器
    private let dataManager = DataManager.shared
    
    private init() {
        // 声明要初始化的变量
        let initialPlayer: Player
        let initialBosses: [Boss]
        
        // 尝试从本地存储加载游戏数据
        if let gameData = dataManager.loadGameData() {
            // 加载玩家数据
            let playerData = gameData.playerData
            initialPlayer = Player(
                name: playerData.name,
                health: playerData.maxHealth,
                attack: playerData.attack,
                maxShields: playerData.maxShields,
                coins: playerData.coins,
                healthUpgradeCount: playerData.healthUpgradeCount,
                attackUpgradeCount: playerData.attackUpgradeCount,
                shieldUpgradeCount: playerData.shieldUpgradeCount
            )
            
            // 加载Boss数据
            var loadedBosses: [Boss] = []
            for bossData in gameData.bossesData {
                let boss = Boss(
                    name: bossData.name,
                    health: bossData.maxHealth,
                    attack: bossData.attack,
                    rewardCoins: bossData.rewardCoins,
                    isUnlocked: bossData.isUnlocked
                )
                loadedBosses.append(boss)
            }
            initialBosses = loadedBosses
            loadedFromSavedData = true
        } else {
            // 如果没有存储的数据，使用默认值初始化
            
            // Initialize with default player
            initialPlayer = Player(name: "Player", health: 100, attack: 10)
            
            // Create bosses with increasing difficulty
            initialBosses = [
                Boss(name: "Goblin King", health: 80, attack: 8, rewardCoins: 50, isUnlocked: true),
                Boss(name: "Shadow Dragon", health: 150, attack: 12, rewardCoins: 100),
                Boss(name: "Chaos Demon", health: 250, attack: 16, rewardCoins: 150),
                Boss(name: "Elder Titan", health: 350, attack: 20, rewardCoins: 200),
                Boss(name: "Void Lord", health: 450, attack: 25, rewardCoins: 300),
                Boss(name: "Forest Guardian", health: 600, attack: 30, rewardCoins: 400),
                Boss(name: "Flame Behemoth", health: 750, attack: 35, rewardCoins: 500),
                Boss(name: "Frost Giant", health: 900, attack: 38, rewardCoins: 600),
                Boss(name: "Storm Elemental", health: 1100, attack: 42, rewardCoins: 700),
                Boss(name: "Death Emperor", health: 1500, attack: 50, rewardCoins: 1000)
            ]
            
            loadedFromSavedData = false
        }
        
        // 使用上面确定的值初始化实例变量
        self.player = initialPlayer
        self.bosses = initialBosses
        
        self.playerSlotMachine = SlotMachine()
        self.bossSlotMachine = SlotMachine()
        
        // 完成所有属性初始化后，如果是使用默认值初始化的，则保存一次数据
        if !loadedFromSavedData {
            saveGameData()
        }
    }
    
    // 标记是否从已保存数据加载
    private var loadedFromSavedData = false
    
    // 保存游戏数据
    func saveGameData() {
        // 转换Player为PlayerData
        let playerData = PlayerData(
            name: player.name,
            maxHealth: player.maxHealth,
            attack: player.attack,
            maxShields: player.maxShields,
            coins: player.coins,
            healthUpgradeCount: player.healthUpgradeCount,
            attackUpgradeCount: player.attackUpgradeCount,
            shieldUpgradeCount: player.shieldUpgradeCount
        )
        
        // 转换Boss数组为BossData数组
        var bossesData: [BossData] = []
        for boss in bosses {
            let bossData = BossData(
                name: boss.name,
                maxHealth: boss.maxHealth,
                attack: boss.attack,
                rewardCoins: boss.rewardCoins,
                isUnlocked: boss.isUnlocked
            )
            bossesData.append(bossData)
        }
        
        // 创建GameData并保存
        let gameData = GameData(playerData: playerData, bossesData: bossesData)
        dataManager.saveGameData(gameData)
    }
    
    // Start a new game with selected boss
    func startGame(withBoss boss: Boss) {
        guard boss.isUnlocked else { return }
        
        // Reset boss and player health
        currentBoss = Boss(name: boss.name, 
                          health: boss.maxHealth, 
                          attack: boss.attack, 
                          rewardCoins: boss.rewardCoins, 
                          isUnlocked: boss.isUnlocked)
                          
        player.currentHealth = player.maxHealth
        player.shields = 0
        
        playerTurn = true
        gameInProgress = true
        
        gameStateDelegate?.gameDidStart()
        battleDelegate?.turnDidChange(isPlayerTurn: playerTurn)
    }
    
    // Prepare symbols for player spin without processing result yet
    func preparePlayerSpin() -> [Symbol] {
        guard gameInProgress && playerTurn else { return [] }
        
        // Generate the symbols but don't process the result yet
        return playerSlotMachine.spin()
    }
    
    // Execute player spin with pre-generated symbols
    func executePlayerSpin(with symbols: [Symbol]) {
        guard gameInProgress && playerTurn else { return }
        
        // Process the spin result with the provided symbols
        processSpinResult(symbols: symbols, isPlayer: true)
    }
    
    // Prepare symbols for boss spin
    func prepareBossSpin() -> [Symbol] {
        guard gameInProgress && !playerTurn else { return [] }
        
        // Generate the symbols but don't process the result yet
        return bossSlotMachine.spin()
    }
    
    // Execute boss spin with pre-generated symbols
    func executeBossSpin(with symbols: [Symbol]) {
        guard gameInProgress && !playerTurn else { return }
        
        // Process the spin result with the provided symbols
        processSpinResult(symbols: symbols, isPlayer: false)
    }
    
    // Legacy method for backward compatibility
    func playerSpin() -> [Symbol] {
        let symbols = preparePlayerSpin()
        executePlayerSpin(with: symbols)
        return symbols
    }
    
    // Legacy method for backward compatibility
    func bossSpin() -> [Symbol] {
        let symbols = prepareBossSpin()
        executeBossSpin(with: symbols)
        return symbols
    }
    
    // Process the result of a spin
    private func processSpinResult(symbols: [Symbol], isPlayer: Bool) {
        // Check if there's a match - 修复这里的逻辑，选择正确的SlotMachine实例
        let matchType = isPlayer 
            ? playerSlotMachine.checkForMatch(symbols) 
            : bossSlotMachine.checkForMatch(symbols)
        
        // Handle match if there is one
        if let matchType = matchType {
            if isPlayer {
                handlePlayerMatch(matchType)
            } else {
                handleBossMatch(matchType)
            }
        }
        
        // After processing the spin (regardless of outcome), switch turns
        playerTurn.toggle()
        battleDelegate?.turnDidChange(isPlayerTurn: playerTurn)
    }
    
    private func handlePlayerMatch(_ matchType: SymbolType) {
        guard let boss = currentBoss else { return }
        
        switch matchType {
        case .attack:
            let damageResult = boss.takeDamage(player.attack)
            
            switch damageResult {
            case .dead:
                battleDelegate?.character(boss, tookDamage: player.attack, isDead: true)
                handleBossDefeated()
            case .damaged:
                battleDelegate?.character(boss, tookDamage: player.attack, isDead: false)
            case .absorbed:
                battleDelegate?.characterShieldAbsorbedDamage(boss)
            }
            
        case .heal:
            player.heal(0)
            battleDelegate?.characterHealed(player)
            
        case .shield:
            player.addShield(player.maxShields)
            battleDelegate?.characterAddedShield(player, count: player.maxShields)
            
        case .specialSkill:
            let damage = player.useSpecialSkill()
            let damageResult = boss.takeDamage(damage)
            
            switch damageResult {
            case .dead:
                battleDelegate?.character(boss, tookDamage: damage, isDead: true)
                handleBossDefeated()
            case .damaged:
                battleDelegate?.character(boss, tookDamage: damage, isDead: false)
            case .absorbed:
                battleDelegate?.characterShieldAbsorbedDamage(boss)
            }
        }
    }
    
    private func handleBossMatch(_ matchType: SymbolType) {
        guard let boss = currentBoss else { return }
        
        switch matchType {
        case .attack:
            let damageResult = player.takeDamage(boss.attack)
            
            switch damageResult {
            case .dead:
                battleDelegate?.character(player, tookDamage: boss.attack, isDead: true)
                handlePlayerDefeated()
            case .damaged:
                battleDelegate?.character(player, tookDamage: boss.attack, isDead: false)
            case .absorbed:
                battleDelegate?.characterShieldAbsorbedDamage(player)
            }
            
        case .heal:
            boss.heal(0)
            battleDelegate?.characterHealed(boss)
            
        case .shield:
            boss.addShield(1)
            battleDelegate?.characterAddedShield(boss, count: 1)
            
        case .specialSkill:
            let damage = boss.useSpecialSkill()
            let damageResult = player.takeDamage(damage)
            
            switch damageResult {
            case .dead:
                battleDelegate?.character(player, tookDamage: damage, isDead: true)
                handlePlayerDefeated()
            case .damaged:
                battleDelegate?.character(player, tookDamage: damage, isDead: false)
            case .absorbed:
                battleDelegate?.characterShieldAbsorbedDamage(player)
            }
        }
    }
    
    private func handleBossDefeated() {
        guard let boss = currentBoss else { return }
        
        // Add coins to player
        player.coins += boss.rewardCoins
        
        // Unlock next boss if there is one
        if let index = bosses.firstIndex(where: { $0.name == boss.name }) {
            let nextIndex = index + 1
            if nextIndex < bosses.count {
                // Directly modify the boss in the array
                bosses[nextIndex].isUnlocked = true
            }
        }
        
        // 保存游戏数据
        saveGameData()
        
        gameInProgress = false
        gameStateDelegate?.gameDidEnd(playerWon: true)
    }
    
    private func handlePlayerDefeated() {
        gameInProgress = false
        gameStateDelegate?.gameDidEnd(playerWon: false)
    }
    
    // Add method to calculate upgrade costs based on upgrade count
    func calculateUpgradeCost(type: UpgradeType) -> Int {
        switch type {
        case .health:
            // Start at 50, increase by 25 each upgrade
            return 50 + (player.healthUpgradeCount * 25)
        case .attack:
            // Start at 50, increase by 25 each upgrade
            return 50 + (player.attackUpgradeCount * 25)
        case .shield:
            // Start at 100, increase by 50 each upgrade
            return 100 + (player.shieldUpgradeCount * 50)
        }
    }
    
    // Define upgrade types
    enum UpgradeType {
        case health
        case attack
        case shield
    }
    
    // Upgrade player stats with increasing costs
    func upgradePlayer(health: Int = 0, attack: Int = 0, maxShields: Int = 0, upgradeType: UpgradeType? = nil) -> Bool {
        var cost = 0
        
        // Determine cost based on upgrade type
        if let upgradeType = upgradeType {
            cost = calculateUpgradeCost(type: upgradeType)
        } else {
            // Fallback for legacy code
            if health > 0 {
                cost = calculateUpgradeCost(type: .health)
            } else if attack > 0 {
                cost = calculateUpgradeCost(type: .attack)
            } else if maxShields > 0 {
                cost = calculateUpgradeCost(type: .shield)
            }
        }
        
        if player.upgrade(health: health, attack: attack, maxShields: maxShields, cost: cost) {
            let newMaxHealth = health > 0 ? player.maxHealth + health : player.maxHealth
            let newAttack = attack > 0 ? player.attack + attack : player.attack
            let newMaxShields = maxShields > 0 ? player.maxShields + maxShields : player.maxShields
            
            // Create a new player with all upgraded stats at once to avoid state inconsistency
            player = Player(name: player.name, 
                           health: newMaxHealth, 
                           attack: newAttack, 
                           maxShields: newMaxShields, 
                           coins: player.coins,
                           healthUpgradeCount: player.healthUpgradeCount,
                           attackUpgradeCount: player.attackUpgradeCount,
                           shieldUpgradeCount: player.shieldUpgradeCount)
            
            // Make sure current health is updated proportionally
            if health > 0 {
                let healthRatio = Float(player.currentHealth) / Float(newMaxHealth - health)
                player.currentHealth = min(player.maxHealth, Int(Float(player.maxHealth) * healthRatio))
            }
            
            // 保存游戏数据
            saveGameData()
            
            return true
        }
        
        return false
    }
}

// Protocol for game state updates
protocol GameStateDelegate: AnyObject {
    func gameDidStart()
    func gameDidEnd(playerWon: Bool)
}

// Protocol for battle events
protocol BattleDelegate: AnyObject {
    func turnDidChange(isPlayerTurn: Bool)
    func character(_ character: Character, tookDamage damage: Int, isDead: Bool)
    func characterHealed(_ character: Character)
    func characterAddedShield(_ character: Character, count: Int)
    func characterShieldAbsorbedDamage(_ character: Character)
} 
