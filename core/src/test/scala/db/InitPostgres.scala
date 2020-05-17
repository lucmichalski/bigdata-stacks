package db

import com.sbartnik.common.db.PostgresOperations
import com.typesafe.scalalogging.LazyLogging

object InitPostgres extends LazyLogging {
  def main(args: Array[String]) {
    PostgresOperations.initDb()
    logger.info("Initialized Postgres DB tables")
  }
}