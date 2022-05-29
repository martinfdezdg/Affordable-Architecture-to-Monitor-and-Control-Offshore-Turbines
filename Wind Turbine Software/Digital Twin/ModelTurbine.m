classdef ModelTurbine < handle & matlab.mixin.Heterogeneous

    % Campo de constantes globales
    properties (Constant)
        % ThingSpeak - Estado de la turbina
        PitchField = 1
        LoadField = 2
        RPMField = 3
        PowerField = 4
        PhaseField = 5
        WindField = 6

        % ThingSpeak - Estabilidad de la turbina
        AxField = 1
        AyField = 2
        AzField = 3
        GxField = 4
        GyField = 5
        GzField = 6

        % ThingSpeak - Comandos de la turbina
        ModeField = 1
        PitchCmdField = 2
        LoadCmdField = 3
        StopCmdField = 4

        % Weather info (openweathermap.org)
        WeatherReadKey = '88d6127e703cdf248596d405c2aa7c72'
    end

    properties (Abstract, Constant)
        PitchLimits
        LoadLimits
        RPMLimits
        PowerLimits
    end

    properties (GetAccess = public, SetAccess = protected)
        % ThingsPeak
        StateChannelID
        StateWriteKey
        StateReadKey
        StabilityChannelID
        StabilityWriteKey
        StabilityReadKey
        CommandChannelID
        CommandWriteKey
        CommandReadKey

        % Turbine general information
        Name
        Desc
        Lat
        Lon

        LastUpdated
        Created

        % Turbine weather
        WeatherTemp
        WeatherHum
        WeatherPress
        WeatherWindSpeed
        WeatherWindDir

        % Turbine state timestamps
        TimeStamps

        % Turbine stability timestamps
        StabilityTimeStamps

        % Turbine inputs
        DataWind
        DataPitch
        DataLoad

        % Turbine outputs
        DataRPM
        DataPower
        DataPhase

        % Stability outputs
        DataAx
        DataAy
        DataAz
        DataGx
        DataGy
        DataGz
    end

    properties (Access = public)
        % Commands
        Mode
        Pitch
        Load
        Emergency
    end

    properties (Dependent, GetAccess = public, SetAccess = protected)
        Activity
        StabilityActivity
    end

    events
        StateUpdated
        WeatherUpdated
        LastCommandsUpdated
        CommandsChanged
    end

    methods (Access = public)
        function obj = ModelTurbine(turbineChannelID, turbineWriteKey, turbineReadKey, ...
                stabilityChannelID, stabilityWriteKey, stabilityReadKey, ...
                twinChannelID, twinWriteKey, twinReadKey)
            obj.StateChannelID = turbineChannelID;
            obj.StateReadKey = turbineReadKey;
            obj.StateWriteKey = turbineWriteKey;
            obj.StabilityChannelID = stabilityChannelID;
            obj.StabilityWriteKey = stabilityWriteKey;
            obj.StabilityReadKey = stabilityReadKey;
            obj.CommandChannelID = twinChannelID;
            obj.CommandWriteKey = twinWriteKey;
            obj.CommandReadKey = twinReadKey;

            [~, ~, channelInfo] = thingSpeakRead(obj.StateChannelID, ...
                'ReadKey', obj.StateReadKey);
            obj.Name = channelInfo.Description;
            obj.Lat = channelInfo.Latitude;
            obj.Lon = channelInfo.Longitude;
            obj.Created = channelInfo.Created;
        end

        function updateState(obj, dateRange, stabilityDateRange)
            [data, obj.TimeStamps, channelInfo] = thingSpeakRead(obj.StateChannelID, ...
                'DateRange', dateRange, ...
                'ReadKey', obj.StateReadKey);

            obj.LastUpdated = channelInfo.Updated;

            % Comprobar actividad
            if obj.Activity
                obj.DataPitch = data(:, obj.PitchField);
                obj.DataLoad = data(:, obj.LoadField);
                obj.DataRPM = data(:, obj.RPMField);
                obj.DataPower = data(:, obj.PowerField);
                %obj.DataPhase = data(end, obj.PhaseField);
                %obj.DataPhase = obj.DataPhase(end);
                obj.DataWind = data(:, obj.WindField);
%                 if isempty(obj.WindField)
%                     obj.DataWind = obj.WeatherWindSpeed;
%                 end

                % Evaluar Riesgos
                obj.evaluateRisks;
            end

            [stabilityData, obj.StabilityTimeStamps] = thingSpeakRead(obj.StabilityChannelID, ...
                'DateRange', stabilityDateRange, ...
                'ReadKey', obj.StabilityReadKey);

            % Comprobar actividad
            if obj.StabilityActivity
                obj.DataAx = stabilityData(:, obj.AxField);
                obj.DataAy = stabilityData(:, obj.AyField);
                obj.DataAz = stabilityData(:, obj.AzField);
                obj.DataGx = stabilityData(:, obj.GxField);
                obj.DataGy = stabilityData(:, obj.GyField);
                obj.DataGz = stabilityData(:, obj.GzField);
            end

            obj.notify('StateUpdated');
        end

        % Cargar últimos comandos sesión anterior
        function updateLastCommands(obj)
            data = thingSpeakRead(obj.CommandChannelID, ...
                'ReadKey', obj.CommandReadKey);
            obj.Mode = data(obj.ModeField);
            obj.Pitch = data(obj.PitchCmdField);
            obj.Load = data(obj.LoadCmdField);
            obj.Emergency = data(obj.StopCmdField);

            obj.notify('LastCommandsUpdated');
        end

        function updateWeather(obj)
            url = ['https://api.openweathermap.org/data/2.5/weather?', ...
                'lat=', num2str(obj.Lat), ...
                '&lon=', num2str(obj.Lon), ...
                '&APPID=', obj.WeatherReadKey];
            weatherData = webread(url, weboptions('ContentType','json'));
            obj.WeatherTemp = weatherData.main.temp-273;
            obj.WeatherHum = weatherData.main.humidity;
            obj.WeatherPress = weatherData.main.pressure;
            obj.WeatherWindSpeed = weatherData.wind.speed;
            obj.WeatherWindDir = weatherData.wind.deg;

            obj.notify('WeatherUpdated');
        end

        % Sube todos los comandos a ThingSpeak
        function changeCommands(obj)
            thingSpeakWrite(obj.CommandChannelID, ...
                [obj.Mode, obj.Pitch, obj.Load, obj.Emergency], ...
                "WriteKey",obj.CommandWriteKey);

            obj.notify('CommandsChanged');
        end
    end

    % Getters
    methods
        function activity = get.Activity(obj)
            activity = ~isempty(obj.TimeStamps);
        end

        function stabilityActivity = get.StabilityActivity(obj)
            stabilityActivity = ~isempty(obj.StabilityTimeStamps);
        end
    end

    methods (Abstract)
        evaluateRisks;
    end
end