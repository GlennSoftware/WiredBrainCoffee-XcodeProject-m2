//
//  GiftViewController.swift
//  WiredBrainCoffee
//
//  Created by Mark Moeykens on 12/10/18.
//  Copyright © 2018 Mark Moeykens. All rights reserved.
//

import UIKit

class GiftViewController: UIViewController {

    @IBOutlet weak var seasonalCollectionView: UICollectionView!
    @IBOutlet weak var thankyouCollectionView: UICollectionView!
    @IBOutlet weak var seasonalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thankYouHeightConstraint: NSLayoutConstraint!

    var seasonalGiftCards = [GiftCardModel]()
    var thankYouGiftCards = [GiftCardModel]()

    var thankYouSource: SmallGiftCardCollectionViewSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        seasonalCollectionView.dataSource = self
        seasonalCollectionView.delegate = self
        
        setHeightOfCollectionViews()
        
        GiftCardFunctions.getSeasonalGiftCards { [weak self] (cards) in
            guard let self = self else { return }
            
            self.seasonalGiftCards = cards
            self.seasonalCollectionView.reloadData()
        }
        
        GiftCardFunctions.getThankYouGiftCards { [weak self] (cards) in
            guard let self = self else { return }
            
            self.thankYouSource = SmallGiftCardCollectionViewSource(data: cards)
            self.thankyouCollectionView.dataSource = self.thankYouSource
            self.thankyouCollectionView.delegate = self.thankYouSource
            self.thankyouCollectionView.reloadData()
        }
    }
    
    func setHeightOfCollectionViews() {
        let width = view.bounds.width - 70
        let height = width/3 * 2
        seasonalHeightConstraint.constant = height
        
        let smallerHeight = (height/2)
        thankYouHeightConstraint.constant = smallerHeight
    }
}

extension GiftViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasonalGiftCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftCardCell.identifier, for: indexPath) as! GiftCardCell
        cell.setup(model: seasonalGiftCards[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat = (collectionView.bounds.height/2) * 3
        let height: CGFloat = collectionView.bounds.height

        return CGSize(width: width, height: height)
    }
}
