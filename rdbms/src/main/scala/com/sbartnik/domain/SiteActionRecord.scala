package com.sbartnik.domain

case class SiteActionRecord(timestamp: Long,
                            var timestampBucket: Long,
                            referrer: String,
                            action: String,
                            previousPage: String,
                            visitor: String,
                            geo: String,
                            timeSpentSeconds: Int,
                            subPage: String,
                            site: String,
                            var props: Map[String, String] = Map()) {

  def serialized: String = {
    s"$timestamp\t$referrer\t$action\t$previousPage\t$visitor\t$geo\t$timeSpentSeconds\t$subPage\t$site"
  }
}

object SiteActionRecord {

  def deserialize(line: String): Option[SiteActionRecord] = {
    val record = line.split("\\t")
    if (record.length == 9)
      Some(SiteActionRecord(
        record(0).toLong, -1, record(1), record(2), record(3),
        record(4), record(5), record(6).toInt, record(7), record(8)))
    else
      None
  }
}