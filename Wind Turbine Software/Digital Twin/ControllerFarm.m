classdef ControllerFarm < handle

    % Campo de variables globales
    properties (Constant, Access = private)
        UpdateStateRate = 20 % frecuencia de actualización que permite ThingSpeak
    end

    properties (Access = private)
        % Timers
        StateTimer % timer para actualizacion en tiempo real de las graficas e indicadores de la turbina

        % Intervalo de tiempo de la infomación de ThingSpeak mostrada
        DateRange
        StabilityDateRange

        % Número de turbinas cuyo estado ya se ha actualizado en la
        % iteración actual
        StateUpdatedNum

        ActiveView % granja 0, resto id turbinas

        % MVC
        ViewObj % Vista
        ViewTurbineObjs % Vistas de las turbinas
        ModelObj % Modelo de la granja que contiene a las turbinas
    end

    methods (Access = public)
        function obj = ControllerFarm(viewObj, viewTurbineObjs, farmObj)
            obj.ViewObj = viewObj;
            obj.ViewTurbineObjs = viewTurbineObjs;
            obj.ModelObj = farmObj;

            obj.ActiveView = 0;

            % Añadir listeners del modelo para avisar a las vistas
            obj.addListeners(obj.ViewObj);

            % Inicializar los timers que se van a utilizar
            obj.initializeTimers();

            % Se inicia el timer que descarga información de ThingSpeak
            % de las turbinas
            start(obj.StateTimer);
        end

        % Se ejecuta al cerrar la aplicación
        function deleteTimers(obj)
            stop(obj.StateTimer);
            delete(obj.StateTimer);
        end

        % Callbacks
        % Cambia a otra vista
        function callback_changeView(obj, val)
            if val ~= obj.ActiveView
                % Se deshabilita la vista actual
                if obj.ActiveView > 0
                    obj.ViewTurbineObjs(obj.ActiveView).endView();
                end
                % Se habilita la nueva vista
                obj.ActiveView = val;
                if obj.ActiveView > 0
                    obj.ViewTurbineObjs(obj.ActiveView).initView();
                end
            end
        end
    end

    methods (Access = private)
        % Listeners de eventos del modelo
        function addListeners(obj, viewFarm)
            for i = 1:length(obj.ModelObj.Turbines)
                obj.ModelObj.Turbines(i).addlistener('StateUpdated', ...
                    @(src,evnt)obj.updateState(src, evnt, i));
            end
            obj.ModelObj.addlistener('StateUpdated', @(~,~)viewFarm.updateState);
        end

        % Timers
        function initializeTimers(obj)
            % Se inicializa timer que actualiza información del estado de
            % las turbinas
            obj.StateTimer = timer("Name", 'StateTimer', ...
                "ExecutionMode", "fixedRate", ...
                'Period', obj.UpdateStateRate, ...
                'TimerFcn', @(~,~)obj.updateTurbineState);
        end


        % Timers functions
        % Manda al modelo descargar información del estado actual de las
        % turbinas
        function updateTurbineState(obj)
            % Se calcula el intervalo de tiempo que se muestra en las
            % gráficas en esta iteración del timer, en función de la hora
            % actual
            date = datetime('now');
            initPoint = date-seconds(obj.ModelObj.SecuritySeconds + obj.ModelObj.NumSeconds - 1);
            endPoint = date-seconds(obj.ModelObj.SecuritySeconds);
            obj.DateRange = [initPoint, endPoint];

            stabilityInitPoint = date-seconds(obj.ModelObj.SecuritySeconds + obj.ModelObj.StabilityNumSeconds - 1);
            obj.StabilityDateRange = [stabilityInitPoint, endPoint];

            % Se reinicia el contador de turbinas actualizadas
            obj.StateUpdatedNum = 0;

            % Se actualizan las turbinas iterativamente
            for i = 1:length(obj.ModelObj.Turbines)
                obj.ModelObj.Turbines(i).updateState(obj.DateRange, obj.StabilityDateRange);
            end
        end

        % Listeners functions
        % Se actualizan las vistas con los datos de ThingSpeak actualizados
        function updateState(obj, ~, ~, turbineNum)
            obj.ViewTurbineObjs(turbineNum).updateState();
            % Se lleva la cuenta de las turbinas actualizadas para saber
            % cuando actualizar la vista de la granja
            obj.StateUpdatedNum = obj.StateUpdatedNum + 1;
            if obj.StateUpdatedNum == length(obj.ModelObj.Turbines)
                obj.ModelObj.updateState(obj.DateRange);
            end
        end
    end
end