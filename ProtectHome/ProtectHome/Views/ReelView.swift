import UIKit

class ReelView: UIView {
    private let symbolImageView = UIImageView()
    var currentSymbol: SymbolType = .attack
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Add a border for each reel
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        // Setup symbol image view
        symbolImageView.contentMode = .scaleAspectFit
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(symbolImageView)
        
        // Use system images as placeholders for now
        updateSymbolImage()
        
        // Center the symbol image precisely in the reel
        NSLayoutConstraint.activate([
            symbolImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            symbolImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            // Use a fixed size rather than a multiplier to ensure consistency
            symbolImageView.widthAnchor.constraint(equalToConstant: 100),
            symbolImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func updateSymbolImage() {
        // 使用自定义图像资源代替系统图标
        if let customImage = currentSymbol.image {
            symbolImageView.image = customImage
            // 使用原始图像颜色，不需要额外的tint
            symbolImageView.tintColor = nil
        } else {
            // 只有在找不到自定义图像时才回退到系统图标
            let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
            
            switch currentSymbol {
            case .attack:
                symbolImageView.image = UIImage(systemName: "bolt.fill", withConfiguration: configuration)
                symbolImageView.tintColor = .red
            case .heal:
                symbolImageView.image = UIImage(systemName: "heart.fill", withConfiguration: configuration)
                symbolImageView.tintColor = .green
            case .shield:
                symbolImageView.image = UIImage(systemName: "shield.fill", withConfiguration: configuration)
                symbolImageView.tintColor = .cyan
            case .specialSkill:
                symbolImageView.image = UIImage(systemName: "star.fill", withConfiguration: configuration)
                symbolImageView.tintColor = .yellow
            }
        }
    }
    
    // Modified to accept a predetermined final symbol
    func spin(finalSymbol: SymbolType, completion: @escaping (SymbolType) -> Void) {
        // Number of animation iterations
        let iterations = 10
        var currentIteration = 0
        
        // Timer for animations
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if currentIteration < iterations - 1 {
                // Show random symbols during animation
                let randomSymbol = SymbolType.allCases.randomElement() ?? .attack
                self.currentSymbol = randomSymbol
                self.updateSymbolImage()
            } else {
                // On the final iteration, show the predetermined symbol
                self.currentSymbol = finalSymbol
                self.updateSymbolImage()
            }
            
            currentIteration += 1
            
            // Stop after iterations
            if currentIteration >= iterations {
                timer.invalidate()
                completion(finalSymbol)
            }
        }
    }
} 