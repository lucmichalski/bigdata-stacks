package com.sbartnik.common

import java.util.Properties
import net.liftweb.json.{DefaultFormats, JValue, Serialization, ShortTypeHints, parse => liftParser}
import scala.io.Source
import scala.language.implicitConversions

trait Helpers {

  implicit protected val formats = Serialization.formats(ShortTypeHints(List()))
  protected def write[T <: AnyRef](value: T): String = Serialization.write(value)
  protected def parse(value: String): JValue = liftParser(value)

  def getLinesFromResourceFile(resFileName: String): Array[String] =
    Source.fromInputStream(getClass.getResourceAsStream(s"/$resFileName")).getLines.toArray

  implicit def propertiesExtensions(properties: Properties) = new {
    def format: String = {
      properties.toString
    }
  }
}
object Helpers extends Helpers
