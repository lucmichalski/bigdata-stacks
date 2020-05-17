package com.sbartnik.common

import com.typesafe.scalalogging.LazyLogging

trait LoggerUtil extends LazyLogging {
  def info(message: String): Unit = {
    logger.info(message)
  }
  def error(message: String, exception: Throwable): Unit = {
    logger.error(message + " Reason::" + exception.getCause)
  }
}

object LoggerUtil extends LoggerUtil