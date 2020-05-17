package com.sbartnik.common.db

import java.sql
import com.datastax.driver.core.{ResultSet, Row}
import scala.collection.JavaConverters._

trait DbRowMapper[T] {
  def mapSingleRecord(row: Row): T
  def mapSingleRecord(rs: sql.ResultSet) : T
}

object DbRowMapper {
  implicit class CassandraResultSetExtensions(val rs: ResultSet) extends AnyVal {
    def map[T](mapper: DbRowMapper[T]): List[T] = {
      rs.all().asScala.toList.map(mapper.mapSingleRecord)
    }
  }
  implicit class JdbcResultSetExtensions(val rs: sql.ResultSet) extends AnyVal {
    def map[T](mapper: DbRowMapper[T]): List[T] = {
      val stream = new Iterator[sql.ResultSet] {
        def hasNext: Boolean = rs.next()
        def next(): sql.ResultSet = rs
      }.toStream

      stream.map(mapper.mapSingleRecord).toList
    }
  }
}