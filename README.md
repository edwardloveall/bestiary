# Bestiary

The aim of Bestiary is to parse all creatures in the [Pathfinder Bestiary](http://paizo.com/pathfinderRPG/prd/indices/bestiary.html) and store them in a relational database.

The basic strategy is to take each html file, [extract each creature](https://github.com/edwardloveall/bestiary/blob/master/lib/bestiary/parsers/creature.rb), then [extract each attribute](https://github.com/edwardloveall/bestiary/tree/master/lib/bestiary/parsers). Eventually, the parsed data will be stored in a SQL database for easy searching, filtering, sorting, or other means of extracting the right creatures for an RPG campaign.

## License

Licensed under the [Open Game License](https://github.com/edwardloveall/bestiary/blob/master/LICENSE).
