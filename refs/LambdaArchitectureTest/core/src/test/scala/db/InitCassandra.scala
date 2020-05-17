package db

import com.sbartnik.common.db.CassandraOperations
import com.typesafe.scalalogging.LazyLogging

object InitCassandra extends LazyLogging {
  def main(args: Array[String]) {
    CassandraOperations.initDb()
    logger.info("Initialized Cassandra DB keyspace & tables")
  }
}