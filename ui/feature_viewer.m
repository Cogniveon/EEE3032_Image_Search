classdef feature_viewer < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        GridLayout              matlab.ui.container.GridLayout
        LeftPanel               matlab.ui.container.Panel
        ExtractorDropDown       matlab.ui.control.DropDown
        ExtractorDropDownLabel  matlab.ui.control.Label
        ImagesListBox           matlab.ui.control.ListBox
        ImagesListBoxLabel      matlab.ui.control.Label
        LoadButton              matlab.ui.control.Button
        RightPanel              matlab.ui.container.Panel
        UIFeatures              matlab.ui.control.UIAxes
        UIImagePreview          matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    methods (Access = private)
        
        function updatePlots(app)
            value = app.ImagesListBox.Value;

            if isempty(value)
                return;
            end

            img = double(imread(value))./256;
            imshow(img, 'Parent', app.UIImagePreview);

            func = str2func(app.ExtractorDropDown.Value(1:end-2));
            F = func(img);
            plot(F, 'Parent', app.UIFeatures);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            extractors = struct2cell(dir('./extractors/*.m'));
            extractors = extractors(1,:);
            
            app.ExtractorDropDown.Items = extractors;
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            [file, path] = uigetfile('*.bmp', 'Select an image to load', 'MultiSelect', 'on');

            if isequal(file, 0)
               disp('User selected Cancel')
               return;
            end

            if length(file) > 1
                file = cellstr(file);
                for k = 1:length(file)
                    % disp(fullfile(path, file{k}))
                    app.ImagesListBox.Items(end+1) = {[path file{k}]};
                end
            else
                app.ImagesListBox.Items(end+1) = {[path file]};
            end

            updatePlots(app);
        end

        % Value changed function: ImagesListBox
        function ImagesListBoxValueChanged(app, event)
            value = app.ImagesListBox.Value;
            
            img = double(imread(value))./256;
            imshow(img, 'Parent', app.UIImagePreview);

            updatePlots(app);
        end

        % Value changed function: ExtractorDropDown
        function ExtractorDropDownValueChanged(app, event)
            updatePlots(app);
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {220, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {220, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create LoadButton
            app.LoadButton = uibutton(app.LeftPanel, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [30 443 168 23];
            app.LoadButton.Text = 'Load';

            % Create ImagesListBoxLabel
            app.ImagesListBoxLabel = uilabel(app.LeftPanel);
            app.ImagesListBoxLabel.HorizontalAlignment = 'right';
            app.ImagesListBoxLabel.Position = [30 397 44 22];
            app.ImagesListBoxLabel.Text = 'Images';

            % Create ImagesListBox
            app.ImagesListBox = uilistbox(app.LeftPanel);
            app.ImagesListBox.Items = {};
            app.ImagesListBox.ValueChangedFcn = createCallbackFcn(app, @ImagesListBoxValueChanged, true);
            app.ImagesListBox.Position = [89 347 109 74];
            app.ImagesListBox.Value = {};

            % Create ExtractorDropDownLabel
            app.ExtractorDropDownLabel = uilabel(app.LeftPanel);
            app.ExtractorDropDownLabel.HorizontalAlignment = 'right';
            app.ExtractorDropDownLabel.Position = [30 305 53 22];
            app.ExtractorDropDownLabel.Text = 'Extractor';

            % Create ExtractorDropDown
            app.ExtractorDropDown = uidropdown(app.LeftPanel);
            app.ExtractorDropDown.Items = {'Random', 'Mean Color', 'Color Histogram', 'Spacial Color Histogram', 'Spacial Color & Texture Histogram'};
            app.ExtractorDropDown.ValueChangedFcn = createCallbackFcn(app, @ExtractorDropDownValueChanged, true);
            app.ExtractorDropDown.Position = [98 305 100 22];
            app.ExtractorDropDown.Value = 'Random';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIImagePreview
            app.UIImagePreview = uiaxes(app.RightPanel);
            title(app.UIImagePreview, 'Image Preview')
            app.UIImagePreview.Position = [3 240 408 240];

            % Create UIFeatures
            app.UIFeatures = uiaxes(app.RightPanel);
            title(app.UIFeatures, 'Features')
            app.UIFeatures.Position = [1 1 411 240];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = feature_viewer

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end