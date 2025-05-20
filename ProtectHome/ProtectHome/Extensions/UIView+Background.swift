import UIKit
import ObjectiveC

extension UIView {
    /// Key for associated object to check if background is already added
    private static var backgroundAddedKey = "backgroundAddedKey"
    
    /// 为视图添加游戏背景图片和半透明遮罩层
    func addGameBackground(overlayColor: UIColor = UIColor(white: 0, alpha: 0.6)) {
        // Check if background is already added to avoid duplicates
//        if let backgroundAdded = objc_getAssociatedObject(self, &UIView.backgroundAddedKey) as? Bool, backgroundAdded {
//            return // Background already added, skip
//        }
        
        // 创建背景图片视图
        let backgroundImageView = UIImageView(image: UIImage(named: "game_back"))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImageView)
        // 插入到最底层
//        self.insertSubview(backgroundImageView, at: 0)
        
        // 创建半透明遮罩层
        let overlayView = UIView()
        overlayView.backgroundColor = overlayColor
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        // 将遮罩层添加到背景图上方
//        self.insertSubview(overlayView, at: 1)
        self.addSubview(overlayView)
        
        // 添加约束使背景图和遮罩层填满整个视图
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            overlayView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: self.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        // Mark background as added to this view
//        objc_setAssociatedObject(self, &UIView.backgroundAddedKey, true, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
} 
