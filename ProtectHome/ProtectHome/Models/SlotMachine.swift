import Foundation
import UIKit

enum SymbolType: CaseIterable {
    case attack
    case heal
    case shield
    case specialSkill
    
    var image: UIImage? {
        switch self {
        case .attack:
            return UIImage(named: "symbol_attack")
        case .heal:
            return UIImage(named: "symbol_heal")
        case .shield:
            return UIImage(named: "symbol_shield")
        case .specialSkill:
            return UIImage(named: "symbol_special")
        }
    }
    
    var description: String {
        switch self {
        case .attack:
            return "Attack"
        case .heal:
            return "Heal"
        case .shield:
            return "Shield"
        case .specialSkill:
            return "Special Skill"
        }
    }
}

class Symbol {
    let type: SymbolType
    
    init(type: SymbolType) {
        self.type = type
    }
}

class Reel {
    private var symbols: [Symbol]
    var currentSymbol: Symbol
    
    init() {
        // Create symbols for all types
        self.symbols = SymbolType.allCases.map { Symbol(type: $0) }
        self.currentSymbol = self.symbols[0]
    }
    
    func spin() -> Symbol {
        let randomIndex = Int.random(in: 0..<symbols.count)
        currentSymbol = symbols[randomIndex]
        return currentSymbol
    }
}

class SlotMachine {
    private let reels: [Reel]
    private let reelCount = 3
    
    init() {
        var reels = [Reel]()
        for _ in 0..<reelCount {
            reels.append(Reel())
        }
        self.reels = reels
    }
    
    func spin() -> [Symbol] {
        // Select a random symbol type that will be used for all reels
        let randomSymbolType = SymbolType.allCases.randomElement()!
        
        // Create matching symbols for all reels
        var matchingSymbols = [Symbol]()
        
        for _ in 0..<reelCount {
            let symbol = Symbol(type: randomSymbolType)
            matchingSymbols.append(symbol)
        }
        
        // Update each reel's current symbol for consistency
        for i in 0..<reels.count {
            reels[i].currentSymbol = matchingSymbols[i]
        }
        
        return matchingSymbols
    }
    
    func checkForMatch(_ symbols: [Symbol]) -> SymbolType? {
        guard !symbols.isEmpty else { return nil }
        
        let firstType = symbols[0].type
        let allMatch = symbols.allSatisfy { $0.type == firstType }
        
        return allMatch ? firstType : nil
    }
} 