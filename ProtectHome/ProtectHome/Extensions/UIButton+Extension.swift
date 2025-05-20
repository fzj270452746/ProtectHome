import UIKit
import ObjectiveC

extension UIButton {
    
    /// 配置按钮使用背景图片，保持原始比例并适当调整大小
    func applyBackgroundImage(named imageName: String, cornerRadius: CGFloat = 10) {
        // 保存图片名称和圆角值，用于后续更新
        self.backgroundImageName = imageName
        self.backgroundCornerRadius = cornerRadius
        
        // 立即应用默认图片
        if let buttonImage = UIImage(named: imageName) {
            self.setBackgroundImage(buttonImage, for: .normal)
        } else {
            // 回退到默认颜色
            self.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        }
        
        // 设置圆角
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        // 添加布局更新监听
        self.addTarget(self, action: #selector(updateBackgroundImageForSize), for: .allTouchEvents)
        
        // 保证在布局后更新图片
        DispatchQueue.main.async {
            self.updateBackgroundImageForSize()
        }
    }
    
    // 用于储存背景图片名称的关联对象Key
    private struct AssociatedKeys {
        static var backgroundImageName = "backgroundImageName"
        static var backgroundCornerRadius = "backgroundCornerRadius"
    }
    
    // 背景图片名称
    private var backgroundImageName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.backgroundImageName) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundImageName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 背景圆角半径
    private var backgroundCornerRadius: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.backgroundCornerRadius) as? CGFloat ?? 10
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundCornerRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 根据当前尺寸更新背景图片
    @objc private func updateBackgroundImageForSize() {
        // 检查尺寸是否有效
        guard bounds.width > 0, bounds.height > 0, let imageName = backgroundImageName, let buttonImage = UIImage(named: imageName) else {
            return
        }
        
        // 合适的尺寸设置
        let buttonSize = CGSize(width: max(bounds.width, 30), height: max(bounds.height, 30))
        let buttonWidth = buttonSize.width
        let buttonHeight = buttonSize.height
        
        // 创建适合按钮大小的新图片
        UIGraphicsBeginImageContextWithOptions(buttonSize, false, 0)
        
        // 计算绘制的位置和大小，保持纵横比
        let aspectRatio = buttonImage.size.width / buttonImage.size.height
        var drawWidth = buttonWidth
        var drawHeight = buttonHeight
        
        // 确保图片不被过度拉伸
        if buttonWidth / buttonHeight > aspectRatio {
            // 按钮比图片更宽，限制宽度
            drawWidth = buttonHeight * aspectRatio
        } else {
            // 按钮比图片更高，限制高度
            drawHeight = buttonWidth / aspectRatio
        }
        
        // 确保图片足够大，不会出现边缘问题
        let scale = 1.1 // 略微放大
        drawWidth *= scale
        drawHeight *= scale
        
        // 居中绘制
        let x = (buttonWidth - drawWidth) / 2
        let y = (buttonHeight - drawHeight) / 2
        
        buttonImage.draw(in: CGRect(x: x, y: y, width: drawWidth, height: drawHeight))
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            self.setBackgroundImage(newImage, for: .normal)
        } else {
            UIGraphicsEndImageContext()
        }
        
        // 确保圆角设置正确
        self.layer.cornerRadius = backgroundCornerRadius
    }
} 