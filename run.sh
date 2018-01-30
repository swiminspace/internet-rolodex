#!/bin/bash
#
#PBS -l select=3:ncpus=36:mpiprocs=36,walltime=00:10:00
#PBS -N spark-test
#PBS -A [YOUR_PROJECT_HERE]
#PBS -q debug

nodes=($( cat $PBS_NODEFILE | sort | uniq ))
nnodes=${#nodes[@]}
last=$(( $nnodes - 1 ))

source $MODULESHOME/init/bash

module load java
module load spark

#creates cat_master_test.sh to launch master node
cat > $WORKDIR/cat_master_test.sh <<EOT
#!/bin/bash

source $MODULESHOME/init/bash

module load java
module load spark

cd ${SPARK_HOME}
./sbin/start-master.sh

EOT

#change permissions to executable
chmod +x $WORKDIR/cat_master_test.sh

#checks $SHELL and executes appropriate commands
if [ "$SHELL" = '/bin/csh' ]; then
        ssh ${nodes[0]} 'set prompt="hello>"; source /etc/profile.d/zzz-hpcmp.csh; $WORKDIR/cat_master_test.sh'
else
        ssh ${nodes[0]} '$WORKDIR/cat_master_test.sh'
fi

#creates cat_worker_test.sh to launch worker nodes and connect back to master
cat > $WORKDIR/cat_worker_test.sh <<EOT
#!/bin/bash

source $MODULESHOME/init/bash

module load java
module load spark

cd ${SPARK_HOME}
./sbin/start-slave.sh spark://${nodes[0]}:7077

EOT

#change permissions to executable
chmod +x $WORKDIR/cat_worker_test.sh

#for each remaining node in the list, execute startup for worker
for i in $(seq 1 $last)
    do
        if [ "$SHELL" == '/bin/csh' ]; then
                ssh ${nodes[$i]} 'set prompt="hello>"; source /etc/profile.d/zzz-hpcmp.csh; $WORKDIR/cat_worker_test.sh'
        else
                ssh ${nodes[$i]} '$WORKDIR/cat_worker_test.sh'
        fi
    done

#cleanup
rm $WORKDIR/cat_master_test.sh
rm $WORKDIR/cat_worker_test.sh

#execute test program from Apache, pi.py
${SPARK_HOME}/bin/spark-submit --master spark://${nodes[0]}:7077 ${SPARK_HOME}/examples/src/main/python/pi.py
