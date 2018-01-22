/* SimpleApp.scala */

import org.apache.spark.sql.SparkSession

object SimpleApp {
  def main(args: Array[String]) {
    val logfile = "/p/home/michella/cc-index-34"
    val spark = SparkSession.builder.appName("Internet Rolodex").getOrCreate()
    val logData = spark.read.textFile(logfile).cache()
    val numAs = logData.filter(line => line.contains("a").count()
    val numBs = logData.filter(line => line.contains("b").count()
    println(s"Lines with a: $numAs, Lines with b: $numBs")
    spark.stop()
  }
}

