import Dependencies._

name := "LambdaArchitectureTest-Core"

spName := "sbartnik/LambdaArchitectureTest-Core"

scalacOptions ++= Seq("-feature", "-unchecked", "-deprecation")

sparkVersion := "2.0.0"

retrieveManaged := true

sparkComponents ++= Seq("core","streaming", "sql")

licenses += "Apache-2.0" -> url("http://opensource.org/licenses/Apache-2.0")

spIncludeMaven := true

lazy val commonSettings = Seq(
  organization := "com.sbartnik",
  scalaVersion := "2.11.8",
  version := "0.1.0"
)

lazy val deps = Seq(
  akkaHttp,
  lift,
  sparkHive,
  sparkStreamingKafka,
  sparkCassandraConnect,
  logback,
  scalaLogging,
  akkaHttpJson,
  jansi,
  json4s,
  twitterAlgebird,
  postgres
)

lazy val core = (project in file("."))
  .settings(commonSettings: _*)
  .settings(
    name := "LambdaArchitectureTest-Core",
    libraryDependencies ++= deps,
    libraryDependencies ~= { _.map(_.exclude("org.slf4j", "slf4j-log4j12"))}
  )