import UIKit

// MARK: - Symbol Types
//enum SymbolType: CaseIterable {
//    case attack
//    case heal
//    case shield
//    case specialSkill
//    
//    var image: UIImage? {
//        switch self {
//        case .attack:
//            return UIImage(named: "symbol_attack")
//        case .heal:
//            return UIImage(named: "symbol_heal")
//        case .shield:
//            return UIImage(named: "symbol_shield")
//        case .specialSkill:
//            return UIImage(named: "symbol_special")
//        }
//    }
//}
//
//// MARK: - Symbol Representation
//struct Symbol {
//    let type: SymbolType
//    
//    init(type: SymbolType) {
//        self.type = type
//    }
//    
//    // Convenience initializer for creating a random symbol
//    static func random() -> Symbol {
//        let randomType = SymbolType.allCases.randomElement() ?? .attack
//        return Symbol(type: randomType)
//    }
//} 
