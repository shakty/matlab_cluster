function [] = main_fun(confFile)

    %% Loading Conf
    load(confFile);

    %% Start Vectorization of Parameters Sets
    param_sets_LSF(conf);

    % Exit Matlab when invoked from command line with -r option
    %exit
end