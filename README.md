# Template for Matlab Jobs Spawning on the ETH Brutus Cluster

1. Adjust the path to the dump folder in the `create_conf.m` file.
2. Run `create_conf` to generate a conf file inside the `/conf/` directory.
3. Run `GO_FUN` to start the jobs.
4. Run `GOAGGR_FUN` to aggregate the results of different jobs inside this folder (save `results.mat`).
