package com.sbartnik.common.db

import java.sql.{Connection, DriverManager}
import com.sbartnik.config.AppConfig

trait PostgresOperations {

  private val conf = AppConfig.Postgres

  def withConnection(func: Connection => Unit): Unit = {

    val connection = DriverManager.getConnection(conf.connectionString)
    try {
      func(connection)
    } finally {
      connection.close()
    }
  }

  def initDb(): Unit = withConnection(connection => {

    val stmt = connection.createStatement

    stmt.addBatch(
      s"""CREATE TABLE IF NOT EXISTS ${conf.siteTable} (
           |id serial primary key  NOT NULL,
           |name              text NOT NULL UNIQUE
         |);
       """.stripMargin
    )

    stmt.addBatch(
      s"""CREATE TABLE IF NOT EXISTS ${conf.actionTypeTable} (
           |id serial primary key  NOT NULL,
           |name              text NOT NULL UNIQUE
         |);
       """.stripMargin
    )

    stmt.addBatch(
      s"""CREATE TABLE IF NOT EXISTS ${conf.visitorTable} (
           |id bigserial primary key  NOT NULL,
           |name                 text NOT NULL UNIQUE
         |);
       """.stripMargin
    )

    stmt.addBatch(
      s"""CREATE TABLE IF NOT EXISTS ${conf.actionTable} (
            |id bigserial primary  key    NOT NULL,
            |timestamp             bigint NOT NULL,
            |site_id               int    REFERENCES ${conf.siteTable}(id),
            |action_type_id        int    REFERENCES ${conf.actionTypeTable}(id),
            |visitor_id            bigint REFERENCES ${conf.visitorTable}(id),
            |referrer              text   NULL,
            |previous_page         text   NULL,
            |geo                   text   NULL,
            |time_spent_seconds    int    NOT NULL,
            |sub_page              text   NULL
          |);
       """.stripMargin
    )

    stmt.executeBatch()
  })
}
object PostgresOperations extends PostgresOperations