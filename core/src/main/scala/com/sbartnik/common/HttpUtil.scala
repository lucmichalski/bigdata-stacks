package com.sbartnik.common

import akka.http.scaladsl.server._
import com.typesafe.scalalogging.LazyLogging
import de.heikoseeberger.akkahttpjson4s.Json4sSupport
import org.json4s.{DefaultFormats, Formats, native}

trait HttpUtil extends Directives with Json4sSupport with LazyLogging {

  implicit val serialization = native.Serialization
  implicit def json4sFormats: Formats = DefaultFormats
  private val rejectionHandler = RejectionHandler.default

  def logDuration(inner: Route): Route = { ctx =>
    val start = System.currentTimeMillis()
    val innerRejectionsHandled = handleRejections(rejectionHandler)(inner)
    mapResponse { resp =>
      val d = System.currentTimeMillis() - start
      logger.info(s"[${resp.status.intValue()}] ${ctx.request.method.name} ${ctx.request.uri} took: ${d}ms")
      resp
    }(innerRejectionsHandled)(ctx)
  }
}
