import UIKit

class SlotMachineView: UIView {
    private var reelViews: [ReelView] = []
    private let reelCount = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1.0)
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
        
        var previousReelView: ReelView?
        
        // Create reels with Auto Layout
        for i in 0..<reelCount {
            let reelView = ReelView()
            reelView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(reelView)
            reelViews.append(reelView)
            
            // Set up constraints for each reel
            if let previousReel = previousReelView {
                // For the second and third reels, position them relative to the previous reel
                NSLayoutConstraint.activate([
                    reelView.leadingAnchor.constraint(equalTo: previousReel.trailingAnchor),
                    reelView.topAnchor.constraint(equalTo: topAnchor),
                    reelView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    reelView.widthAnchor.constraint(equalTo: previousReel.widthAnchor)
                ])
            } else {
                // For the first reel, position it at the leading edge
                NSLayoutConstraint.activate([
                    reelView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    reelView.topAnchor.constraint(equalTo: topAnchor),
                    reelView.bottomAnchor.constraint(equalTo: bottomAnchor),
                    reelView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0/CGFloat(reelCount))
                ])
            }
            
            previousReelView = reelView
        }
        
        // Make sure the last reel extends to the trailing edge
        if let lastReel = reelViews.last {
            NSLayoutConstraint.activate([
                lastReel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }
    
    // Method that accepts the final symbols to display
    func spin(withFinalSymbols finalSymbols: [Symbol], completion: @escaping ([SymbolType]) -> Void) {
        var completedReels = 0
        
        // Make sure we have enough final symbols for all reels
        guard finalSymbols.count >= reelCount else {
            // Handle error case silently
            return
        }
        
        // Spin each reel with a delay
        for (i, reelView) in reelViews.enumerated() {
            let finalSymbol = finalSymbols[i].type
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                // Spin the reel with a predetermined final symbol
                reelView.spin(finalSymbol: finalSymbol) { symbol in
                    completedReels += 1
                    
                    // Call completion when all reels have stopped
                    if completedReels == self.reelCount {
                        // Extract symbol types from the final symbols
                        let symbolTypes = finalSymbols.map { $0.type }
                        completion(symbolTypes)
                    }
                }
            }
        }
    }
} 