import UIKit

extension UIButton {
    // Set background image
    func applyBackgroundImage(named imageName: String) {
        if let image = UIImage(named: imageName) {
            setBackgroundImage(image, for: .normal)
            // Set a slightly darker version for highlighted state
            let darkImage = image.withAlpha(0.8)
            setBackgroundImage(darkImage, for: .highlighted)
        }
    }
    
    // Add button press animation
    func addPressAnimation(withSound: Bool = false) {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    @objc private func animateUp(sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction], animations: {
            sender.transform = .identity
        }, completion: nil)
    }
    
    // Add popup animation for button appearance
    func popupAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.transform = .identity
            self.alpha = 1
        }, completion: nil)
    }
} 