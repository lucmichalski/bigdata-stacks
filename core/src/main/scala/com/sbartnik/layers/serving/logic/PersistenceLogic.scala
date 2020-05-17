package com.sbartnik.layers.serving.logic

import com.sbartnik.domain.{ActionBySite, UniqueVisitorsBySite}

trait PersistenceLogic {

  def getSiteActions(siteName: String, bucketsNumber: Int): List[ActionBySite]
  def getUniqueVisitors(siteName: String, bucketIndex: Int): List[UniqueVisitorsBySite]
}
