package com.sbartnik.layers.serving

import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.stream.ActorMaterializer
import com.sbartnik.common.HttpUtil
import com.sbartnik.common.Helpers
import com.sbartnik.layers.serving.logic.{PersistenceLogic, LambdaPersistenceLogic, RdbmsPersistenceLogic}
import scala.concurrent.Future
import scala.language.postfixOps
import scala.util.{Failure => FutureFailure, Success => FutureSuccess}

object RestServer extends App with HttpUtil with Helpers {

  implicit val system = ActorSystem("LambdaRestServer")
  implicit val materializer = ActorMaterializer()
  implicit val ec = system.dispatcher

  private def execute[T <: AnyRef](api: String, exFunc: (PersistenceLogic => T)) = {
    val persistenceLogic = api match {
      case "rdbms" => Some(RdbmsPersistenceLogic)
      case "lambda" => Some(LambdaPersistenceLogic)
      case _ => None
    }

    if(persistenceLogic.isEmpty)
      throw new Exception(s"Unrecognized persistence logic: $api")

    logDuration(onSuccess(Future(write(exFunc(persistenceLogic.get))))(complete(_)))
  }

  private val routes = get {
    pathPrefix(Segment) { api =>
      // siteName - if passed, result will contain site actions only of provided site
      //          - if not passed, result will consist of actions of all sites
      // bucketsNumber - if passed, result will include aggregated actions for period of time equals N*bucketsNumber
      //               - if not passed (or < 1), result will include aggregated actions for full available history
      path("siteActions") {
        parameters('siteName ? "", 'bucketsNumber ? 0) { (siteName, bucketsNumber) =>
          execute(api, _.getSiteActions(siteName, bucketsNumber))
        }
      } ~
      // siteName - if passed, result will contain unique visitors only of provided site
      //          - if not passed, result will consist of unique visitors of all sites
      // bucketIndex - if passed, result will include N*bucketIndex latest batch layer's unique visitors data
      //             - if not passed (or < 1), result will include latest speed layer's unique visitors data
      path("uniqueVisitors") {
        parameters('siteName ? "", 'bucketIndex ? 0) { (siteName, bucketIndex) =>
          execute(api, _.getUniqueVisitors(siteName, bucketIndex))
        }
      }
    }
  }

  val binding = Http().bindAndHandle(routes, "localhost", 9999)

  binding.onComplete {
    case FutureSuccess(b) =>
      val localAddress = b.localAddress
      println(s"Server available on ${localAddress.getHostName}:${localAddress.getPort}")
    case FutureFailure(err) =>
      logger.error(s"Binding failed. Error: ${err.getMessage}")
      system.terminate()
  }
}
