classdef ModelSimulator < ModelTurbine & handle

    % Campo de constantes globales
    properties (Constant)
       PitchLimits = [0 90]
       LoadLimits = [0 15]
       RPMLimits = [0 1000]
       PowerLimits = [0 500]
    end
        
    properties

    end

    events
        
    end

    methods
        function obj = ModelSimulator(stateChannelID, stateWriteKey, stateReadKey, ...
                stabilityChannelID, stabilityWriteKey, stabilityReadKey, ...
                commandChannelID, commandWriteKey, commandReadKey)
            obj = obj@ModelTurbine(stateChannelID, stateWriteKey, stateReadKey, ...
                stabilityChannelID, stabilityWriteKey, stabilityReadKey, ...
                commandChannelID, commandWriteKey, commandReadKey);
        end 

        function evaluateRisks(obj)
            % El simulador no presenta riesgos 
        end
    end
end