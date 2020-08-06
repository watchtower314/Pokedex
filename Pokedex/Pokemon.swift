import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
    let sprites: PokemonDictionary //[String : URL?]
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonDictionary: Codable {
    // since we only need front_default, I get only it from the parsing
    let front_default: URL?
}

struct PokemonDescription: Codable {
    let flavor_text_entries: [PokemonDescriptionEntry]
}

struct PokemonDescriptionEntry: Codable {
    let flavor_text: String
    let language: Language
}

struct Language: Codable {
    let name: String
}



