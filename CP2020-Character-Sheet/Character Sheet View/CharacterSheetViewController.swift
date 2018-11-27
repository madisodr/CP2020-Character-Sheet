//
//  CharacterSheetViewController.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

final class CharacterSheetViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Cyberpunk 2020"
        collectionView.backgroundColor = StyleConstants.Color.dark
        collectionView.register(CharacterDescriptionViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.CharacterDescription.cellReuseID())
        collectionView.register(StatsViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Stats.cellReuseID())
        collectionView.register(DamageModifierViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.DamageModifier.cellReuseID())
        collectionView.register(DamageViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Damage.cellReuseID())
        collectionView.register(SkillViewCell.self,
                                forCellWithReuseIdentifier: CharacterSheetSections.Skill.cellReuseID())


    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CharacterSheetSections.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = CharacterSheetSections(rawValue: indexPath.row)?.cellReuseID() ?? "" // TODO: Error cell for not finding this.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let cell = cell as? DamageViewCell {
            let viewModel = DamageSectionViewModel(startingDamageCellNumber: 1, totalDamage: 40, woundType: .Light, typeRatio: 0.3, cellRatio: 0.3, cellHorizontalPaddingSpace: 0.2, cellVerticalPaddingSpace: 0.2, cellBorderThickness: 1.0, cellCount: 4, stunRatio: 0.4, darkColor: StyleConstants.Color.dark, lightColor: StyleConstants.Color.light)
            let totalDamageController = TotalDamageController(maxDamage: viewModel.totalDamage, delegate: cell)
            cell.setup(with: viewModel, rows: 2, damageController: totalDamageController)
        }
        else if let cell = cell as? DamageModifierViewCell {
            let viewModel = DamageModifierViewModel(stunSaveCellWidthRatio: 0.5, bodyTypeModifierCellWidthRatio: 0.5, cellHeightRatio: 1.0, stunSaveLabelHeightRatio: 0.25, bodyTypeModifierLabelHeightRatio: 0.25, leftPaddingRatio: 0.1, rightPaddingRatio: 0.1, topPaddingRatio: 0.1, bottomPaddingRatio: 0.1, inbetweenPaddingRatio: 0.1)
            cell.setup(with: viewModel)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = CharacterSheetSections(rawValue: indexPath.row)?.cellHeight() ?? 160.0
        return CGSize(width: view.frame.width, height: height)
    }

}
