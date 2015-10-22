function param_sets_LSF(params)

% Import Cluster profile.
parallel.importProfile('/cluster/apps/matlab/support/BrutusLSF8h.settings')

% How many sequential simulations in one task.
SIMS4TASK = 4; 
% How many tasks group in one job. Should be multiple with SIMS4TASK.
TASKS4JOB = 20;

% Setup job scheduler.
logFolder = ['log/' params.simName];
mkdir(logFolder); % The name is unique under the dump directory.
dumpFolder = [ params.dumpDir params.simName];

sched = findResource('scheduler','type','lsf');
% emails = 'youremail@ethz.ch';
% submitArgs = ['-o ' logFolder '/' simName '.log -u ' emails];
% submitArgs = ['-o ' logFolder '/' simName '.log -B']; -B / -N sends email
submitArgs = [' -R "rusage[mem=1000]" -o ' logFolder '/' params.simName '.log'];
set(sched, 'SubmitArguments',submitArgs);
set(sched, 'DataLocation', [logFolder '/']);

% Create job.
j = createJob(sched);

% Init cell array of cell arrays.       
paramObjs = cell(SIMS4TASK, 1);            

% Counters.
simCount = 1;
jobCount = 1;
nCombinations = params.nRuns*size(params.p1, 2)*size(params.p2, 2)* ...
                size(params.p3,2);

% Seed type.
seed_fixed = 0;
seed_random = 1;

% Set seed for the random number generator
%  that will generate the seeds for each simulation.
if (params.seedtype ~= seed_fixed)
    s = RandStream('mcg16807', 'Seed', params.batchSeed);
    RandStream.setGlobalStream(s);
end 
            

% Nest several loops to simulate parameter sets.
for i1=1:length(params.p1)
    p1 = params.p1(i1);
     
    for i2=1:length(params.p2)
        p2 = params.p2(i2);   
   
    for i3=1:length(params.p3)
        p3 = params.p2(i3);   
   
        
    for rCount=1:params.nRuns

        % Defining seed
       
        if (params.seedtype == seed_random)
            % Random seed
            seed = randi(1000000);

        elseif (params.seedtype == seed_fixed)
            seed = params.seed;
        end

        % Notice how fprints is powerful to format text and numbers.
        fprintf('\n%s\n',params.simName);
        fprintf('Starting Run: %d/%d of Simulation n. %d/%d:\n', ...
                 rCount,params.nRuns,simCount,nCombinations)
        fprintf('------------------------------------\n');

        fprintf('P1,P2,P3: %f,%f,%f:\n', p1, p2, p3)
        fprintf('------------------------------------\n');

        paramsObj = struct( ...
            'dumpFolder', params.dumpFolder, ...
            'simCount', simCount, ...
            'nRun', nRun, ...
            'p1', p1, ...
            'p2', p2, ...
            'p3', p3, ...
            'seed', seed ...
        );

        % It is convenient to group together more simulations in one
        % task if simulations are short. Matlab overhead to start on
        % each cluster node is about 1 minute.
        taskIdx = mod(simCount, SIMS4TASK);

        if (taskIdx ~= 0)
            paramObjs{taskIdx} = paramsObj;
        else
            paramObjs{taskIdx+1} = paramsObj;
            createTask(j, @wrappersim, 0, paramObjs);
            paramObjs = cell(SIMS4TASK, 1);
        end

        % Submit the job to the scheduler in batches
        if (mod(simCount, TASKS4JOB) == 0)
            submit(j);

            if (simCount ~= nCombinations)
                j = createJob(sched); 
                jobCount = jobCount + 1;
            end

        end

        fprintf('\n\n');
    end
    
    % Updating the simulations counter.
    simCount = simCount + 1;
    
    end
    end
end  

% Submit the left-over tasks.
if (mod(simCount, TASKS4JOB) ~= 1) % 1: it has always one last increment.
    if (taskIdx ~= 0)
        createTask(j, @wrappersim, 0, paramObjs);
    end
    submit(j);
end


end



     
