# encoding : utf-8 -*-

module Spatio
  module Parser
    class Streets
      STREET_SIGNIFIER = ["stra(ss|ß)e",
                          "str",
                          "weg",
                          "platz",
                          "damm",
                          "ufer",
                          "steg",
                          "allee",
                          "chaussee",
                          "markt",
                          "ring",
                          "brücke",
                          "tor",
                          "promenade",
                          "park"]

      FIX_STREETS = [
        "Unter den Linden", "Adlergestell", "Südstern", "Grosser Stern"
      ]

      STREET_PREFIXES = [
        "Kleine[s|r]?", "Gro(ß|ss)e[r|s]?", "St\.", "Sankt", "Alte[r|s]?", "Neue[s|r]?", "Am", "Beim", "Unterm", "Hinter de[m|r]", "An de[r|m|n]"
      ]

      # Awesome Regex: http://rubular.com/r/yoF4rOeKJy
      def self.perform(string)
        street_signifier_lowercase = STREET_SIGNIFIER.join '|'
        street_signifier_capitalized = STREET_SIGNIFIER.map(&:capitalize).join '|'
        street_prefixes = STREET_PREFIXES.join '|'
        monster_regexp = /(((Alt-)\p{Lu}\p{L}+\b|(#{FIX_STREETS.join('|')}))|(((#{street_prefixes}) )?((#{street_signifier_capitalized}) de[r|s] (([0-9]+\. )?\p{Lu}\p{L}+ ?)+|\p{Lu}[\p{L}-]+(#{street_signifier_lowercase})|(\p{L}+-)+(#{street_signifier_capitalized})|\p{Lu}\p{L}+ (#{street_signifier_capitalized}))\b))/

        matches = string.scan monster_regexp
        return [] if matches.nil?
        matches.uniq.map(&:first).reject{ |m| m =~ /Gehweg|Richtung|(Vor|Park)platz|Elektronikmarkt/ }
      end
    end
  end
end
