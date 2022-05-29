classdef ModelPrototype < ModelTurbine & handle

    % Campo de constantes globales
    properties (Constant)
        PitchLimits = [0 45]
        LoadLimits = [0 15]
        RPMLimits = [0 1000]
        PowerLimits = [0 20]
        
        RPMRiskMsg = ["Correct RPM" "Too high RPM" "Out of range RPM"]
    end

    properties
        RPMRiskLevel % 1-3
    end

    events
        RPMRisk
    end

    methods
        function obj = ModelPrototype(stateChannelID, stateWriteKey, stateReadKey, ...
                stabilityChannelID, stabilityWriteKey, stabilityReadKey, ...
                commandChannelID, commandWriteKey, commandReadKey)
            obj = obj@ModelTurbine(stateChannelID, stateWriteKey, stateReadKey, ...
                stabilityChannelID, stabilityWriteKey, stabilityReadKey, ...
                commandChannelID, commandWriteKey, commandReadKey);

            obj.RPMRiskLevel = 1;
        end

        function evaluateRisks(obj)
            % Riesgo RPM
            currentRPM = obj.DataRPM(end);
            if 600 < currentRPM & currentRPM <= 750
                obj.RPMRiskLevel = 2;
                
            elseif 750 < currentRPM
                obj.RPMRiskLevel = 3;
            else
                obj.RPMRiskLevel = 1;
            end
            obj.notify('RPMRisk');
        end
    end
end