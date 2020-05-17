import Dependencies._

name := "LambdaArchitectureTest-Rdbms"

scalacOptions ++= Seq("-feature", "-unchecked", "-deprecation")

retrieveManaged := true

licenses += "Apache-2.0" -> url("http://opensource.org/licenses/Apache-2.0")

lazy val commonSettings = Seq(
  organization := "com.sbartnik",
  scalaVersion := "2.11.8",
  version := "0.1.0"
)

lazy val deps = Seq(
  lift,
  logback,
  typesafeConf,
  scalaLogging,
  jansi,
  json4s,
  kafka,
  postgres
)

lazy val rdbms = (project in file("."))
  .settings(commonSettings: _*)
  .settings(
    name := "LambdaArchitectureTest-Rdbms",
    libraryDependencies ++= deps
  )