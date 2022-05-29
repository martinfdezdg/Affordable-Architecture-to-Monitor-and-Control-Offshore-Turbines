classdef ModelFarm < handle

    % Campo de variables globales
    properties (Constant)
        % Cantidad de segundos que se muestran en los históricos de datos
        NumSeconds = 60*10 % últimos 10 minutos
        StabilityNumSeconds = 40
        SecuritySeconds = 20
    end

    properties (GetAccess = public, SetAccess = private)
        % farm general information
        Name
        Desc

        % farm turbines
        Turbines

        % farm timestamps
        TimeStamps

        % farm power
        Power
    end

    events
        StateUpdated
    end

    methods (Access = public)
        function obj = ModelFarm(turbines)
            obj.Name = 'F01';
            obj.Desc = 'Offshore turbines farm for the Final Research Project of Computer Science';
            obj.Turbines = turbines;
        end
        
        % Suma de la potencia generada por las turbinas activas
        function updateState(obj, dateRange)
            obj.TimeStamps = [dateRange(1):seconds(1):dateRange(end)]';
            obj.Power = zeros(length(obj.TimeStamps), 1);
            for i = 1:length(obj.Turbines)
                if obj.Turbines(i).Activity
                    turbineTimeStamps = obj.Turbines(i).TimeStamps;
                    turbinePower = obj.Turbines(i).DataPower;                    
                    if turbineTimeStamps(1) ~= dateRange(1)
                        turbineTimeStamps = [dateRange(1); turbineTimeStamps];
                        turbinePower = [0; turbinePower];
                    end
                    if turbineTimeStamps(end) ~= dateRange(end)
                        turbineTimeStamps = [turbineTimeStamps; dateRange(end)];
                        turbinePower = [turbinePower; 0];
                    end                  
                    turbineTimeTable = timetable(turbineTimeStamps, turbinePower);
                    turbineTimeTable = retime(turbineTimeTable, ...
                        'secondly', 'fillwithconstant');  
                    obj.Power = obj.Power + turbineTimeTable.turbinePower(1:length(obj.Power));
                    
                end
            end

            obj.notify('StateUpdated');
        end
    end
end