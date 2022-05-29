classdef ViewFarm < matlab.apps.AppBase

    properties (Constant)
        PressedButtonColor = [0.149 0.149 0.149]
        NotPressedButtonColor = [0.251 0.251 0.251]

        FarmViewId = 0
        T1ViewId = 1
        T2ViewId = 2
    end
        
    % Propiedades que se corresponden con los componentes de la app
    properties (Access = private)       
        UIFigure              matlab.ui.Figure
        GridLayout            matlab.ui.container.GridLayout
        NameLabel             matlab.ui.control.Label
        
        ButtonsPanel          matlab.ui.container.Panel
        ButtonsGridLayout     matlab.ui.container.GridLayout
        GFarmButton           matlab.ui.control.Button
        T1TurbineButton       matlab.ui.control.Button
        T2TurbineButton       matlab.ui.control.Button
        
        ComponentsGridLayout  matlab.ui.container.GridLayout
        StatePanel            matlab.ui.container.Panel
        StateGridLayout       matlab.ui.container.GridLayout
        StateLabel            matlab.ui.control.Label
        PowerStateGridLayout  matlab.ui.container.GridLayout
        PowerStateGauge       matlab.ui.control.Gauge
        PowerStateUIAxes      matlab.ui.control.UIAxes
        DetailsPanel          matlab.ui.container.Panel
        DetailsGridLayout     matlab.ui.container.GridLayout
        DetailsLabel          matlab.ui.control.Label
        DescriptionLabel      matlab.ui.control.Label
        MapPanel              matlab.ui.container.Panel
        MapGeoAxes            
    end
    
    % Propiedades que se corresponden con el MVC
    properties (Access = private) 
	    ControlObj % Controlador
	    ModelObj % Modelo
        ViewTurbineObjs % Vistas de las turbinas
    end

    methods (Access = public)
	    function app = ViewFarm(farmObj)
	        app.ModelObj = farmObj;

            % Función que crea y configura los componentes de la GUI
            createComponents(app);
 
            % Función de AppBase
	        registerApp(app, app.UIFigure);
            % Función que se ejecuta tras el inicio de la app pero antes de
            % que el usuario interaccione con la GUI
            runStartupFcn(app, @startupFcn);
            
	        % register callback 
	        if nargout == 0
		        clear app
	        end
        end  
 
        % Código que se ejecuta antes de que se borre la app
        function delete(app)
            for i = 1:length(app.ViewTurbineObjs)
                app.ViewTurbineObjs(i).delete();
            end  
            app.ControlObj.deleteTimers();
            delete(app.UIFigure);
            delete(app);
        end
        
        % Actualizaciones de la vista cuando el modelo avisa de que hay 
        % información nueva 
        function updateState(app) 
            % Power
            plot(app.PowerStateUIAxes, ...
                app.ModelObj.TimeStamps, app.ModelObj.Power, ...
                'LineWidth', 2.0);   
            app.PowerStateGauge.Value = app.ModelObj.Power(end);
        end
    end

    methods (Access = private)
	    % Crea UIFigure y sus componentes
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0 0 0];
            app.UIFigure.WindowState = 'fullscreen';
            app.UIFigure.Name = 'MATLAB App';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {30, '1x'};
            app.GridLayout.RowHeight = {60, '1x'};
            app.GridLayout.ColumnSpacing = 25;
            app.GridLayout.RowSpacing = 25;
            app.GridLayout.Padding = [25 25 25 25];
            app.GridLayout.BackgroundColor = [0.102 0.102 0.102];

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

            % Create MapPanel
            app.MapPanel = uipanel(app.ComponentsGridLayout);
            app.MapPanel.ForegroundColor = [1 1 1];
            app.MapPanel.BorderType = 'none';
            app.MapPanel.BackgroundColor = [0.102 0.102 0.102];
            app.MapPanel.Layout.Row = [1 2];
            app.MapPanel.Layout.Column = [1 6];
            app.MapPanel.FontWeight = 'bold';
            app.MapPanel.FontSize = 16;

            % Create MapUIAxes
            app.MapGeoAxes = geoaxes(app.MapPanel);
            lat = [];
            lon = [];
            for i = 1:length(app.ModelObj.Turbines)
                lat = [lat app.ModelObj.Turbines(i).Lat];
                lon = [lon app.ModelObj.Turbines(i).Lon];
            end  
            geoscatter(app.MapGeoAxes, lat, lon, ...
                'Marker', 'x', ...
                'MarkerEdgeColor', [0.749 0.251 0.251], ...
                'SizeData', 100, ...
                'LineWidth', 2.0);
            geobasemap(app.MapGeoAxes,'darkwater');
            app.MapGeoAxes.LatitudeAxis.Visible = 'off';
            app.MapGeoAxes.LongitudeAxis.Visible = 'off';
            app.MapGeoAxes.ZoomLevel = 8;
            app.MapGeoAxes.Box = 'off';
            app.MapGeoAxes.InnerPosition = [0 0 1 1];

            % Create DetailsPanel
            app.DetailsPanel = uipanel(app.ComponentsGridLayout);
            app.DetailsPanel.ForegroundColor = [1 1 1];
            app.DetailsPanel.BorderType = 'none';
            app.DetailsPanel.BackgroundColor = [0.2 0.2 0.2];
            app.DetailsPanel.Layout.Row = 3;
            app.DetailsPanel.Layout.Column = [1 3];
            app.DetailsPanel.FontWeight = 'bold';
            app.DetailsPanel.FontSize = 16;

            % Create DetailsGridLayout
            app.DetailsGridLayout = uigridlayout(app.DetailsPanel);
            app.DetailsGridLayout.ColumnWidth = {'1x'};
            app.DetailsGridLayout.RowHeight = {30, 20, '1x'};
            app.DetailsGridLayout.ColumnSpacing = 20;
            app.DetailsGridLayout.RowSpacing = 10;
            app.DetailsGridLayout.Padding = [20 20 20 20];
            app.DetailsGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create DetailsLabel
            app.DetailsLabel = uilabel(app.DetailsGridLayout);
            app.DetailsLabel.FontName = '.AppleSystemUIFont';
            app.DetailsLabel.FontSize = 24;
            app.DetailsLabel.FontWeight = 'bold';
            app.DetailsLabel.FontColor = [1 1 1];
            app.DetailsLabel.Layout.Row = 1;
            app.DetailsLabel.Layout.Column = 1;
            app.DetailsLabel.Text = 'Details';

            % Create DescriptionLabel
            app.DescriptionLabel = uilabel(app.DetailsGridLayout);
            app.DescriptionLabel.FontName = '.AppleSystemUIFont';
            app.DescriptionLabel.FontSize = 14;
            app.DescriptionLabel.FontAngle = 'italic';
            app.DescriptionLabel.FontColor = [1 1 1];
            app.DescriptionLabel.Layout.Row = 2;
            app.DescriptionLabel.Layout.Column = 1;
            app.DescriptionLabel.Text = app.ModelObj.Desc;

            % Create StatePanel
            app.StatePanel = uipanel(app.ComponentsGridLayout);
            app.StatePanel.ForegroundColor = [1 1 1];
            app.StatePanel.BorderType = 'none';
            app.StatePanel.BackgroundColor = [0.2 0.2 0.2];
            app.StatePanel.Layout.Row = 3;
            app.StatePanel.Layout.Column = [4 6];
            app.StatePanel.FontWeight = 'bold';
            app.StatePanel.FontSize = 16;

            % Create StateGridLayout
            app.StateGridLayout = uigridlayout(app.StatePanel);
            app.StateGridLayout.ColumnWidth = {150, '1x'};
            app.StateGridLayout.RowHeight = {30, '1x'};
            app.StateGridLayout.Padding = [20 20 20 20];
            app.StateGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create PowerStateUIAxes
            app.PowerStateUIAxes = uiaxes(app.StateGridLayout);
            ylabel(app.PowerStateUIAxes, 'Power')
            %app.PowerStateUIAxes.FontName = '.AppleSystemUIFont';
            app.PowerStateUIAxes.YLim = [0 500];
            app.PowerStateUIAxes.XColor = [1 1 1];
            app.PowerStateUIAxes.YColor = [1 1 1];
            app.PowerStateUIAxes.ZColor = [0 0 0];
            app.PowerStateUIAxes.Color = 'none';
            app.PowerStateUIAxes.Layout.Row = 2;
            app.PowerStateUIAxes.Layout.Column = 2;

            % Create PitchStateGridLayout
            app.PowerStateGridLayout = uigridlayout(app.StateGridLayout);
            app.PowerStateGridLayout.ColumnWidth = {'1x'};
            app.PowerStateGridLayout.RowHeight = {'1x'};
            app.PowerStateGridLayout.Padding = [0 10 0 10];
            app.PowerStateGridLayout.Layout.Row = 2;
            app.PowerStateGridLayout.Layout.Column = 1;
            app.PowerStateGridLayout.BackgroundColor = [0.2 0.2 0.2];

            % Create PowerStateGauge
            app.PowerStateGauge = uigauge(app.PowerStateGridLayout, 'circular');
            app.PowerStateGauge.Limits = [0 500];
            app.PowerStateGauge.BackgroundColor = [0.302 0.302 0.302];
            app.PowerStateGauge.FontName = '.AppleSystemUIFont';
            app.PowerStateGauge.FontColor = [1 1 1];
            app.PowerStateGauge.Layout.Row = 1;
            app.PowerStateGauge.Layout.Column = 1;

            % Create StateLabel
            app.StateLabel = uilabel(app.StateGridLayout);
            app.StateLabel.FontName = '.AppleSystemUIFont';
            app.StateLabel.FontSize = 24;
            app.StateLabel.FontWeight = 'bold';
            app.StateLabel.FontColor = [1 1 1];
            app.StateLabel.Layout.Row = 1;
            app.StateLabel.Layout.Column = 1;
            app.StateLabel.Text = 'State';

            % Create TurbinesPanel
            app.ButtonsPanel = uipanel(app.GridLayout);
            app.ButtonsPanel.ForegroundColor = [0.102 0.102 0.102];
            app.ButtonsPanel.BorderType = 'none';
            app.ButtonsPanel.BackgroundColor = [0.102 0.102 0.102];
            app.ButtonsPanel.Layout.Row = [1 2];
            app.ButtonsPanel.Layout.Column = 1;

            % Create TurbinesGridLayout
            app.ButtonsGridLayout = uigridlayout(app.ButtonsPanel);
            app.ButtonsGridLayout.ColumnWidth = {30};
            app.ButtonsGridLayout.RowHeight = {30, 30, 30, 30, 30};
            app.ButtonsGridLayout.Padding = [0 0 0 0];
            app.ButtonsGridLayout.BackgroundColor = [0.102 0.102 0.102];

            % Create T1TurbineButton
            app.T1TurbineButton = uibutton(app.ButtonsGridLayout, 'push');
            app.T1TurbineButton.BackgroundColor = app.NotPressedButtonColor;
            app.T1TurbineButton.FontName = '.AppleSystemUIFont';
            app.T1TurbineButton.FontSize = 16;
            app.T1TurbineButton.FontWeight = 'bold';
            app.T1TurbineButton.FontColor = [1 1 1];
            app.T1TurbineButton.Layout.Row = 2;
            app.T1TurbineButton.Layout.Column = 1;
            app.T1TurbineButton.Text = 'T1';

            % Create T2TurbineButton
            app.T2TurbineButton = uibutton(app.ButtonsGridLayout, 'push');
            app.T2TurbineButton.BackgroundColor = app.NotPressedButtonColor;
            app.T2TurbineButton.FontName = '.AppleSystemUIFont';
            app.T2TurbineButton.FontSize = 16;
            app.T2TurbineButton.FontWeight = 'bold';
            app.T2TurbineButton.FontColor = [1 1 1];
            app.T2TurbineButton.Layout.Row = 3;
            app.T2TurbineButton.Layout.Column = 1;
            app.T2TurbineButton.Text = 'T2';

            % Create GFarmButton
            app.GFarmButton = uibutton(app.ButtonsGridLayout, 'push');
            app.GFarmButton.BackgroundColor = app.PressedButtonColor;
            app.GFarmButton.FontName = '.AppleSystemUIFont';
            app.GFarmButton.FontSize = 16;
            app.GFarmButton.FontWeight = 'bold';
            app.GFarmButton.FontColor = [1 1 1];
            app.GFarmButton.Layout.Row = 1;
            app.GFarmButton.Layout.Column = 1;
            app.GFarmButton.Text = 'F';

            % Create NameLabel
            app.NameLabel = uilabel(app.GridLayout);
            app.NameLabel.FontName = '.AppleSystemUIFont';
            app.NameLabel.FontSize = 36;
            app.NameLabel.FontWeight = 'bold';
            app.NameLabel.FontColor = [1 1 1];
            app.NameLabel.Layout.Row = 1;
            app.NameLabel.Layout.Column = 2;
            app.NameLabel.Text = ['Farm #' app.ModelObj.Name];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
        
        % Añade listeners de los componentes interactivos de la GUI
        function addListeners(app, controller)
            % Turbina1
            addlistener(app.T1TurbineButton, 'ButtonPushed', ...
                @(~,~)controller.callback_changeView(app.T1ViewId));
            addlistener(app.T1TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.ComponentsGridLayout, 'Visible', 'off'));
            addlistener(app.T1TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.NameLabel, 'Text', ...
                ['Turbine #' app.ModelObj.Turbines(1).Name]));
            % Ajusto colores de los botones
            addlistener(app.T1TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.T1TurbineButton, ...
                'BackgroundColor', app.PressedButtonColor));
            addlistener(app.T1TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.T2TurbineButton, ...
                'BackgroundColor', app.NotPressedButtonColor));
            addlistener(app.T1TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.GFarmButton, ...
                'BackgroundColor', app.NotPressedButtonColor));
            
            % Turbina2
            addlistener(app.T2TurbineButton, 'ButtonPushed', ...
                @(~,~)controller.callback_changeView(app.T2ViewId));
            addlistener(app.T2TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.ComponentsGridLayout, 'Visible', 'off'));
            addlistener(app.T2TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.NameLabel, 'Text', ...
                ['Turbine #' app.ModelObj.Turbines(2).Name]));
            % Ajusto colores de los botones
            addlistener(app.T2TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.T1TurbineButton, ...
                'BackgroundColor', app.NotPressedButtonColor));
            addlistener(app.T2TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.T2TurbineButton, ...
                'BackgroundColor', app.PressedButtonColor));
            addlistener(app.T2TurbineButton, 'ButtonPushed', ...
                @(~,~)set(app.GFarmButton, ...
                'BackgroundColor', app.NotPressedButtonColor));

            % Granja          
            addlistener(app.GFarmButton, 'ButtonPushed', ...
                @(~,~)controller.callback_changeView(app.FarmViewId));
            addlistener(app.GFarmButton, 'ButtonPushed', ...
                @(~,~)set(app.ComponentsGridLayout, 'Visible', 'on'));
            addlistener(app.GFarmButton, 'ButtonPushed', ...
                @(~,~)set(app.NameLabel, 'Text', ...
                ['Farm #' app.ModelObj.Name]));
            % Ajusto colores de los botones
            addlistener(app.GFarmButton, 'ButtonPushed', ...
                @(~,~)set(app.T1TurbineButton, ...
                'BackgroundColor', app.NotPressedButtonColor));
            addlistener(app.GFarmButton, 'ButtonPushed', ...
                @(~,~)set(app.T2TurbineButton, ...
                'BackgroundColor', app.NotPressedButtonColor));
            addlistener(app.GFarmButton, 'ButtonPushed', ...
                @(~,~)set(app.GFarmButton, ...
                'BackgroundColor', app.PressedButtonColor));
        end
                
        % Añade listeners y muestra valores iniciales en la GUI
        function startupFcn(app)
            % Inicializar vistas de las turbinas
            for i = 1:length(app.ModelObj.Turbines)
                viewTurbineObj = ViewTurbine(app.GridLayout, app.ModelObj.Turbines(i));
                app.ViewTurbineObjs = [app.ViewTurbineObjs; viewTurbineObj];
            end
            
            % Inicializar controlador
	        app.ControlObj = ControllerFarm(app, app.ViewTurbineObjs, app.ModelObj);
            
            % Vincular controlador a la vista
            app.addListeners(app.ControlObj);
        end
    end
end