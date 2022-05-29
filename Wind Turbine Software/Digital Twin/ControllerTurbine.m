classdef ControllerTurbine < handle

    % Campo de variables globales
    properties (Constant)
        UpdateCommandsRate = 15 % frecuencia de actualización que permite ThingSpeak
        UpdateWeatherRate = 600 % frecuencia de actualización de openweathermap
    end

    properties (Access = private)
        % Timers
        CommandsTimer % timer para desactivar escritura de comandos durante 15s
        WeatherTimer % timer para actualizacion del tiempo (mínimo cada 10 min)

        % MVC
        ViewObj % Vista
        ModelObj % Modelo
    end

    methods 
        function obj = ControllerTurbine(viewObj, turbineObj)
            obj.ViewObj = viewObj;
            obj.ModelObj = turbineObj;
        
            % Añadir listeners del modelo para avisar a las vistas
            obj.addListeners(obj.ViewObj);

            % Inicializar los timers que se van a utilizar
            obj.initializeTimers();
        end

        function deleteTimers(obj)
            stop(obj.WeatherTimer); 
            stop(obj.CommandsTimer); % en caso de que esté iniciado
            delete(obj.WeatherTimer);
            delete(obj.CommandsTimer);
        end

        function initTurbineComponents(obj)
            % Se inicia un timer que actualiza el tiempo 
            start(obj.WeatherTimer);
            % Se cargan los comandos de la última sesión
            obj.ModelObj.updateLastCommands();
            % Si estamos en modo auto se deshabilitan los comandos de pitch
            % y carga
            if ~obj.ModelObj.Mode
                obj.ViewObj.disablePitchCommands()
                obj.ViewObj.disableLoadCommands()
            end          
        end

        function endTurbineComponents(obj)         
            stop(obj.WeatherTimer); 
        end
        
        % Callbacks
        % Informa de comando de modo dado por el usuario
        function callback_modeCommandButton(obj, ~, ~, val)
            % Se deshabilita la escritura de mas comandos
            obj.ViewObj.disableCommands();
            % Se avisa al modelo
            obj.ModelObj.Mode = val;
            obj.ModelObj.changeCommands();
        end

        % Informa de comando de pitch dado por el usuario
        function callback_pitchCommandButton(obj, ~, ~, val)
            % Se deshabilita la escritura de mas comandos
            obj.ViewObj.disableCommands();
            % Se avisa al modelo
            obj.ModelObj.Pitch = val;
            obj.ModelObj.changeCommands();
        end

        % Informa de comando de carga dado por el usuario
        function callback_loadCommandButton(obj, ~, ~, val)
            % Se deshabilita la escritura de mas comandos
            obj.ViewObj.disableCommands();
            % Se avisa al modelo
            obj.ModelObj.Load = val;
            obj.ModelObj.changeCommands();
        end

        % Informa de parada de emergencia dado por el usuario
        function callback_emergencyCommandButton(obj, ~, ~, val)
            % Se deshabilita la escritura de mas comandos
            obj.ViewObj.disableCommands();
            % Se avisa al modelo
            obj.ModelObj.Emergency = val;
            obj.ModelObj.changeCommands();
        end
    end

    methods (Access = private)
        % Listeners de eventos del modelo
        function addListeners(obj, viewTurbine)
            obj.ModelObj.addlistener('WeatherUpdated', @(~,~)viewTurbine.updateWeather);
            obj.ModelObj.addlistener('LastCommandsUpdated', @(~,~)viewTurbine.updateLastCommands);
            obj.ModelObj.addlistener('CommandsChanged', @(~,~)obj.delayTurbineCommands);
            if ismember('RPMRisk', events(obj.ModelObj))
                obj.ModelObj.addlistener('RPMRisk', @(~,~)viewTurbine.RPMRisk);
            end
        end

        % Timers
        function initializeTimers(obj)
            % Se inicializa timer que actualiza información del tiempo 
            obj.WeatherTimer = timer("Name",'WeatherTimer', ...
                "ExecutionMode","fixedRate", ...
                'Period',obj.UpdateWeatherRate, ...
                'TimerFcn',@(~,~)obj.updateWeather);
            
            % Se inicializa timer que habilita escritura de comandos  
            % una vez transcurridos 15s
            obj.CommandsTimer = timer("Name",'CommandsTimer', ...
                'StartDelay',obj.UpdateCommandsRate,... 
                'TimerFcn',@(~,~)obj.enableTurbineCommands);
        end


        % Timers functions 
        % Actualiza información del tiempo
        function updateWeather(obj)            
            obj.ModelObj.updateWeather();
        end
        
        % Habilita escritura de comandos en la vista
        function enableTurbineCommands(obj)    
            obj.ViewObj.enableCommands();
        end

        % Listeners functions
        % Habilita escritura de comandos tras 15s
        function delayTurbineCommands(obj)
            start(obj.CommandsTimer); % empiezo cuenta atras
        end
    end
end