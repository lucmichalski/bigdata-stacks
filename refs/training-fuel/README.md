# Installation

    sudo ./warp10-standalone.sh bootstrap

https://www.prix-carburants.gouv.fr/rubrique/opendata/

- Draw WKT : https://clydedacruz.github.io/openstreetmap-wkt-playground/
- Draw/convert WKT/geoJson http://dev.openlayers.org/examples/vector-formats.html


Usage: groovy convert.groovy PrixCarburants_xxx.xml

update limits

    sudo ./warp10-standalone.init start

# Data upload
http://127.0.0.1:8080/api/v0/update 
     curl  -H 'X-Warp10-Token: JIPV8eK36OAddyDdDWLN1uy21hIla27_Sfk_yHOZ_O.HI2gmuAmIArP45Y7WG6n8MVdp9aMVcGPucloHH6qQXlvJnWg8VXLPoHssooQux3U.8eyjfq8jc.VuMrPKqCEI' http://127.0.0.1:8080/api/v0/update --data-binary @data


# Practice

1. Gazole price in whatever during november 2018
2. Mean price by station
3. Global average
4. Mean of the last available diesel fuel prices in France
5. Find the cheapest fuel station near here
6. put_loc_in_attributes.mc2
7. Find the cheapest fuel station near here
8. Omit closed fuel stations
9. 10 km radial