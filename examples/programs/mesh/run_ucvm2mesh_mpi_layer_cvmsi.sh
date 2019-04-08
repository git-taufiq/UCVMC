#!/usr/bin/sh

if [ -z "$UCVM_INSTALL_PATH" ]; then
  echo "Need to set UCVM_INSTALL_PATH to run >" ${0##*/} 
  exit
fi

## setup mpi environment
source /usr/usc/openmpi/default/setup.sh

BIN_DIR=${UCVM_INSTALL_PATH}/bin
CONF_DIR=${UCVM_INSTALL_PATH}/conf
SCRATCH=./scratch

cp ${BIN_DIR}/ucvm2mesh_mpi_layer .
cp ${CONF_DIR}/ucvm.conf .

sed 's ${SCRATCH} '$SCRATCH' ' la_habra_cvmsi.conf_template > la_habra_cvmsi.conf

salloc -N 4 --ntasks=8 --time=00:30:00 srun --ntasks=8 -v --mpi=pmi2 ${BIN_DIR}/ucvm2mesh_mpi_layer -f la_habra_cvmsi.conf -l 1 -c 3
#salloc --ntasks=4 --time=00:10:00 srun --ntasks=4 -v --mpi=pmi2 ${BIN_DIR}/ucvm2mesh_mpi_layer -f la_habra_cvmsi.conf -l 4 -c 3 
#salloc --ntasks=4 --time=00:10:00 srun --ntasks=4 -v --mpi=pmi2 ${BIN_DIR}/ucvm2mesh_mpi_layer -f la_habra_cvmsi.conf -l 7 -c 4 

echo "DONE"
