import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    var descriptionUrl = "https://pokeapi.co/api/v2/pokemon-species/"

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var pokemonDescription: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var Catch: UIButton!
    @IBOutlet var image: UIImageView!
    var isCaught: Bool!

    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        pokemonDescription.text = "Loading..."
        loadPokemon()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                let rawUrl = result.sprites.front_default
                guard let tmp = rawUrl else
                {
                    return
                }
                
                /// fetching description
                self.descriptionUrl += String(result.id)
                URLSession.shared.dataTask(with: URL(string: self.descriptionUrl)!)
                {
                    (data, response, error) in guard let descData = data else
                    {
                        return
                    }
                    do
                    {
                        let descResult = try JSONDecoder().decode(PokemonDescription.self, from: descData)
                        for entry in descResult.flavor_text_entries
                        {
                            if entry.language.name == "en"
                            {
                                DispatchQueue.main.async {
                                    self.pokemonDescription.text = entry.flavor_text
                                }
                                break
                            }
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }.resume()
                        
                let url = try URL(resolvingAliasFileAt: tmp)
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = self.capitalize(text: typeEntry.type.name)
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = self.capitalize(text: typeEntry.type.name)
                        }
                    }
                    self.isCaught = UserDefaults.standard.bool(forKey: self.nameLabel.text!) || false
                    self.changeButtonTitle()
                    self.image.image = UIImage(data: data)
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    @IBAction func toggleCatch() {
        self.isCaught = !self.isCaught
        UserDefaults.standard.set(self.isCaught, forKey: self.nameLabel.text!)
        self.changeButtonTitle()
    }

    func changeButtonTitle()
    {
        if self.isCaught
        {
            self.Catch.setTitle("Release", for: .normal)
        }
        else
        {
            self.Catch.setTitle("Catch", for: .normal)
        }
    }
}
