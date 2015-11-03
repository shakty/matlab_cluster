function [] = aggregate_fun(DUMPDIR)

    % Get subdirs in dump dir.
    files = dir(DUMPDIR);
    nFiles = length(files) - 2; % Always skip . and ..
    results = zeros(nFiles, 4);
    
    % Go to all directories, and load all parameters matrices in one.
    for r = 1:nFiles
        
        % Dir name.
        file = files(r);
				file = file.name;
        
        % Skip some directories.
        if ( strcmpi(file, '.') || strcmpi(file, '..'))
            continue;
        end
        
        load([ DUMPDIR '/' file ]);

        % You should do the aggregation in the way 
        % that fits best your needs.

        results(r,1) = dump.params.p1;
        results(r,2) = dump.params.p2;
        results(r,3) = dump.params.p3;
        results(r,4) = dump.results;
       
    end
    
    save('./results', 'results')
end



