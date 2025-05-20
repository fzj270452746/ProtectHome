import Foundation

// 需要存储的游戏数据结构
struct GameData: Codable {
    var playerData: PlayerData
    var bossesData: [BossData]
}

// 玩家数据结构
struct PlayerData: Codable {
    var name: String
    var maxHealth: Int
    var attack: Int
    var maxShields: Int
    var coins: Int
    var healthUpgradeCount: Int = 0
    var attackUpgradeCount: Int = 0
    var shieldUpgradeCount: Int = 0
}

// Boss数据结构
struct BossData: Codable {
    var name: String
    var maxHealth: Int
    var attack: Int
    var rewardCoins: Int
    var isUnlocked: Bool
}

class DataManager {
    static let shared = DataManager()
    
    private let fileManager = FileManager.default
    private let documentsUrl: URL
    
    private init() {
        documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // 数据文件URL
    private var gameDataUrl: URL {
        return documentsUrl.appendingPathComponent("gameData.json")
    }
    
    // 保存游戏数据
    func saveGameData(_ data: GameData) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: gameDataUrl)
        } catch {
            // Error handling could be improved in a production app
        }
    }
    
    // 读取游戏数据
    func loadGameData() -> GameData? {
        guard fileManager.fileExists(atPath: gameDataUrl.path) else {
            return nil
        }
        
        do {
            let jsonData = try Data(contentsOf: gameDataUrl)
            let decoder = JSONDecoder()
            let gameData = try decoder.decode(GameData.self, from: jsonData)
            return gameData
        } catch {
            // Error handling could be improved in a production app
            return nil
        }
    }
    
    // 删除游戏数据（重置游戏）
    func deleteGameData() {
        guard fileManager.fileExists(atPath: gameDataUrl.path) else { return }
        
        do {
            try fileManager.removeItem(at: gameDataUrl)
        } catch {
            // Error handling could be improved in a production app
        }
    }
} 