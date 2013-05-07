require 'sparql/client'

module Spatio
  module SparqlTest
    extend self

    def cities
      query = '
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

      SELECT DISTINCT ?name {
      ?city dcterms:subject ?category.
      ?city rdfs:label ?name.
      ?category skos:broader <http://de.dbpedia.org/resource/Kategorie:Kreisfreie_Stadt_in_Deutschland>.
      FILTER (!(?category = <http://de.dbpedia.org/resource/Kategorie:Ehemalige_kreisfreie_Stadt_in_Deutschland>) )
      }'

      sparql_client.query(query).map{ |res| res[:name].to_s }
    end

    def states
      query = '
      PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX dbprop: <http://de.dbpedia.org/property/>

      SELECT DISTINCT ?name {
      ?state rdfs:label ?name.
      ?state dcterms:subject <http://de.dbpedia.org/resource/Kategorie:Bundesland_(Deutschland)> }'

      sparql_client.query(query).map{ |res| res[:name].to_s }
    end
    def sparql_client
      SPARQL::Client.new('http://de.dbpedia.org/sparql')
    end
  end
end
