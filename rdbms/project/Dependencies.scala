import sbt._

//noinspection TypeAnnotation
object Dependencies {

  val lift =          "net.liftweb"                %% "lift-json"       % "2.6.2"
  val logback =       "ch.qos.logback"              % "logback-classic" % "1.2.3"
  val scalaLogging =  "com.typesafe.scala-logging" %% "scala-logging"   % "3.7.1"
  val typesafeConf =  "com.typesafe"                % "config"          % "1.3.1"
  val json4s =        "org.json4s"                 %% "json4s-native"   % "3.3.0"
  val jansi =         "org.fusesource.jansi"        % "jansi"           % "1.12"
  val kafka =         "org.apache.kafka"           %% "kafka"           % "0.9.0.1"
  val postgres =      "org.postgresql"              % "postgresql"      % "42.1.1"
}