import UIKit

// MARK: - Visual Effects
extension BattleViewController {
    
    // Create a damage effect at the specified location
    func showDamageEffect(at point: CGPoint) {
        // Create particles
        for _ in 0..<20 {
            let particle = createParticle(color: .red, size: CGSize(width: 8, height: 8))
            particle.center = point
            view.addSubview(particle)
            
            // Animate particle
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                // Random direction
                let randomX = CGFloat.random(in: -50...50)
                let randomY = CGFloat.random(in: -50...50)
                particle.center = CGPoint(x: point.x + randomX, y: point.y + randomY)
                particle.alpha = 0
                particle.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { _ in
                particle.removeFromSuperview()
            })
        }
    }
    
    // Create a healing effect at the specified location
    func showHealEffect(at point: CGPoint) {
        // Create particles
        for _ in 0..<15 {
            let particle = createParticle(color: .green, size: CGSize(width: 10, height: 10))
            particle.center = CGPoint(x: point.x, y: point.y + 50) // Start below the point
            view.addSubview(particle)
            
            // Animate particle
            UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseOut], animations: {
                // Move upward with slight random horizontal movement
                let randomX = CGFloat.random(in: -20...20)
                particle.center = CGPoint(x: point.x + randomX, y: point.y - 30)
                particle.alpha = 0
            }, completion: { _ in
                particle.removeFromSuperview()
            })
        }
    }
    
    // Create a shield effect around the specified view
    func showShieldEffect(around targetView: UIView) {
        let shieldLayer = CAShapeLayer()
        let path = UIBezierPath(ovalIn: targetView.bounds.insetBy(dx: -10, dy: -10))
        shieldLayer.path = path.cgPath
        shieldLayer.strokeColor = UIColor.cyan.cgColor
        shieldLayer.fillColor = UIColor.clear.cgColor
        shieldLayer.lineWidth = 3
        shieldLayer.opacity = 0.8
        
        targetView.layer.addSublayer(shieldLayer)
        
        // Animation
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0.8
        animation.toValue = 0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            shieldLayer.removeFromSuperlayer()
        }
        shieldLayer.add(animation, forKey: "opacityAnimation")
        CATransaction.commit()
    }
    
    // Helper to create a particle view
    private func createParticle(color: UIColor, size: CGSize) -> UIView {
        let particle = UIView(frame: CGRect(origin: .zero, size: size))
        particle.backgroundColor = color
        particle.layer.cornerRadius = min(size.width, size.height) / 2
        return particle
    }
} 