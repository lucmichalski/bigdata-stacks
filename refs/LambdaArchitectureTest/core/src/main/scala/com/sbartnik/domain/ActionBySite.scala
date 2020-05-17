package com.sbartnik.domain

import java.sql.ResultSet
import com.datastax.driver.core.Row
import com.sbartnik.common.db.DbRowMapper

case class ActionBySite(site: String,
                        timestamp_bucket: Long,
                        fav_count: Long,
                        comm_count: Long,
                        view_count: Long)

object ActionBySite extends DbRowMapper[ActionBySite] {
  def mapSingleRecord(row: Row): ActionBySite = {
    ActionBySite(
      row.getString(0), row.getLong(1),
      row.getLong(2), row.getLong(3), row.getLong(4)
    )
  }

  override def mapSingleRecord(rs: ResultSet): ActionBySite = {
    // In JDBC indexes are numbered from 1... why!?
    ActionBySite(
      rs.getString(1), rs.getLong(2),
      rs.getLong(3), rs.getLong(4), rs.getLong(5)
    )
  }
}
