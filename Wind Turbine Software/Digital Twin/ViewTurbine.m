classdef ViewTurbine < handle
    
    properties (Constant)
        ModePressedButtonColor = [0.149 0.149 0.149]
        ModeNotPressedButtonColor = [0.251 0.251 0.251]
        
        EmergencyPressedButtonColor = [0.649 0.151 0.151]
        EmergencyNotPressedButtonColor = [0.749 0.251 0.251]

        GreenColor = [0.251 0.749 0.251]
        YellowColor = [0.749 0.749 0.251]
        RedColor = [0.749 0.251 0.251]
        BlueColor = [0 0.4470 0.7410]

        AutoMode = 0
        ManualMode = 1
    end

    % Propiedades que se corresponden con los componentes de la app
    properties (Access = private)       
        GridLayout                      matlab.ui.container.GridLayout        
        ComponentsGridLayout            matlab.ui.container.GridLayout
        SchemaPanel                     matlab.ui.container.Panel
        SchemaGridLayout                matlab.ui.container.GridLayout
        WindSchemaPanel                 matlab.ui.container.Panel
        WindSchemaGridLayout            matlab.ui.container.GridLayout
        HeadingWindSchemaLabel          matlab.ui.control.Label
        HeadingValueWindSchemaLabel     matlab.ui.control.Label
        SpeedWindSchemaLabel            matlab.ui.control.Label
        SpeedValueWindSchemaLabel       matlab.ui.control.Label
        GeneralSchemaPanel              matlab.ui.container.Panel
        GeneralSchemaGridLayout         matlab.ui.container.GridLayout
        SerialGeneralSchemaLabel        matlab.ui.control.Label
        SerialValueGeneralSchemaLabel   matlab.ui.control.Label
        LifetimeGeneralSchemaLabel      matlab.ui.control.Label
        LifetimeValueGeneralSchemaLabel matlab.ui.control.Label
        UsetimeGeneralSchemaLabel       matlab.ui.control.Label
        UsetimeValueGeneralSchemaLabel  matlab.ui.control.Label
        WeatherSchemaPanel              matlab.ui.container.Panel
        WeatherSchemaGridLayout         matlab.ui.container.GridLayout
        TemperatureWeatherSchemaLabel   matlab.ui.control.Label
        TemperatureValueWeatherSchemaLabel matlab.ui.control.Label
        HumidityWeatherSchemaLabel      matlab.ui.control.Label
        HumidityValueWeatherSchemaLabel matlab.ui.control.Label
        PressureWeatherSchemaLabel      matlab.ui.control.Label
        PressureValueWeatherSchemaLabel matlab.ui.control.Label
        WavesSchemaPanel                matlab.ui.container.Panel
        WavesSchemaGridLayout           matlab.ui.container.GridLayout
        HeadingBaseSchemaLabel          matlab.ui.control.Label
        HeadingValueBaseSchemaLabel     matlab.ui.control.Label
        WaveHeightBaseSchemaLabel       matlab.ui.control.Label
        WaveHeightValueBaseSchemaLabel  matlab.ui.control.Label
        TurbineImage                    matlab.ui.control.Image
        CommandsPanel                   matlab.ui.container.Panel
        CommandsGridLayout              matlab.ui.container.GridLayout
        CommandsLabel                   matlab.ui.control.Label
        EmergencyCommandButton          matlab.ui.control.StateButton
        ModeCommandGridLayout           matlab.ui.container.GridLayout
        AutoModeCommandButton           matlab.ui.control.Button
        ManualModeCommandButton         matlab.ui.control.Button
        PitchCommandGridLayout          matlab.ui.container.GridLayout
        LessPitchCommandButton          matlab.ui.control.Button
        PitchCommandUpdateButton        matlab.ui.control.Button
        PitchCommandLabel               matlab.ui.control.Label
        PitchCommandField               matlab.ui.control.NumericEditField
        MorePitchCommandButton          matlab.ui.control.Button
        LoadCommandGridLayout           matlab.ui.container.GridLayout
        LoadCommandLabel                matlab.ui.control.Label
        LoadCommandField                matlab.ui.control.NumericEditField
        LessLoadCommandButton           matlab.ui.control.Button
        MoreLoadCommandButton           matlab.ui.control.Button
        LoadCommandUpdateButton         matlab.ui.control.Button
        StatePanel                      matlab.ui.container.Panel
        StateGridLayout                 matlab.ui.container.GridLayout
        StateLabel                      matlab.ui.control.Label
        PitchStateGridLayout            matlab.ui.container.GridLayout
        PitchStateGauge                 matlab.ui.control.NinetyDegreeGauge
        LoadStateGridLayout             matlab.ui.container.GridLayout
        LoadStateGauge                  matlab.ui.control.LinearGauge
        RPMStateGridLayout              matlab.ui.container.GridLayout
        RPMStateGauge                   matlab.ui.control.Gauge
        PowerStateGridLayout            matlab.ui.container.GridLayout
        PowerStateGauge                 matlab.ui.control.Gauge
        PitchStateUIAxes                matlab.ui.control.UIAxes
        LoadStateUIAxes                 matlab.ui.control.UIAxes
        RPMStateUIAxes                  matlab.ui.control.UIAxes
        PowerStateUIAxes                matlab.ui.control.UIAxes
        RisksPanel                      matlab.ui.container.Panel
        RisksGridLayout                 matlab.ui.container.GridLayout
        RisksLabel                      matlab.ui.control.Label
        RPMRisksLabel                   matlab.ui.control.Label
        RisksIndicator1                 matlab.ui.control.Label
        WindPanel                       matlab.ui.container.Panel
        StabilityGridLayout             matlab.ui.container.GridLayout
        StabilityLabel                  matlab.ui.control.Label
        AccUIAxes                       matlab.ui.control.UIAxes
        GyrUIAxes                       matlab.ui.control.UIAxes
    end
    
    % Propiedades que se corresponden con el MVC
    properties (Access = private) 
	    ControlObj % Controlador
	    ModelObj % Modelo
    end

    methods (Access = public)
        function app = ViewTurbine(GridLLayout, turbineObj)
            app.GridLayout = GridLLayout;
            app.ModelObj = turbineObj;

            % Función que crea y configura los componentes de la GUI
            createComponents(app);

            app.ControlObj = ControllerTurbine(app, app.ModelObj);
            app.addListeners(app.ControlObj);           
        end   

        function delete(app)
            app.ControlObj.deleteTimers();
        end

        % Añade listeners y muestra valores iniciales en la GUI
        function initView(app)
            app.ControlObj.initTurbineComponents();
            app.ComponentsGridLayout.Visible = 'on';
        end 

        function endView(app) 
            app.ControlObj.endTurbineComponents();
            app.ComponentsGridLayout.Visible = 'off';            
        end

        % Actualizaciones de la vista cuando el modelo avisa de que hay 
        % información nueva 
        function updateWeather(app) 
            app.TemperatureValueWeatherSchemaLabel.Text = string(app.ModelObj.WeatherTemp)+'º';
            app.HumidityValueWeatherSchemaLabel.Text = string(app.ModelObj.WeatherHum)+'%';
            app.PressureValueWeatherSchemaLabel.Text = string(app.ModelObj.WeatherPress)+'hPa';
            app.HeadingValueBaseSchemaLabel.Text = string(app.ModelObj.WeatherWindDir)+'º';
            app.HeadingValueWindSchemaLabel.Text = string(app.ModelObj.WeatherWindDir)+'º';
            if class(app.ModelObj) == 'ModelPrototype'
                app.SpeedValueWindSchemaLabel.Text = string(app.ModelObj.WeatherWindSpeed);
            end
        end

        function updateLastCommands(app)          
            if ~app.ModelObj.Mode % 0 modo auto
                 app.AutoModeCommandButton.BackgroundColor = app.ModePressedButtonColor;
                 app.ManualModeCommandButton.BackgroundColor = app.ModeNotPressedButtonColor;
            else % 1 modo manual
                app.AutoModeCommandButton.BackgroundColor = app.ModeNotPressedButtonColor;
                app.ManualModeCommandButton.BackgroundColor = app.ModePressedButtonColor;
            end

            app.PitchCommandField.Value = app.ModelObj.Pitch;

            app.LoadCommandField.Value = app.ModelObj.Load;

            app.EmergencyCommandButton.Value = app.ModelObj.Emergency;
            app.emergencyButtonColor();
        end
        
        % Actualizaciones de la vista cuando el modelo avisa de que hay 
        % información nueva 
        function updateState(app) 
            % Actividad del simulador
            if ~app.ModelObj.Activity
                app.StateLabel.Text = 'Disconnected';
                app.StateLabel.FontColor = [0.749 0.251 0.251];
                app.disableState();
            else
                app.StateLabel.Text = 'Connected';
                app.StateLabel.FontColor = [1 1 1];
                app.enableState();
                % Wind
                if class(app.ModelObj) == 'ModelSimulator'
                    app.SpeedValueWindSchemaLabel.Text = string(app.ModelObj.DataWind(end));  
                end
                % Pitch
                plot(app.PitchStateUIAxes, ...
                    app.ModelObj.TimeStamps, app.ModelObj.DataPitch, ...
                    'LineWidth', 2.0);
                app.PitchStateGauge.Value = app.ModelObj.DataPitch(end);
                % Load
                plot(app.LoadStateUIAxes, ...
                    app.ModelObj.TimeStamps, app.ModelObj.DataLoad, ...
                    'LineWidth', 2.0);
                app.LoadStateGauge.Value = app.ModelObj.DataLoad(end);
                % RPM
                plot(app.RPMStateUIAxes, ...
                    app.ModelObj.TimeStamps, app.ModelObj.DataRPM, ...
                    'LineWidth', 2.0);
                app.RPMStateGauge.Value = app.ModelObj.DataRPM(end);
                % Power
                plot(app.PowerStateUIAxes, ...
                    app.ModelObj.TimeStamps, app.ModelObj.DataPower, ...
                    'LineWidth', 2.0);   
                app.PowerStateGauge.Value = app.ModelObj.DataPower(end);
                % State
                %    
                %Stability
                if app.ModelObj.StabilityActivity  
                    plot(app.AccUIAxes, ...
                        app.ModelObj.StabilityTimeStamps, app.ModelObj.DataAx, ...
                        app.ModelObj.StabilityTimeStamps, app.ModelObj.DataAy, ...
                        app.ModelObj.StabilityTimeStamps, app.ModelObj.DataAz, ...
                        'LineWidth', 2.0);
                    plot(app.GyrUIAxes, ...
                        app.ModelObj.StabilityTimeStamps, app.ModelObj.DataGx, ...
                        app.ModelObj.StabilityTimeStamps, app.ModelObj.DataGy, ...
                        app.ModelObj.StabilityTimeStamps, app.ModelObj.DataGz, ...
                        'LineWidth', 2.0);
                end
            end               

            % Fecha y hora de la última actualización en el canal de
            % ThingSpeak
            app.UsetimeValueGeneralSchemaLabel.Text = datestr(app.ModelObj.LastUpdated);
        end
        
        % Riesgos
        function RPMRisk(app)          
            if app.ModelObj.RPMRiskLevel == 2
                app.RisksIndicator1.FontColor = app.YellowColor;
                app.RPMRisksLabel.Text = app.ModelObj.RPMRiskMsg(2);               
            elseif app.ModelObj.RPMRiskLevel == 3
                app.RisksIndicator1.FontColor = app.RedColor;
                app.RPMRisksLabel.Text = app.ModelObj.RPMRiskMsg(3);
            else
                app.RisksIndicator1.FontColor = app.GreenColor;
                app.RPMRisksLabel.Text = app.ModelObj.RPMRiskMsg(1);
            end
            app.RisksIndicator1.Visible = 'on';            
            app.RPMRisksLabel.Visible = 'on';
        end
        
        % Deshabilita escritura de comandos del usuario
        function disablePitchCommands(app)
            set(app.PitchCommandLabel,'Enable','off');
            set(app.PitchCommandField,'Enable','off');
            set(app.LessPitchCommandButton,'Enable','off');
            set(app.MorePitchCommandButton,'Enable','off');
            set(app.PitchCommandUpdateButton,'Enable','off');
        end

        function disableLoadCommands(app)
            set(app.LoadCommandLabel,'Enable','off');
            set(app.LoadCommandField,'Enable','off');
            set(app.LessLoadCommandButton,'Enable','off');
            set(app.MoreLoadCommandButton,'Enable','off');
            set(app.LoadCommandUpdateButton,'Enable','off');        
        end

        function disableCommands(app)
            % Mode
            set(app.AutoModeCommandButton,'Enable','off');
            set(app.ManualModeCommandButton,'Enable','off');
            % Pitch
            app.disablePitchCommands();
            % Load
            app.disableLoadCommands();
            % Stop
            set(app.EmergencyCommandButton,'Enable','off');
        end

        % Habilita escritura de comandos del usuario
        function enablePitchCommands(app)
            set(app.PitchCommandLabel,'Enable','on');
            set(app.PitchCommandField,'Enable','on');
            set(app.LessPitchCommandButton,'Enable','on');
            set(app.MorePitchCommandButton,'Enable','on');
            set(app.PitchCommandUpdateButton,'Enable','on');
        end

        function enableLoadCommands(app)
            set(app.LoadCommandLabel,'Enable','on');
            set(app.LoadCommandField,'Enable','on');
            set(app.LessLoadCommandButton,'Enable','on');
            set(app.MoreLoadCommandButton,'Enable','on');
            set(app.LoadCommandUpdateButton,'Enable','on');
        end

        function enableCommands(app)
            % Mode
            set(app.AutoModeCommandButton,'Enable','on');
            set(app.ManualModeCommandButton,'Enable','on');
            % Stop
            set(app.EmergencyCommandButton,'Enable','on');
            % Habilita comandos de pitch y carga solo si estamos en modo
            % manual
            if app.ModelObj.Mode % mode 1 manual
                app.enablePitchCommands();
                app.enableLoadCommands();
            end
        end
        
        % Deshabilita state
        function disableState(app)
            app.PitchStateGauge.Enable = 'off';
            app.LoadStateGauge.Enable = 'off';
            app.RPMStateGauge.Enable = 'off';
            app.PowerStateGauge.Enable = 'off';
        end
        
        % Habilita state
        function enableState(app)
            app.PitchStateGauge.Enable = 'on';
            app.LoadStateGauge.Enable = 'on';
            app.RPMStateGauge.Enable = 'on';
            app.PowerStateGauge.Enable = 'on';
        end
    end
        
    methods (Access = private)

	    % Crea UIFigure y sus componentes
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create ComponentsGridLayout
            app.ComponentsGridLayout = uigridlayout(app.GridLayout);
            app.ComponentsGridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x'};
            app.ComponentsGridLayout.RowHeight = {'1x', '1x', '1x'};
            app.ComponentsGridLayout.ColumnSpacing = 25;
            app.ComponentsGridLayout.RowSpacing = 25;
            app.ComponentsGridLayout.Padding = [0 0 0 0];
            app.ComponentsGridLayout.Layout.Row = 2;
            app.ComponentsGridLayout.Layout.Column = 2;
            app.ComponentsGridLayout.BackgroundColor = [0.102 0.102 0.102];

            % Create WindPanel
            app.WindPanel = uipanel(app.ComponentsGridLayout);
            app.WindPanel.ForegroundColor = [1 1 1];
            app.WindPanel.BorderType = 'none';
            app.WindPanel.BackgroundColor = [0.2 0.2 0.2];
            app.WindPanel.Layout.Row = 3;
            app.WindPanel.Layout.Column = [1 2];
            app.WindPanel.FontName = '.AppleSystemUIFont';
            app.WindPanel.FontWeight = 'bold';
            app.WindPanel.FontSize = 16;

            % Create StabilityGridLayout
            app.StabilityGridLayout = uigridlayout(app.WindPanel);
            app.StabilityGridLayout.RowHeight = {30, '1x'};
            app.StabilityGridLayout.Padding = [20 20 20 20];
            app.StabilityGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create AccUIAxes
            app.AccUIAxes = uiaxes(app.StabilityGridLayout);
            ylabel(app.AccUIAxes, 'Acceleration')
            %app.AccUIAxes.FontName = '.AppleSystemUIFont';
            app.AccUIAxes.XColor = [1 1 1];
            app.AccUIAxes.YColor = [1 1 1];
            app.AccUIAxes.ZColor = [0 0 0];
            app.AccUIAxes.Color = 'none';
            app.AccUIAxes.ColorOrder = [app.RedColor; app.GreenColor; app.BlueColor];
            app.AccUIAxes.Layout.Row = 2;
            app.AccUIAxes.Layout.Column = 1;

            % Create GyrUIAxes
            app.GyrUIAxes = uiaxes(app.StabilityGridLayout);
            ylabel(app.GyrUIAxes, 'Gyroscope')
            app.GyrUIAxes.FontName = '.AppleSystemUIFont';
            app.GyrUIAxes.XColor = [1 1 1];
            app.GyrUIAxes.YColor = [1 1 1];
            app.GyrUIAxes.ZColor = [0 0 0];
            app.GyrUIAxes.Color = 'none';
            app.GyrUIAxes.ColorOrder = [app.RedColor; app.GreenColor; app.BlueColor];
            app.GyrUIAxes.TitleFontWeight = 'normal';
            app.GyrUIAxes.Layout.Row = 2;
            app.GyrUIAxes.Layout.Column = 2;

            % Create StabilityLabel
            app.StabilityLabel = uilabel(app.StabilityGridLayout);
            app.StabilityLabel.FontName = '.AppleSystemUIFont';
            app.StabilityLabel.FontSize = 24;
            app.StabilityLabel.FontWeight = 'bold';
            app.StabilityLabel.FontColor = [1 1 1];
            app.StabilityLabel.Layout.Row = 1;
            app.StabilityLabel.Layout.Column = 1;
            app.StabilityLabel.Text = 'Stability';

            % Create RisksPanel
            app.RisksPanel = uipanel(app.ComponentsGridLayout);
            app.RisksPanel.ForegroundColor = [1 1 1];
            app.RisksPanel.BorderType = 'none';
            app.RisksPanel.BackgroundColor = [0.2 0.2 0.2];
            app.RisksPanel.Layout.Row = 3;
            app.RisksPanel.Layout.Column = 3;
            app.RisksPanel.FontName = '.AppleSystemUIFont';
            app.RisksPanel.FontWeight = 'bold';
            app.RisksPanel.FontSize = 16;

            % Create RisksGridLayout
            app.RisksGridLayout = uigridlayout(app.RisksPanel);
            app.RisksGridLayout.ColumnWidth = {'1x', 30};
            app.RisksGridLayout.RowHeight = {30, 20, 20, 20};
            app.RisksGridLayout.Padding = [20 20 20 20];
            app.RisksGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create RisksIndicator1
            app.RisksIndicator1 = uilabel(app.RisksGridLayout);
            app.RisksIndicator1.Interpreter = 'html';
            app.RisksIndicator1.HorizontalAlignment = 'center';
            app.RisksIndicator1.FontName = 'Arial';
            app.RisksIndicator1.FontSize = 32;
            app.RisksIndicator1.FontColor = [0.251 0.749 0.251];
            app.RisksIndicator1.Layout.Row = 2;
            app.RisksIndicator1.Layout.Column = 2;
            app.RisksIndicator1.Text = '&#9679;';
            app.RisksIndicator1.Visible = 'off';

            % Create RisksLabel
            app.RPMRisksLabel = uilabel(app.RisksGridLayout);
            app.RPMRisksLabel.FontName = '.AppleSystemUIFont';
            app.RPMRisksLabel.FontSize = 14;
            app.RPMRisksLabel.FontColor = [1 1 1];
            app.RPMRisksLabel.Layout.Row = 2;
            app.RPMRisksLabel.Layout.Column = 1;
            app.RPMRisksLabel.Visible = 'off';

            % Create RisksLabel
            app.RisksLabel = uilabel(app.RisksGridLayout);
            app.RisksLabel.FontName = '.AppleSystemUIFont';
            app.RisksLabel.FontSize = 24;
            app.RisksLabel.FontWeight = 'bold';
            app.RisksLabel.FontColor = [1 1 1];
            app.RisksLabel.Layout.Row = 1;
            app.RisksLabel.Layout.Column = 1;
            app.RisksLabel.Text = 'Risks';

            % Create StatePanel
            app.StatePanel = uipanel(app.ComponentsGridLayout);
            app.StatePanel.ForegroundColor = [1 1 1];
            app.StatePanel.BorderType = 'none';
            app.StatePanel.BackgroundColor = [0.2 0.2 0.2];
            app.StatePanel.Layout.Row = [1 3];
            app.StatePanel.Layout.Column = [4 6];
            app.StatePanel.FontWeight = 'bold';
            app.StatePanel.FontSize = 16;

            % Create StateGridLayout
            app.StateGridLayout = uigridlayout(app.StatePanel);
            app.StateGridLayout.ColumnWidth = {150, '1x'};
            app.StateGridLayout.RowHeight = {30, '1x', '1x', '1x', '1x'};
            app.StateGridLayout.Padding = [20 20 20 20];
            app.StateGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create PowerStateUIAxes
            app.PowerStateUIAxes = uiaxes(app.StateGridLayout);
            ylabel(app.PowerStateUIAxes, 'Power')
            %app.PowerStateUIAxes.FontName = '.AppleSystemUIFont';
            app.PowerStateUIAxes.YLim = app.ModelObj.PowerLimits;
            app.PowerStateUIAxes.XColor = [1 1 1];
            app.PowerStateUIAxes.YColor = [1 1 1];
            app.PowerStateUIAxes.ZColor = [0 0 0];
            app.PowerStateUIAxes.Color = 'none';
            app.PowerStateUIAxes.Layout.Row = 5;
            app.PowerStateUIAxes.Layout.Column = 2;

            % Create RPMStateUIAxes
            app.RPMStateUIAxes = uiaxes(app.StateGridLayout);
            ylabel(app.RPMStateUIAxes, 'RPM')
            app.RPMStateUIAxes.FontName = '.AppleSystemUIFont';
            app.RPMStateUIAxes.YLim = app.ModelObj.RPMLimits;
            app.RPMStateUIAxes.XColor = [1 1 1];
            app.RPMStateUIAxes.YColor = [1 1 1];
            app.RPMStateUIAxes.ZColor = [0 0 0];
            app.RPMStateUIAxes.Color = 'none';
            app.RPMStateUIAxes.Layout.Row = 4;
            app.RPMStateUIAxes.Layout.Column = 2;

            % Create LoadStateUIAxes
            app.LoadStateUIAxes = uiaxes(app.StateGridLayout);
            ylabel(app.LoadStateUIAxes, 'Load')
            app.LoadStateUIAxes.FontName = '.AppleSystemUIFont';
            app.LoadStateUIAxes.YLim = app.ModelObj.LoadLimits;
            app.LoadStateUIAxes.XColor = [1 1 1];
            app.LoadStateUIAxes.YColor = [1 1 1];
            app.LoadStateUIAxes.ZColor = [0 0 0];
            app.LoadStateUIAxes.Color = 'none';
            app.LoadStateUIAxes.Layout.Row = 3;
            app.LoadStateUIAxes.Layout.Column = 2;

            % Create PitchStateUIAxes
            app.PitchStateUIAxes = uiaxes(app.StateGridLayout);
            ylabel(app.PitchStateUIAxes, 'Pitch')
            app.PitchStateUIAxes.FontName = '.AppleSystemUIFont';
            app.PitchStateUIAxes.YLim = app.ModelObj.PitchLimits;
            app.PitchStateUIAxes.YTick = [0 15 30 45 60 75 90];
            app.PitchStateUIAxes.XColor = [1 1 1];
            app.PitchStateUIAxes.YColor = [1 1 1];
            app.PitchStateUIAxes.ZColor = [0 0 0];
            app.PitchStateUIAxes.Color = 'none';
            app.PitchStateUIAxes.TitleFontWeight = 'normal';
            app.PitchStateUIAxes.Layout.Row = 2;
            app.PitchStateUIAxes.Layout.Column = 2;

            % Create PowerStateGridLayout
            app.PowerStateGridLayout = uigridlayout(app.StateGridLayout);
            app.PowerStateGridLayout.ColumnWidth = {'1x'};
            app.PowerStateGridLayout.RowHeight = {'1x'};
            app.PowerStateGridLayout.Padding = [0 10 0 10];
            app.PowerStateGridLayout.Layout.Row = 5;
            app.PowerStateGridLayout.Layout.Column = 1;
            app.PowerStateGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create PowerStateGauge
            app.PowerStateGauge = uigauge(app.PowerStateGridLayout, 'circular');
            app.PowerStateGauge.Limits = app.ModelObj.PowerLimits;
            app.PowerStateGauge.BackgroundColor = [0.302 0.302 0.302];
            app.PowerStateGauge.FontName = '.AppleSystemUIFont';
            app.PowerStateGauge.FontColor = [1 1 1];
            app.PowerStateGauge.Layout.Row = 1;
            app.PowerStateGauge.Layout.Column = 1;

            % Create RPMStateGridLayout
            app.RPMStateGridLayout = uigridlayout(app.StateGridLayout);
            app.RPMStateGridLayout.ColumnWidth = {'1x'};
            app.RPMStateGridLayout.RowHeight = {'1x'};
            app.RPMStateGridLayout.Padding = [0 10 0 10];
            app.RPMStateGridLayout.Layout.Row = 4;
            app.RPMStateGridLayout.Layout.Column = 1;
            app.RPMStateGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create RPMStateGauge
            app.RPMStateGauge = uigauge(app.RPMStateGridLayout, 'circular');
            app.RPMStateGauge.Limits = app.ModelObj.RPMLimits;
            app.RPMStateGauge.BackgroundColor = [0.302 0.302 0.302];
            app.RPMStateGauge.FontName = '.AppleSystemUIFont';
            app.RPMStateGauge.FontColor = [1 1 1];
            app.RPMStateGauge.Layout.Row = 1;
            app.RPMStateGauge.Layout.Column = 1;

            % Create LoadStateGridLayout
            app.LoadStateGridLayout = uigridlayout(app.StateGridLayout);
            app.LoadStateGridLayout.ColumnWidth = {'1x'};
            app.LoadStateGridLayout.RowHeight = {'1x'};
            app.LoadStateGridLayout.Padding = [0 10 0 10];
            app.LoadStateGridLayout.Layout.Row = 3;
            app.LoadStateGridLayout.Layout.Column = 1;
            app.LoadStateGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create LoadStateGauge
            app.LoadStateGauge = uigauge(app.LoadStateGridLayout, 'linear');
            app.LoadStateGauge.Limits = app.ModelObj.LoadLimits;
            app.LoadStateGauge.MajorTicks = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
            app.LoadStateGauge.Orientation = 'vertical';
            app.LoadStateGauge.BackgroundColor = [0.302 0.302 0.302];
            app.LoadStateGauge.FontName = '.AppleSystemUIFont';
            app.LoadStateGauge.FontColor = [1 1 1];
            app.LoadStateGauge.Layout.Row = 1;
            app.LoadStateGauge.Layout.Column = 1;

            % Create PitchStateGridLayout
            app.PitchStateGridLayout = uigridlayout(app.StateGridLayout);
            app.PitchStateGridLayout.ColumnWidth = {'1x'};
            app.PitchStateGridLayout.RowHeight = {'1x'};
            app.PitchStateGridLayout.Padding = [0 10 0 10];
            app.PitchStateGridLayout.Layout.Row = 2;
            app.PitchStateGridLayout.Layout.Column = 1;
            app.PitchStateGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create PitchStateGauge
            app.PitchStateGauge = uigauge(app.PitchStateGridLayout, 'ninetydegree');
            app.PitchStateGauge.Limits = [0 90];
            app.PitchStateGauge.ScaleDirection = 'counterclockwise';
            app.PitchStateGauge.BackgroundColor = [0.302 0.302 0.302];
            app.PitchStateGauge.FontName = '.AppleSystemUIFont';
            app.PitchStateGauge.FontColor = [1 1 1];
            app.PitchStateGauge.Layout.Row = 1;
            app.PitchStateGauge.Layout.Column = 1;

            % Create StateLabel
            app.StateLabel = uilabel(app.StateGridLayout);
            app.StateLabel.FontName = '.AppleSystemUIFont';
            app.StateLabel.FontSize = 24;
            app.StateLabel.FontWeight = 'bold';
            app.StateLabel.FontColor = [1 1 1];
            app.StateLabel.Layout.Row = 1;
            app.StateLabel.Layout.Column = [1 2];
            app.StateLabel.Text = 'State';

            % Create CommandsPanel
            app.CommandsPanel = uipanel(app.ComponentsGridLayout);
            app.CommandsPanel.ForegroundColor = [1 1 1];
            app.CommandsPanel.BorderType = 'none';
            app.CommandsPanel.BackgroundColor = [0.251 0.251 0.251];
            app.CommandsPanel.Layout.Row = [1 2];
            app.CommandsPanel.Layout.Column = 3;
            app.CommandsPanel.FontName = '.AppleSystemUIFont';
            app.CommandsPanel.FontWeight = 'bold';
            app.CommandsPanel.FontSize = 16;

            % Create CommandsGridLayout
            app.CommandsGridLayout = uigridlayout(app.CommandsPanel);
            app.CommandsGridLayout.ColumnWidth = {'1x'};
            app.CommandsGridLayout.RowHeight = {30, 30, '1x', 100, '1x', 100, '1x', 30};
            app.CommandsGridLayout.ColumnSpacing = 20;
            app.CommandsGridLayout.RowSpacing = 20;
            app.CommandsGridLayout.Padding = [20 20 20 20];
            app.CommandsGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create LoadCommandGridLayout
            app.LoadCommandGridLayout = uigridlayout(app.CommandsGridLayout);
            app.LoadCommandGridLayout.ColumnWidth = {30, '1x', 30};
            app.LoadCommandGridLayout.RowHeight = {20, 30, 30};
            app.LoadCommandGridLayout.Padding = [0 0 0 0];
            app.LoadCommandGridLayout.Layout.Row = 6;
            app.LoadCommandGridLayout.Layout.Column = 1;
            app.LoadCommandGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create LoadCommandUpdateButton
            app.LoadCommandUpdateButton = uibutton(app.LoadCommandGridLayout, 'push');
            app.LoadCommandUpdateButton.BackgroundColor = [0.302 0.302 0.302];
            app.LoadCommandUpdateButton.FontName = '.AppleSystemUIFont';
            app.LoadCommandUpdateButton.FontWeight = 'bold';
            app.LoadCommandUpdateButton.FontColor = [1 1 1];
            app.LoadCommandUpdateButton.Layout.Row = 3;
            app.LoadCommandUpdateButton.Layout.Column = [1 3];
            app.LoadCommandUpdateButton.Text = 'Update';

            % Create MoreLoadCommandButton
            app.MoreLoadCommandButton = uibutton(app.LoadCommandGridLayout, 'push');
            app.MoreLoadCommandButton.IconAlignment = 'center';
            app.MoreLoadCommandButton.VerticalAlignment = 'top';
            app.MoreLoadCommandButton.BackgroundColor = [0.302 0.302 0.302];
            app.MoreLoadCommandButton.FontName = '.AppleSystemUIFont';
            app.MoreLoadCommandButton.FontSize = 16;
            app.MoreLoadCommandButton.FontWeight = 'bold';
            app.MoreLoadCommandButton.FontColor = [1 1 1];
            app.MoreLoadCommandButton.Layout.Row = 2;
            app.MoreLoadCommandButton.Layout.Column = 3;
            app.MoreLoadCommandButton.Text = '+';

            % Create LessLoadCommandButton
            app.LessLoadCommandButton = uibutton(app.LoadCommandGridLayout, 'push');
            app.LessLoadCommandButton.IconAlignment = 'center';
            app.LessLoadCommandButton.VerticalAlignment = 'top';
            app.LessLoadCommandButton.BackgroundColor = [0.302 0.302 0.302];
            app.LessLoadCommandButton.FontName = '.AppleSystemUIFont';
            app.LessLoadCommandButton.FontSize = 16;
            app.LessLoadCommandButton.FontWeight = 'bold';
            app.LessLoadCommandButton.FontColor = [1 1 1];
            app.LessLoadCommandButton.Layout.Row = 2;
            app.LessLoadCommandButton.Layout.Column = 1;
            app.LessLoadCommandButton.Text = '-';

            % Create LoadCommandField
            app.LoadCommandField = uieditfield(app.LoadCommandGridLayout, 'numeric');
            app.LoadCommandField.Limits = app.ModelObj.LoadLimits;
            app.LoadCommandField.ValueDisplayFormat = '%d';
            app.LoadCommandField.HorizontalAlignment = 'center';
            app.LoadCommandField.FontName = '.AppleSystemUIFont';
            app.LoadCommandField.FontWeight = 'bold';
            app.LoadCommandField.FontColor = [1 1 1];
            app.LoadCommandField.BackgroundColor = [0.2 0.2 0.2];
            app.LoadCommandField.Layout.Row = 2;
            app.LoadCommandField.Layout.Column = 2;

            % Create LoadCommandLabel
            app.LoadCommandLabel = uilabel(app.LoadCommandGridLayout);
            app.LoadCommandLabel.FontName = '.AppleSystemUIFont';
            app.LoadCommandLabel.FontSize = 16;
            app.LoadCommandLabel.FontWeight = 'bold';
            app.LoadCommandLabel.FontColor = [1 1 1];
            app.LoadCommandLabel.Layout.Row = 1;
            app.LoadCommandLabel.Layout.Column = [1 3];
            app.LoadCommandLabel.Text = 'Load';

            % Create PitchCommandGridLayout
            app.PitchCommandGridLayout = uigridlayout(app.CommandsGridLayout);
            app.PitchCommandGridLayout.ColumnWidth = {30, '1x', 30};
            app.PitchCommandGridLayout.RowHeight = {20, 30, 30};
            app.PitchCommandGridLayout.Padding = [0 0 0 0];
            app.PitchCommandGridLayout.Layout.Row = 4;
            app.PitchCommandGridLayout.Layout.Column = 1;
            app.PitchCommandGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create MorePitchCommandButton
            app.MorePitchCommandButton = uibutton(app.PitchCommandGridLayout, 'push');
            app.MorePitchCommandButton.IconAlignment = 'center';
            app.MorePitchCommandButton.VerticalAlignment = 'top';
            app.MorePitchCommandButton.BackgroundColor = [0.302 0.302 0.302];
            app.MorePitchCommandButton.FontName = '.AppleSystemUIFont';
            app.MorePitchCommandButton.FontSize = 16;
            app.MorePitchCommandButton.FontWeight = 'bold';
            app.MorePitchCommandButton.FontColor = [1 1 1];
            app.MorePitchCommandButton.Layout.Row = 2;
            app.MorePitchCommandButton.Layout.Column = 3;
            app.MorePitchCommandButton.Text = '+';

            % Create PitchCommandField
            app.PitchCommandField = uieditfield(app.PitchCommandGridLayout, 'numeric');
            app.PitchCommandField.Limits = app.ModelObj.PitchLimits;
            app.PitchCommandField.ValueDisplayFormat = '%5.1fº';
            app.PitchCommandField.HorizontalAlignment = 'center';
            app.PitchCommandField.FontName = '.AppleSystemUIFont';
            app.PitchCommandField.FontWeight = 'bold';
            app.PitchCommandField.FontColor = [1 1 1];
            app.PitchCommandField.BackgroundColor = [0.2 0.2 0.2];
            app.PitchCommandField.Layout.Row = 2;
            app.PitchCommandField.Layout.Column = 2;

            % Create PitchCommandLabel
            app.PitchCommandLabel = uilabel(app.PitchCommandGridLayout);
            app.PitchCommandLabel.FontName = '.AppleSystemUIFont';
            app.PitchCommandLabel.FontSize = 16;
            app.PitchCommandLabel.FontWeight = 'bold';
            app.PitchCommandLabel.FontColor = [1 1 1];
            app.PitchCommandLabel.Layout.Row = 1;
            app.PitchCommandLabel.Layout.Column = [1 3];
            app.PitchCommandLabel.Text = 'Pitch';

            % Create PitchCommandUpdateButton
            app.PitchCommandUpdateButton = uibutton(app.PitchCommandGridLayout, 'push');
            app.PitchCommandUpdateButton.BackgroundColor = [0.302 0.302 0.302];
            app.PitchCommandUpdateButton.FontName = '.AppleSystemUIFont';
            app.PitchCommandUpdateButton.FontWeight = 'bold';
            app.PitchCommandUpdateButton.FontColor = [1 1 1];
            app.PitchCommandUpdateButton.Layout.Row = 3;
            app.PitchCommandUpdateButton.Layout.Column = [1 3];
            app.PitchCommandUpdateButton.Text = 'Update';

            % Create LessPitchCommandButton
            app.LessPitchCommandButton = uibutton(app.PitchCommandGridLayout, 'push');
            app.LessPitchCommandButton.IconAlignment = 'center';
            app.LessPitchCommandButton.VerticalAlignment = 'top';
            app.LessPitchCommandButton.BackgroundColor = [0.302 0.302 0.302];
            app.LessPitchCommandButton.FontName = '.AppleSystemUIFont';
            app.LessPitchCommandButton.FontSize = 16;
            app.LessPitchCommandButton.FontWeight = 'bold';
            app.LessPitchCommandButton.FontColor = [1 1 1];
            app.LessPitchCommandButton.Layout.Row = 2;
            app.LessPitchCommandButton.Layout.Column = 1;
            app.LessPitchCommandButton.Text = '-';

            % Create ModeCommandGridLayout
            app.ModeCommandGridLayout = uigridlayout(app.CommandsGridLayout);
            app.ModeCommandGridLayout.RowHeight = {30};
            app.ModeCommandGridLayout.Padding = [0 0 0 0];
            app.ModeCommandGridLayout.Layout.Row = 2;
            app.ModeCommandGridLayout.Layout.Column = 1;
            app.ModeCommandGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create ManualModeCommandButton
            app.ManualModeCommandButton = uibutton(app.ModeCommandGridLayout, 'push');
            app.ManualModeCommandButton.BackgroundColor = [0.2 0.2 0.2];
            app.ManualModeCommandButton.FontName = '.AppleSystemUIFont';
            app.ManualModeCommandButton.FontWeight = 'bold';
            app.ManualModeCommandButton.FontColor = [1 1 1];
            app.ManualModeCommandButton.Layout.Row = 1;
            app.ManualModeCommandButton.Layout.Column = 2;
            app.ManualModeCommandButton.Text = 'Manual';

            % Create AutoModeCommandButton
            app.AutoModeCommandButton = uibutton(app.ModeCommandGridLayout, 'push');
            app.AutoModeCommandButton.BackgroundColor = [0.302 0.302 0.302];
            app.AutoModeCommandButton.FontName = '.AppleSystemUIFont';
            app.AutoModeCommandButton.FontWeight = 'bold';
            app.AutoModeCommandButton.FontColor = [1 1 1];
            app.AutoModeCommandButton.Layout.Row = 1;
            app.AutoModeCommandButton.Layout.Column = 1;
            app.AutoModeCommandButton.Text = 'Auto';

            % Create EmergencyCommandButton
            app.EmergencyCommandButton = uibutton(app.CommandsGridLayout, 'state');
            app.EmergencyCommandButton.BackgroundColor = [0.749 0.251 0.251];
            app.EmergencyCommandButton.FontName = '.AppleSystemUIFont';
            app.EmergencyCommandButton.FontWeight = 'bold';
            app.EmergencyCommandButton.FontColor = [1 1 1];
            app.EmergencyCommandButton.Layout.Row = 8;
            app.EmergencyCommandButton.Layout.Column = 1;
            app.EmergencyCommandButton.Text = 'EMERGENCY STOP';

            % Create CommandsLabel
            app.CommandsLabel = uilabel(app.CommandsGridLayout);
            app.CommandsLabel.FontName = '.AppleSystemUIFont';
            app.CommandsLabel.FontSize = 24;
            app.CommandsLabel.FontWeight = 'bold';
            app.CommandsLabel.FontColor = [1 1 1];
            app.CommandsLabel.Layout.Row = 1;
            app.CommandsLabel.Layout.Column = 1;
            app.CommandsLabel.Text = 'Commands';

            % Create SchemaPanel
            app.SchemaPanel = uipanel(app.ComponentsGridLayout);
            app.SchemaPanel.ForegroundColor = [0.102 0.102 0.102];
            app.SchemaPanel.BorderType = 'none';
            app.SchemaPanel.BackgroundColor = [0.102 0.102 0.102];
            app.SchemaPanel.Layout.Row = [1 2];
            app.SchemaPanel.Layout.Column = [1 2];
            app.SchemaPanel.FontWeight = 'bold';
            app.SchemaPanel.FontSize = 16;

            % Create SchemaGridLayout
            app.SchemaGridLayout = uigridlayout(app.SchemaPanel);
            app.SchemaGridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.SchemaGridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.SchemaGridLayout.ColumnSpacing = 0;
            app.SchemaGridLayout.RowSpacing = 0;
            app.SchemaGridLayout.Padding = [0 0 0 0];
            app.SchemaGridLayout.BackgroundColor = [0.102 0.102 0.102];

            % Create TurbineImage
            app.TurbineImage = uiimage(app.SchemaGridLayout);
            app.TurbineImage.Layout.Row = [1 18];
            app.TurbineImage.Layout.Column = [1 17];
            app.TurbineImage.ImageSource = fullfile(pathToMLAPP, 'resources/turbine.png');

            % Create BaseSchemaPanel
            app.WavesSchemaPanel = uipanel(app.SchemaGridLayout);
            app.WavesSchemaPanel.ForegroundColor = [1 1 1];
            app.WavesSchemaPanel.BorderType = 'none';
            app.WavesSchemaPanel.Title = 'Waves';
            app.WavesSchemaPanel.BackgroundColor = [0.2 0.2 0.2];
            app.WavesSchemaPanel.Layout.Row = [17 18];
            app.WavesSchemaPanel.Layout.Column = [9 14];
            app.WavesSchemaPanel.FontName = '.AppleSystemUIFont';
            app.WavesSchemaPanel.FontWeight = 'bold';

            % Create BaseSchemaGridLayout
            app.WavesSchemaGridLayout = uigridlayout(app.WavesSchemaPanel);
            app.WavesSchemaGridLayout.ColumnWidth = {'1.5x', '1x'};
            app.WavesSchemaGridLayout.RowHeight = {'1x', 14, '1x', 14, '1x'};
            app.WavesSchemaGridLayout.ColumnSpacing = 5;
            app.WavesSchemaGridLayout.RowSpacing = 1;
            app.WavesSchemaGridLayout.Padding = [5 5 5 1];
            app.WavesSchemaGridLayout.BackgroundColor = [0.302 0.302 0.302];

            % Create SeaWindValueBaseSchemaLabel
            app.WaveHeightValueBaseSchemaLabel = uilabel(app.WavesSchemaGridLayout);
            app.WaveHeightValueBaseSchemaLabel.FontName = '.AppleSystemUIFont';
            app.WaveHeightValueBaseSchemaLabel.FontColor = [1 1 1];
            app.WaveHeightValueBaseSchemaLabel.Layout.Row = 4;
            app.WaveHeightValueBaseSchemaLabel.Layout.Column = 2;
            app.WaveHeightValueBaseSchemaLabel.Text = '4';

            % Create SeaWindBaseSchemaLabel
            app.WaveHeightBaseSchemaLabel = uilabel(app.WavesSchemaGridLayout);
            app.WaveHeightBaseSchemaLabel.FontName = '.AppleSystemUIFont';
            app.WaveHeightBaseSchemaLabel.FontColor = [1 1 1];
            app.WaveHeightBaseSchemaLabel.Layout.Row = 4;
            app.WaveHeightBaseSchemaLabel.Layout.Column = 1;
            app.WaveHeightBaseSchemaLabel.Text = 'Mean height';

            % Create HeadingValueBaseSchemaLabel
            app.HeadingValueBaseSchemaLabel = uilabel(app.WavesSchemaGridLayout);
            app.HeadingValueBaseSchemaLabel.FontName = '.AppleSystemUIFont';
            app.HeadingValueBaseSchemaLabel.FontColor = [1 1 1];
            app.HeadingValueBaseSchemaLabel.Layout.Row = 2;
            app.HeadingValueBaseSchemaLabel.Layout.Column = 2;

            % Create HeadingBaseSchemaLabel
            app.HeadingBaseSchemaLabel = uilabel(app.WavesSchemaGridLayout);
            app.HeadingBaseSchemaLabel.FontName = '.AppleSystemUIFont';
            app.HeadingBaseSchemaLabel.FontColor = [1 1 1];
            app.HeadingBaseSchemaLabel.Layout.Row = 2;
            app.HeadingBaseSchemaLabel.Layout.Column = 1;
            app.HeadingBaseSchemaLabel.Text = 'Direction';

            % Create WeatherSchemaPanel
            app.WeatherSchemaPanel = uipanel(app.SchemaGridLayout);
            app.WeatherSchemaPanel.ForegroundColor = [1 1 1];
            app.WeatherSchemaPanel.BorderType = 'none';
            app.WeatherSchemaPanel.Title = 'Weather';
            app.WeatherSchemaPanel.BackgroundColor = [0.2 0.2 0.2];
            app.WeatherSchemaPanel.Layout.Row = [2 4];
            app.WeatherSchemaPanel.Layout.Column = [12 17];
            app.WeatherSchemaPanel.FontName = '.AppleSystemUIFont';
            app.WeatherSchemaPanel.FontWeight = 'bold';

            % Create WeatherSchemaGridLayout
            app.WeatherSchemaGridLayout = uigridlayout(app.WeatherSchemaPanel);
            app.WeatherSchemaGridLayout.ColumnWidth = {'1.33x', '1x'};
            app.WeatherSchemaGridLayout.RowHeight = {'1x', 14, '1x', 14, '1x', 14, '1x'};
            app.WeatherSchemaGridLayout.ColumnSpacing = 5;
            app.WeatherSchemaGridLayout.RowSpacing = 1;
            app.WeatherSchemaGridLayout.Padding = [5 5 5 1];
            app.WeatherSchemaGridLayout.BackgroundColor = [0.302 0.302 0.302];

            % Create PressureValueWeatherSchemaLabel
            app.PressureValueWeatherSchemaLabel = uilabel(app.WeatherSchemaGridLayout);
            app.PressureValueWeatherSchemaLabel.FontName = '.AppleSystemUIFont';
            app.PressureValueWeatherSchemaLabel.FontColor = [1 1 1];
            app.PressureValueWeatherSchemaLabel.Layout.Row = 6;
            app.PressureValueWeatherSchemaLabel.Layout.Column = 2;

            % Create PressureWeatherSchemaLabel
            app.PressureWeatherSchemaLabel = uilabel(app.WeatherSchemaGridLayout);
            app.PressureWeatherSchemaLabel.FontName = '.AppleSystemUIFont';
            app.PressureWeatherSchemaLabel.FontColor = [1 1 1];
            app.PressureWeatherSchemaLabel.Layout.Row = 6;
            app.PressureWeatherSchemaLabel.Layout.Column = 1;
            app.PressureWeatherSchemaLabel.Text = 'Pressure';

            % Create HumidityValueWeatherSchemaLabel
            app.HumidityValueWeatherSchemaLabel = uilabel(app.WeatherSchemaGridLayout);
            app.HumidityValueWeatherSchemaLabel.FontName = '.AppleSystemUIFont';
            app.HumidityValueWeatherSchemaLabel.FontColor = [1 1 1];
            app.HumidityValueWeatherSchemaLabel.Layout.Row = 4;
            app.HumidityValueWeatherSchemaLabel.Layout.Column = 2;

            % Create HumidityWeatherSchemaLabel
            app.HumidityWeatherSchemaLabel = uilabel(app.WeatherSchemaGridLayout);
            app.HumidityWeatherSchemaLabel.FontName = '.AppleSystemUIFont';
            app.HumidityWeatherSchemaLabel.FontColor = [1 1 1];
            app.HumidityWeatherSchemaLabel.Layout.Row = 4;
            app.HumidityWeatherSchemaLabel.Layout.Column = 1;
            app.HumidityWeatherSchemaLabel.Text = 'Humidity';

            % Create TemperatureValueWeatherSchemaLabel
            app.TemperatureValueWeatherSchemaLabel = uilabel(app.WeatherSchemaGridLayout);
            app.TemperatureValueWeatherSchemaLabel.FontName = '.AppleSystemUIFont';
            app.TemperatureValueWeatherSchemaLabel.FontColor = [1 1 1];
            app.TemperatureValueWeatherSchemaLabel.Layout.Row = 2;
            app.TemperatureValueWeatherSchemaLabel.Layout.Column = 2;

            % Create TemperatureWeatherSchemaLabel
            app.TemperatureWeatherSchemaLabel = uilabel(app.WeatherSchemaGridLayout);
            app.TemperatureWeatherSchemaLabel.FontName = '.AppleSystemUIFont';
            app.TemperatureWeatherSchemaLabel.FontColor = [1 1 1];
            app.TemperatureWeatherSchemaLabel.Layout.Row = 2;
            app.TemperatureWeatherSchemaLabel.Layout.Column = 1;
            app.TemperatureWeatherSchemaLabel.Text = 'Temperature';

            % Create GeneralSchemaPanel
            app.GeneralSchemaPanel = uipanel(app.SchemaGridLayout);
            app.GeneralSchemaPanel.ForegroundColor = [1 1 1];
            app.GeneralSchemaPanel.BorderType = 'none';
            app.GeneralSchemaPanel.Title = 'General';
            app.GeneralSchemaPanel.BackgroundColor = [0.2 0.2 0.2];
            app.GeneralSchemaPanel.Layout.Row = [1 3];
            app.GeneralSchemaPanel.Layout.Column = [1 9];
            app.GeneralSchemaPanel.FontName = '.AppleSystemUIFont';
            app.GeneralSchemaPanel.FontWeight = 'bold';

            % Create GeneralSchemaGridLayout
            app.GeneralSchemaGridLayout = uigridlayout(app.GeneralSchemaPanel);
            app.GeneralSchemaGridLayout.ColumnWidth = {'1x', '2x'};
            app.GeneralSchemaGridLayout.RowHeight = {'1x', 14, '1x', 14, '1x', 14, '1x'};
            app.GeneralSchemaGridLayout.ColumnSpacing = 5;
            app.GeneralSchemaGridLayout.RowSpacing = 1;
            app.GeneralSchemaGridLayout.Padding = [5 5 5 1];
            app.GeneralSchemaGridLayout.BackgroundColor = [0.302 0.302 0.302];

            % Create UsetimeValueGeneralSchemaLabel
            app.UsetimeValueGeneralSchemaLabel = uilabel(app.GeneralSchemaGridLayout);
            app.UsetimeValueGeneralSchemaLabel.FontName = '.AppleSystemUIFont';
            app.UsetimeValueGeneralSchemaLabel.FontColor = [1 1 1];
            app.UsetimeValueGeneralSchemaLabel.Layout.Row = 6;
            app.UsetimeValueGeneralSchemaLabel.Layout.Column = 2;

            % Create UsetimeGeneralSchemaLabel
            app.UsetimeGeneralSchemaLabel = uilabel(app.GeneralSchemaGridLayout);
            app.UsetimeGeneralSchemaLabel.FontName = '.AppleSystemUIFont';
            app.UsetimeGeneralSchemaLabel.FontColor = [1 1 1];
            app.UsetimeGeneralSchemaLabel.Layout.Row = 6;
            app.UsetimeGeneralSchemaLabel.Layout.Column = 1;
            app.UsetimeGeneralSchemaLabel.Text = 'Last entry';

            % Create LifetimeValueGeneralSchemaLabel
            app.LifetimeValueGeneralSchemaLabel = uilabel(app.GeneralSchemaGridLayout);
            app.LifetimeValueGeneralSchemaLabel.FontName = '.AppleSystemUIFont';
            app.LifetimeValueGeneralSchemaLabel.FontColor = [1 1 1];
            app.LifetimeValueGeneralSchemaLabel.Layout.Row = 4;
            app.LifetimeValueGeneralSchemaLabel.Layout.Column = 2;
            app.LifetimeValueGeneralSchemaLabel.Text = datestr(app.ModelObj.Created);

            % Create LifetimeGeneralSchemaLabel
            app.LifetimeGeneralSchemaLabel = uilabel(app.GeneralSchemaGridLayout);
            app.LifetimeGeneralSchemaLabel.FontName = '.AppleSystemUIFont';
            app.LifetimeGeneralSchemaLabel.FontColor = [1 1 1];
            app.LifetimeGeneralSchemaLabel.Layout.Row = 4;
            app.LifetimeGeneralSchemaLabel.Layout.Column = 1;
            app.LifetimeGeneralSchemaLabel.Text = 'Created';

            % Create SerialValueGeneralSchemaLabel
            app.SerialValueGeneralSchemaLabel = uilabel(app.GeneralSchemaGridLayout);
            app.SerialValueGeneralSchemaLabel.FontName = '.AppleSystemUIFont';
            app.SerialValueGeneralSchemaLabel.FontColor = [1 1 1];
            app.SerialValueGeneralSchemaLabel.Layout.Row = 2;
            app.SerialValueGeneralSchemaLabel.Layout.Column = 2;
            app.SerialValueGeneralSchemaLabel.Text = 'T32A976';

            % Create SerialGeneralSchemaLabel
            app.SerialGeneralSchemaLabel = uilabel(app.GeneralSchemaGridLayout);
            app.SerialGeneralSchemaLabel.FontName = '.AppleSystemUIFont';
            app.SerialGeneralSchemaLabel.FontColor = [1 1 1];
            app.SerialGeneralSchemaLabel.Layout.Row = 2;
            app.SerialGeneralSchemaLabel.Layout.Column = 1;
            app.SerialGeneralSchemaLabel.Text = 'Serial no';

            % Create WindSchemaPanel
            app.WindSchemaPanel = uipanel(app.SchemaGridLayout);
            app.WindSchemaPanel.ForegroundColor = [1 1 1];
            app.WindSchemaPanel.BorderType = 'none';
            app.WindSchemaPanel.Title = 'Wind';
            app.WindSchemaPanel.BackgroundColor = [0.2 0.2 0.2];
            app.WindSchemaPanel.Layout.Row = [11 12];
            app.WindSchemaPanel.Layout.Column = [2 7];
            app.WindSchemaPanel.FontName = '.AppleSystemUIFont';
            app.WindSchemaPanel.FontWeight = 'bold';

            % Create BaseSchemaGridLayout_2
            app.WindSchemaGridLayout = uigridlayout(app.WindSchemaPanel);
            app.WindSchemaGridLayout.ColumnWidth = {'1.5x', '1x'};
            app.WindSchemaGridLayout.RowHeight = {'1x', 14, '1x', 14, '1x'};
            app.WindSchemaGridLayout.ColumnSpacing = 5;
            app.WindSchemaGridLayout.RowSpacing = 1;
            app.WindSchemaGridLayout.Padding = [5 5 5 1];
            app.WindSchemaGridLayout.BackgroundColor = [0.302 0.302 0.302];

            % Create SeaWindValueBaseSchemaLabel_2
            app.SpeedValueWindSchemaLabel = uilabel(app.WindSchemaGridLayout);
            app.SpeedValueWindSchemaLabel.FontName = '.AppleSystemUIFont';
            app.SpeedValueWindSchemaLabel.FontColor = [1 1 1];
            app.SpeedValueWindSchemaLabel.Layout.Row = 4;
            app.SpeedValueWindSchemaLabel.Layout.Column = 2;
            app.SpeedValueWindSchemaLabel.Text = '0';

            % Create SeaWindBaseSchemaLabel_2
            app.SpeedWindSchemaLabel = uilabel(app.WindSchemaGridLayout);
            app.SpeedWindSchemaLabel.FontName = '.AppleSystemUIFont';
            app.SpeedWindSchemaLabel.FontColor = [1 1 1];
            app.SpeedWindSchemaLabel.Layout.Row = 4;
            app.SpeedWindSchemaLabel.Layout.Column = 1;
            app.SpeedWindSchemaLabel.Text = 'Speed';

            % Create HeadingValueBaseSchemaLabel_2
            app.HeadingValueWindSchemaLabel = uilabel(app.WindSchemaGridLayout);
            app.HeadingValueWindSchemaLabel.FontName = '.AppleSystemUIFont';
            app.HeadingValueWindSchemaLabel.FontColor = [1 1 1];
            app.HeadingValueWindSchemaLabel.Layout.Row = 2;
            app.HeadingValueWindSchemaLabel.Layout.Column = 2;

            % Create HeadingBaseSchemaLabel_2
            app.HeadingWindSchemaLabel = uilabel(app.WindSchemaGridLayout);
            app.HeadingWindSchemaLabel.FontName = '.AppleSystemUIFont';
            app.HeadingWindSchemaLabel.FontColor = [1 1 1];
            app.HeadingWindSchemaLabel.Layout.Row = 2;
            app.HeadingWindSchemaLabel.Layout.Column = 1;
            app.HeadingWindSchemaLabel.Text = 'Direction';

            % Show the figure after all components are created
            app.ComponentsGridLayout.Visible = 'off';
        end
                
        % Añade listeners de los componentes interactivos de la GUI
        function addListeners(app, controller)
            % Auto Mode
            addlistener(app.AutoModeCommandButton,'ButtonPushed', ...
                @(src,evnt)controller.callback_modeCommandButton(src,evnt,app.AutoMode)); % 0
            % Ajusto colores de ambos botones
            addlistener(app.AutoModeCommandButton,'ButtonPushed', ...
                @(~,~)set(app.AutoModeCommandButton, ...
                'BackgroundColor',app.ModePressedButtonColor));
            % Invierto botón contrario
            addlistener(app.AutoModeCommandButton,'ButtonPushed', ...
                @(~,~)set(app.ManualModeCommandButton, ...
                'BackgroundColor',app.ModeNotPressedButtonColor));
            
            % Manual Mode
            addlistener(app.ManualModeCommandButton,'ButtonPushed', ...
                @(src,evnt)controller.callback_modeCommandButton(src,evnt,app.ManualMode)); % 1
            % Ajusto colores de ambos botones
            addlistener(app.ManualModeCommandButton,'ButtonPushed', ...
                @(~,~)set(app.ManualModeCommandButton, ...
                'BackgroundColor',app.ModePressedButtonColor));
            addlistener(app.ManualModeCommandButton,'ButtonPushed', ...
                @(~,~)set(app.AutoModeCommandButton, ...
                'BackgroundColor',app.ModeNotPressedButtonColor));

            % Pitch
            % +/-
            addlistener(app.MorePitchCommandButton,'ButtonPushed', ...
                @(~,~)set(app.PitchCommandField, 'Value', app.PitchCommandField.Value+1));
            addlistener(app.LessPitchCommandButton,'ButtonPushed', ...
                @(~,~)set(app.PitchCommandField, 'Value', app.PitchCommandField.Value-1));
            % Update
            % Se avisa al controlador
            addlistener(app.PitchCommandUpdateButton,'ButtonPushed', ...
                @(src,evnt)controller.callback_pitchCommandButton(src, evnt, ...
                app.PitchCommandField.Value)); 

            % Load
            % +/-
            addlistener(app.MoreLoadCommandButton,'ButtonPushed', ...
                @(~,~)set(app.LoadCommandField,'Value', app.LoadCommandField.Value+1));
            addlistener(app.LessLoadCommandButton,'ButtonPushed', ...
                @(~,~)set(app.LoadCommandField,'Value', app.LoadCommandField.Value-1));
            % Update
            % Se avisa al controlador
            addlistener(app.LoadCommandUpdateButton,'ButtonPushed', ...
                @(src,evnt)controller.callback_loadCommandButton(src, evnt, ...
                app.LoadCommandField.Value)); 

            % Botón Emergencia 
            % Se avisa al controlador
            addlistener(app.EmergencyCommandButton,'ValueChanged', ...
                @(src,evnt)controller.callback_emergencyCommandButton(src, evnt, ...
                app.EmergencyCommandButton.Value)); 
            % Ajusto color
            addlistener(app.EmergencyCommandButton,'ValueChanged', ...
                @(~,~)app.emergencyButtonColor); 
        end
        
        function emergencyButtonColor(app)
            if ~app.EmergencyCommandButton.Value
                app.EmergencyCommandButton.BackgroundColor = app.EmergencyNotPressedButtonColor;
            else 
                app.EmergencyCommandButton.BackgroundColor = app.EmergencyPressedButtonColor;
            end
        end
    end
end