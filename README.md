# internet-rolodex
A rolodex of all emails and user profiles on the internet.

## Getting an HPC Account

* Get your Cyber Awareness Certificate
* Send to your sponsoring principle (CarolyAnn)
* Get assigned to a sub-project (Suzanne)

## Logging into the HPC

* Follow the instructions for configuring [PKINIT](https://centers.hpc.mil/users/pkinitUserGuide.html)
* To set up Spark, add the following lines to ```~/.bash_profile```:

```bash
PARK_VERSION=2.2.0
PATH=$PATH:$HOME/bin:/app/DAAC/spark/spark-$SPARK_VERSION/bin/
SPARK_HOME=/app/DAAC/spark/spark-$SPARK_VERSION/
```

## Running Jobs


