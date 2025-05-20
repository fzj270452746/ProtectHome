import UIKit

// MARK: - GameStateDelegate
extension BattleViewController: GameStateDelegate {
    func gameDidStart() {
        turnLabel.text = "PLAYER TURN"
        spinButton.isEnabled = true
    }
    
    func gameDidEnd(playerWon: Bool) {
        // Show game result notification
        if playerWon {
            showNotification("Victory! You earned \(boss.rewardCoins) coins!", duration: 3.0)
        } else {
            showNotification("Defeat! Better luck next time!", duration: 3.0)
        }
        
        // Disable spin button
        spinButton.isEnabled = false
        
        // Exit battle after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

// MARK: - BattleDelegate
extension BattleViewController: BattleDelegate {
    func turnDidChange(isPlayerTurn: Bool) {
        // Update turn label
        turnLabel.text = isPlayerTurn ? "PLAYER TURN" : "BOSS TURN"
        
        // Enable/disable spin button based on turn
        spinButton.isEnabled = isPlayerTurn && gameManager.gameInProgress
        
        // Update UI
        updateCharacterInfoViews()
        
        // If it's boss's turn, show animation for the boss's slot machine
        if !isPlayerTurn && gameManager.gameInProgress {
            handleBossTurn()
        }
    }
    
    private func handleBossTurn() {
        // Disable any UI interactions while boss is thinking/spinning
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self, self.gameManager.gameInProgress && !self.gameManager.playerTurn else { 
                self?.view.isUserInteractionEnabled = true
                return 
            }
            
            // 先获取Boss的符号结果
            let bossSymbols = self.gameManager.prepareBossSpin()
            
            // 使用预定的符号进行动画
            self.bossSlotView.spin(withFinalSymbols: bossSymbols) { [weak self] _ in
                guard let self = self else { return }
                
                // 执行实际的游戏逻辑
                self.gameManager.executeBossSpin(with: bossSymbols)
                
                // Re-enable UI interactions
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func character(_ character: Character, tookDamage damage: Int, isDead: Bool) {
        // Update character info views
        updateCharacterInfoViews()
        
        // Show notification
        if character.isPlayer {
            showNotification("Player took \(damage) damage!")
            // Show damage effect at player position
            let effectPoint = CGPoint(x: playerInfoView.center.x, y: playerInfoView.center.y)
            showDamageEffect(at: effectPoint)
        } else {
            showNotification("Boss took \(damage) damage!")
            // Show damage effect at boss position
            let effectPoint = CGPoint(x: bossInfoView.center.x, y: bossInfoView.center.y)
            showDamageEffect(at: effectPoint)
        }
    }
    
    func characterHealed(_ character: Character) {
        // Update character info views
        updateCharacterInfoViews()
        
        // Show notification
        if character.isPlayer {
            showNotification("Player healed!")
            // Show heal effect at player position
            let effectPoint = CGPoint(x: playerInfoView.center.x, y: playerInfoView.center.y)
            showHealEffect(at: effectPoint)
        } else {
            showNotification("Boss healed!")
            // Show heal effect at boss position
            let effectPoint = CGPoint(x: bossInfoView.center.x, y: bossInfoView.center.y)
            showHealEffect(at: effectPoint)
        }
    }
    
    func characterAddedShield(_ character: Character, count: Int) {
        // Update character info views
        updateCharacterInfoViews()
        
        // Show notification
        if character.isPlayer {
            showNotification("Player gained \(count) shield(s)!")
            // Show shield effect around player info
            showShieldEffect(around: playerInfoView)
        } else {
            showNotification("Boss gained \(count) shield(s)!")
            // Show shield effect around boss info
            showShieldEffect(around: bossInfoView)
        }
    }
    
    func characterShieldAbsorbedDamage(_ character: Character) {
        // Update character info views
        updateCharacterInfoViews()
        
        // Show notification with shield block effect
        if character.isPlayer {
            showNotification("⚔️ Player's shield blocked the attack! ⚔️", duration: 2.5)
            // Show shield effect with greater intensity for blocking
            showShieldEffect(around: playerInfoView)
        } else {
            showNotification("⚔️ Boss's shield blocked the attack! ⚔️", duration: 2.5)
            // Show shield effect with greater intensity for blocking
            showShieldEffect(around: bossInfoView)
        }
    }
} 