##setenv.sh##

export SPARK_CONF_DIR=/public/home/hpc182212046/big_data_env/spark/conf
mkdir -p $SPARK_CONF_DIR

env=$SPARK_CONF_DIR/spark-env.sh
echo "export SPARK_LOG_DIR=~/SparkLog" > $env
echo "export SPARK_WORKER_DIR=~/SparkWorker" >> $env
echo "export SLURM_MEM_PER_CPU=$SLURM_MEM_PER_CPU" >> $env
echo 'export SPARK_WORKER_CORES=`nproc`' >> $env
echo 'export SPARK_WORKER_MEMORY=$(( $SPARK_WORKER_CORES*$SLURM_MEM_PER_CPU ))M' >> $env

echo "export SPARK_HOME=$SPARK_HOME" > ~/.bashrc
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
echo "export SPARK_CONF_DIR=$SPARK_CONF_DIR" >> ~/.bashrc

scontrol show hostname $SLURM_JOB_NODELIST > $SPARK_CONF_DIR/slaves

conf=$SPARK_CONF_DIR/spark-defaults.conf
masinfo=/public/home/hpc182212046/test_slurm/spark_on_slurm/echo_test
> $masinfo
echo "spark.default.parallelism" $(( $SLURM_CPUS_PER_TASK * $SLURM_NTASKS ))> $conf
echo "spark.submit.deployMode" client >> $conf
echo "spark.master" spark://`hostname`:7077 >> $conf
echo "spark.executor.cores" $SLURM_CPUS_PER_TASK >> $conf
echo "spark.executor.memory" $(( $SLURM_CPUS_PER_TASK*$SLURM_MEM_PER_CPU ))M >> $conf
echo "spark://"`hostname`:7077 >> $masinfo
