function wrappersim( paramArgs )
    
	  % Matlab has an overhead to start, so it's better to
    % wrap together multiple simulations.

    for i=1:length(paramArgs)
        simulation(paramArgs{i})
    end

end

