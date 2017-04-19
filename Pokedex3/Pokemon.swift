//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Márton Nagy on 2017. 04. 18..
//  Copyright © 2017. Marton Nagy. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _evoBarTxt: String!
    private var _evoName: String!
    private var _evoId: String!
    private var _evoLevel: String!
    private var _pokemonURL: String!
    private var _description: String!
    
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    var descriptionText: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var baseAttack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var evoBarTxt: String {
        if _evoBarTxt == nil {
            _evoBarTxt = ""
        }
        return _evoBarTxt
    }
    var pokemonURL: String {
        if _pokemonURL == nil {
            _pokemonURL = ""
        }
        return _pokemonURL
    }
    var evoName: String {
        if _evoName == nil {
            _evoName = ""
        }
        return _evoName
    }
    var evoId: String {
        if _evoId == nil {
            _evoId = ""
        }
        return _evoId
    }
    var evoLevel: String {
        if _evoLevel == nil {
            _evoLevel = ""
        }
        return _evoLevel
    }
        
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    // lazy loading (only loading once the collectionViewCell is clicked)
    // !!! - network calls are asynchronous -> we dont know when these get completed -> cant set lables, cause would crash -> we make a closure to let the viewController know when the data gonna be available. it runs, when completed.
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = String(attack)
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = String(defense)
                }
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0{
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    if types.count > 1 {
                        for i in 1..<types.count {
                            if let name = types[i]["name"] {
                                self._type = self._type + "/ " + name.capitalized
                            }
                        }
                    }
                } else {
                    self._type = "n/a"
                }
                if let resourceURLArray = dict["descriptions"] as? [Dictionary<String, AnyObject>] {
                    if let resourceURLPart = resourceURLArray[0]["resource_uri"] as? String{
                        let resourceURL = "\(URL_BASE)\(resourceURLPart)"
                        Alamofire.request(resourceURL).responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                            }
                            completed()
                        })
                    }
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolutions.count>0 {
                    
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        
                        if nextEvolution.range(of: "mega") == nil {
                            
                            self._evoName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let evoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._evoId = evoId
                                
                                if let lvlExists = evolutions[0]["level"]{
                                    if let lvl = lvlExists as? Int {
                                        self._evoLevel = "\(lvl)"
                                    }
                                } else {
                                    self._evoLevel = ""
                                }
                            }
                        }
                    }
                }
            }
            completed()
            
        }
    }
}
