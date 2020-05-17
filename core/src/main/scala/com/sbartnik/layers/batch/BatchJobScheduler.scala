package com.sbartnik.layers.batch

import akka.actor.{Actor, ActorSystem, Props}
import com.sbartnik.config.AppConfig
import scala.concurrent.duration.DurationInt
import scala.language.postfixOps

case object StartBatchJobScheduleProcess

class BatchJobSchedulerActor(processor: BatchJob) extends Actor  {

  private implicit val dispatcher = context.dispatcher
  private val conf = AppConfig

  private val initialDelay = 1 second
  private val interval = conf.batchBucketMinutes minutes

  context.system.scheduler.schedule(initialDelay, interval, self, StartBatchJobScheduleProcess)

  def receive: PartialFunction[Any, Unit] = {
    case StartBatchJobScheduleProcess => processor.main(Array.empty)
  }
}

object BatchJobScheduler extends App {
  val actorSystem = ActorSystem("BatchJobSchedulerActorSystem")
  val processor = actorSystem.actorOf(Props(new BatchJobSchedulerActor(new BatchJob)))

  processor ! StartBatchJobScheduleProcess
}
