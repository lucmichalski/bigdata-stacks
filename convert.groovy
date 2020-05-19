import java.text.SimpleDateFormat 
import java.util.Date

//
// Usage: groovy convert.groovy PrixCarburants_xxx.xml
//

/**
 * Calculates the distance in km between two lat/long points
 * using the haversine formula
 */
double haversine(
        double lat1, double lng1, double lat2, double lng2) {
    int r = 6371; // average radius of the earth in km
    double dLat = Math.toRadians(lat2 - lat1);
    double dLon = Math.toRadians(lng2 - lng1);
    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    double d = r * c;
    return d;
}

// Paris 48.860645, 2.341565
//println "distance=${haversine(48.860645, 2.341565,41.491854902513,9.0555939368657)}"


def filepath = new File(args[0])
def xml = new XmlSlurper().parse(filepath)

def printErr = System.err.&println

// current format
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
// format used before 2015
//SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
sdf.setTimeZone(TimeZone.getTimeZone("Europe/Berlin"))

xml.pdv.each { pdv ->
  String id = pdv.@id.text().trim()
 
  Double la = null
  Double lo = null

  String cp = null
 
  if (pdv.@cp.text()?.trim()) {
    cp = pdv.@cp.text()
  } else {
    printErr("tout pourri ${id}")
    return
  }

  if (pdv.@latitude.text()?.trim()) {
    la = Double.parseDouble(pdv.@latitude.text()) 
  }

  if (pdv.@longitude.text()?.trim()) {
    lo = Double.parseDouble(pdv.@longitude.text())
  }

  //
  // L'Open Data c'est naze
  // Parce que c'est notre projet
  //
  if (null!=la && null!=lo) {
    if (Math.abs(lo) > 100 && Math.abs(la) > 100) {
      la = la / 100000
      lo = lo / 100000
    }

    def dist = haversine(48.860645, 2.341565,la,lo)

    if (dist > 1400) {
      dist = haversine(48.860645, 2.341565,lo,la)        

      if (dist < 1400) {
        def tmp = lo
        lo = la
        la = tmp
      } else {
        printErr("tout pourri ${id}")
        return  
      }        
    }
  }
 
  pdv.prix.each { prix ->
    if (!prix.@maj.text()?.trim()) {
     // no date skip this entry
     return
    }

    def date = sdf.parse(prix.@maj.text())   
    def fuelValue =  Double.parseDouble(prix.@valeur.text()) / 1000
    def  fuelType = prix.@nom.text().trim().toLowerCase()
    
    StringBuilder sb = new StringBuilder()
    sb.append("${date.getTime() * 1000}")
    sb.append("/")
    if (null!=la && null!=lo) {
      sb.append("${la}:${lo}")
    }
    sb.append("/")
    sb.append(" data.fuel{id=${id},type=${fuelType},cp=${cp}} ${fuelValue}")
    println sb.toString()
  }
}

