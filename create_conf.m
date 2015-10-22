% Simulation Parameters Vectors Sets.
clc
clear

simName = 'my_simulation';
dumpFolder = './dump/'; %/cluster/work/scr4/balistef/';
nRuns = 10;

p1 = [0.1:0.1:1];
p2 = [-1,1];
p3 = [1:50];

seed = 0;
seedtype = 0; % 0 = fixed, 1 = random;

conf = struct( ...
    'dumpFolder', dumpFolder, ...
    'nRun', nRuns, ...
    'p1', p1, ...
    'p2', p2, ...
    'p3', p3, ...
    'seed', seed, ...
    'seedtype', seedtype ...
);

% Saving all params
save(['./conf/' simName], 'conf');