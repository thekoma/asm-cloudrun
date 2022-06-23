#!/bin/bash

TEMPLATE=module-template.yaml
NOW=$(date +%s)
MODULESDIR=./modules
if [ ! -d $MODULESDIR ]; then mkdir -p $MODULESDIR; else rm -fr $MODULESDIR; mkdir -p $MODULESDIR; fi
for i in $(seq -w 001 100); do
  MODULEYAML=$MODULESDIR/module-${i}.yaml
  sed -e "s/MODULENAME/module-${i}/g" -e "s/VERSION/${NOW}/g" $TEMPLATE > "${MODULEYAML}"
  echo -n " module-${i} "
done
