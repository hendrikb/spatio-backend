require 'sparql/client'

module Spatio
  module SparqlTest
    extend self


    def cities
      query_string = ' SELECT DISTINCT ?name WHERE {
      ?city rdfs:label ?name.
      { ?city dcterms:subject ?category.
      ?category skos:broader <http://de.dbpedia.org/resource/Kategorie:Kreisfreie_Stadt_in_Deutschland>.
      FILTER (!(?category = <http://de.dbpedia.org/resource/Kategorie:Ehemalige_kreisfreie_Stadt_in_Deutschland>)) }
      UNION
      { ?city dcterms:subject <http://de.dbpedia.org/resource/Kategorie:Kreisfreie_Stadt_in_Deutschland>}
    }'

      query(query_string).reject { |city| city =~/Liste/ }
    end

    def states
      query_string = 'SELECT DISTINCT ?name {
      ?state rdfs:label ?name.
      ?state dcterms:subject <http://de.dbpedia.org/resource/Kategorie:Bundesland_(Deutschland)> }'

      query query_string
    end

    PREFIXES = 'PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX skos: <http://www.w3.org/2004/02/skos/core#>'

    private

    def query(query)
      sparql_client.query(query).map{ |res| res[:name].to_s }
    end

    def sparql_client
      SPARQL::Client.new('http://de.dbpedia.org/sparql')
    end
  end
end
