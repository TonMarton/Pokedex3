//
//  PokemonDetailVC.swift
//  Pokedex3
//
//  Created by Márton Nagy on 2017. 04. 19..
//  Copyright © 2017. Marton Nagy. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!

    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var PokedexIdLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!

    @IBOutlet weak var evoBarLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var evoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = pokemon.name
        
        let image = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = image
        currentEvoImg.image = image
        PokedexIdLbl.text = String(pokemon.pokedexId)

        
        pokemon.downloadPokemonDetail {
            // the code here only gets executed once the network call is completed
            self.updateUI()
        }

    }
    func updateUI() {
        label.text = pokemon.name.capitalized
        descriptionLbl.text = pokemon.descriptionText
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        baseAttackLbl.text = pokemon.baseAttack
        evoBarLbl.text = pokemon.evoBarTxt
        
        if pokemon.evoId == "" {
            evoBarLbl.text = "No Evolutions"
            evoImg.isHidden = true
        } else {
            evoImg.isHidden = false
            evoImg.image = UIImage(named: pokemon.evoId)
            let str = "Next Evolution: \(pokemon.evoName) - LVL \(pokemon.evoLevel)"
            evoBarLbl.text = str
        }
        
        
    }
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
