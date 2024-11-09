#!/bin/bash

source .env #Sourcing .env for Shell and subShells variable...

bash version_check.sh
bash partitioning.sh
bash mount_partitions.sh
bash packages.sh


