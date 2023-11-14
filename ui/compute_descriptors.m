classdef compute_descriptors < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        VisualSearchButton             matlab.ui.control.Button
        ConfigGridLayout               matlab.ui.container.GridLayout
        ComputeDescriptorsButton       matlab.ui.control.Button
        % PCACheckBox                    matlab.ui.control.CheckBox
        % DistanceFunctionDropDown       matlab.ui.control.DropDown
        % DistanceFunctionDropDownLabel  matlab.ui.control.Label
        ExtractorDropDown              matlab.ui.control.DropDown
        ExtractorDropDownLabel         matlab.ui.control.Label
        DatasetFolderDisplay           matlab.ui.control.Label
        ChangeDatasetFolderButton      matlab.ui.control.Button
        DatasetFolderLabel             matlab.ui.control.Label

        RBGHistogramQuantizationField  matlab.ui.control.NumericEditField
        RBGHistFieldLabel              matlab.ui.control.Label
        SpacialGridRowField            matlab.ui.control.NumericEditField
        SpacialGridRowFieldLabel       matlab.ui.control.Label
        SpacialGridColumnField         matlab.ui.control.NumericEditField
        SpacialGridColumnFieldLabel    matlab.ui.control.Label
        EdgeHistogramBinField          matlab.ui.control.NumericEditField
        EdgeHistogramBinFieldLabel     matlab.ui.control.Label
        EdgeHistogramThresholdField    matlab.ui.control.NumericEditField
        EdgeHistogramThresholdFieldLabel matlab.ui.control.Label

        DATASET_FOLDER                 string {mustBeNonzeroLengthText(DATASET_FOLDER), mustBeFolder(DATASET_FOLDER)} = "./MSRC_ObjCategImageDatabase_v2/Images";
        DESCRIPTOR_FOLDER              string = "./descriptors";
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            extractors = struct2cell(dir('./core/extractors/*.m'));
            extractors = extractors(1,:);
            
            app.ExtractorDropDown.Items = extractors;

            % distanceFns = struct2cell(dir('./core/distanceFn/*.m'));
            % distanceFns = distanceFns(1,:);
            % 
            % app.DistanceFunctionDropDown.Items = distanceFns;
        end
        
        % Button pushed function: LoadButton
        function ChangeDatasetFolderPushed(app, event)
            selectedFolder = uigetdir('.', 'Select the dataset folder');

            if selectedFolder == '0'
                return;
            end

            app.DATASET_FOLDER = selectedFolder;
        end

        function compute(app, event)
            descriptor = app.ExtractorDropDown.Value(8:end-2);
            
            if ~exist(strcat(app.DESCRIPTOR_FOLDER, '/', descriptor), 'dir')
                mkdir(strcat(app.DESCRIPTOR_FOLDER, '/', descriptor))
            end

            IMAGES = LoadImages(app.DATASET_FOLDER);
            [~, NIMG]=size(IMAGES);

            progress_bar = waitbar(0, 'Processing...');
            for i = 1:NIMG
                img = double(imread(IMAGES{1, i}))./256;
                descriptor_path = strcat(app.DESCRIPTOR_FOLDER, '/', descriptor, '/', IMAGES{2, i});

                switch app.ExtractorDropDown.Value
                    otherwise
                        F = extractRandom(img);
                end

                save(descriptor_path, 'F');

                progress = i / NIMG;
                waitbar(progress, progress_bar, sprintf('Calculating descriptors... %d/%d', i, NIMG));

                % If the progress window is closed in between... break;
                if ~isvalid(progress_bar)
                    disp('Cancelled compute descriptors...');
                    break;
                end
            end

            if isvalid(progress_bar)
                close(progress_bar);
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
            
            % Get the screen size
            screenSize = get(groot, 'ScreenSize');
            
            % Calculate the center position
            appWidth = 420;
            appHeight = 420;
            centerX = (screenSize(3) - appWidth) / 2;
            centerY = (screenSize(4) - appHeight) / 2;

            app.UIFigure.Position = [centerX centerY appWidth appHeight];
            app.UIFigure.Name = 'Compute Descriptors';
            % app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.RowHeight = {'6x', '1x'};

            % Create ConfigGridLayout
            app.ConfigGridLayout = uigridlayout(app.GridLayout);
            app.ConfigGridLayout.ColumnWidth = {'2x', '2x', '1x'};
            app.ConfigGridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.ConfigGridLayout.Layout.Row = 1;
            app.ConfigGridLayout.Layout.Column = [1 2];

            % Create DatasetFolderLabel
            app.DatasetFolderLabel = uilabel(app.ConfigGridLayout);
            app.DatasetFolderLabel.Layout.Row = 1;
            app.DatasetFolderLabel.Layout.Column = 1;
            app.DatasetFolderLabel.Text = 'Dataset folder:';

            % Create ChangeDatasetFolderButton
            app.ChangeDatasetFolderButton = uibutton(app.ConfigGridLayout, 'push');
            app.ChangeDatasetFolderButton.Layout.Row = 1;
            app.ChangeDatasetFolderButton.Layout.Column = 3;
            app.ChangeDatasetFolderButton.Text = 'Change';
            app.ChangeDatasetFolderButton.ButtonPushedFcn = createCallbackFcn(app, @changeDatasetFolder, true);

            % Create DatasetFolder
            app.DatasetFolderDisplay = uilabel(app.ConfigGridLayout);
            app.DatasetFolderDisplay.Layout.Row = 1;
            app.DatasetFolderDisplay.Layout.Column = 2;
            app.DatasetFolderDisplay.Text = app.DATASET_FOLDER;

            % Create ExtractorDropDownLabel
            app.ExtractorDropDownLabel = uilabel(app.ConfigGridLayout);
            app.ExtractorDropDownLabel.Layout.Row = 2;
            app.ExtractorDropDownLabel.Layout.Column = 1;
            app.ExtractorDropDownLabel.Text = 'Extractor';

            % Create ExtractorDropDown
            app.ExtractorDropDown = uidropdown(app.ConfigGridLayout);
            app.ExtractorDropDown.Layout.Row = 2;
            app.ExtractorDropDown.Layout.Column = [2 3];
            app.ExtractorDropDown.Items = {};
            app.ExtractorDropDown.Value = {};


            % Create RGBHistFieldLabel
            app.RBGHistFieldLabel = uilabel(app.ConfigGridLayout);
            app.RBGHistFieldLabel.HorizontalAlignment = 'left';
            app.RBGHistFieldLabel.Layout.Row = 3;
            app.RBGHistFieldLabel.Layout.Column = 1;
            app.RBGHistFieldLabel.Text = 'RGB Histogram Q';

            % Create RGBHistField
            app.RBGHistogramQuantizationField = uieditfield(app.ConfigGridLayout, 'numeric');
            app.RBGHistogramQuantizationField.Layout.Row = 3;
            app.RBGHistogramQuantizationField.Layout.Column = [2 3];
            app.RBGHistogramQuantizationField.Value = 4;

            % Create SpacialGridRowFieldLabel
            app.SpacialGridRowFieldLabel = uilabel(app.ConfigGridLayout);
            app.SpacialGridRowFieldLabel.HorizontalAlignment = 'left';
            app.SpacialGridRowFieldLabel.Layout.Row = 4;
            app.SpacialGridRowFieldLabel.Layout.Column = 1;
            app.SpacialGridRowFieldLabel.Text = 'Spacial Grid Rows';

            % Create SpacialGridRowField
            app.SpacialGridRowField = uieditfield(app.ConfigGridLayout, 'numeric');
            app.SpacialGridRowField.Layout.Row = 4;
            app.SpacialGridRowField.Layout.Column = [2 3];
            app.SpacialGridRowField.Value = 4;

            % Create SpacialGridColumnFieldLabel
            app.SpacialGridColumnFieldLabel = uilabel(app.ConfigGridLayout);
            app.SpacialGridColumnFieldLabel.HorizontalAlignment = 'left';
            app.SpacialGridColumnFieldLabel.Layout.Row = 5;
            app.SpacialGridColumnFieldLabel.Layout.Column = 1;
            app.SpacialGridColumnFieldLabel.Text = 'Spacial Grid Columns';

            % Create SpacialGridColumnField
            app.SpacialGridColumnField = uieditfield(app.ConfigGridLayout, 'numeric');
            app.SpacialGridColumnField.Layout.Row = 5;
            app.SpacialGridColumnField.Layout.Column = [2 3];
            app.SpacialGridColumnField.Value = 4;
            
            % Create EdgeHistogramBinFieldLabel
            app.EdgeHistogramBinFieldLabel = uilabel(app.ConfigGridLayout);
            app.EdgeHistogramBinFieldLabel.HorizontalAlignment = 'left';
            app.EdgeHistogramBinFieldLabel.Layout.Row = 6;
            app.EdgeHistogramBinFieldLabel.Layout.Column = 1;
            app.EdgeHistogramBinFieldLabel.Text = 'Edge Histogram Bins';

            % Create EdgeHistogramBinField
            app.EdgeHistogramBinField = uieditfield(app.ConfigGridLayout, 'numeric');
            app.EdgeHistogramBinField.Layout.Row = 6;
            app.EdgeHistogramBinField.Layout.Column = [2 3];
            app.EdgeHistogramBinField.Value = 8;
            
            % Create EdgeHistogramThresholdFieldLabel
            app.EdgeHistogramThresholdFieldLabel = uilabel(app.ConfigGridLayout);
            app.EdgeHistogramThresholdFieldLabel.HorizontalAlignment = 'left';
            app.EdgeHistogramThresholdFieldLabel.Layout.Row = 7;
            app.EdgeHistogramThresholdFieldLabel.Layout.Column = 1;
            app.EdgeHistogramThresholdFieldLabel.Text = 'Edge Histogram Threshold';

            % Create EdgeHistogramThresholdField
            app.EdgeHistogramThresholdField = uieditfield(app.ConfigGridLayout, 'numeric');
            app.EdgeHistogramThresholdField.Layout.Row = 7;
            app.EdgeHistogramThresholdField.Layout.Column = [2 3];
            app.EdgeHistogramThresholdField.Value = 0.09;

            % Create DistanceFunctionDropDownLabel
            % app.DistanceFunctionDropDownLabel = uilabel(app.ConfigGridLayout);
            % app.DistanceFunctionDropDownLabel.Layout.Row = 3;
            % app.DistanceFunctionDropDownLabel.Layout.Column = 1;
            % app.DistanceFunctionDropDownLabel.Text = 'Distance Function';

            % Create DistanceFunctionDropDown
            % app.DistanceFunctionDropDown = uidropdown(app.ConfigGridLayout);
            % app.DistanceFunctionDropDown.Layout.Row = 3;
            % app.DistanceFunctionDropDown.Layout.Column = [2 3];
            % app.DistanceFunctionDropDown.Items = {};
            % app.DistanceFunctionDropDown.Value = {};

            % Create PCACheckBox
            % app.PCACheckBox = uicheckbox(app.ConfigGridLayout);
            % app.PCACheckBox.Text = 'PCA';
            % app.PCACheckBox.Layout.Row = 4;
            % app.PCACheckBox.Layout.Column = 1;

            % Create ComputeDescriptorsButton
            app.ComputeDescriptorsButton = uibutton(app.ConfigGridLayout, 'push');
            app.ComputeDescriptorsButton.Layout.Row = 8;
            app.ComputeDescriptorsButton.Layout.Column = [1 3];
            app.ComputeDescriptorsButton.Text = 'Compute Descriptors';
            app.ComputeDescriptorsButton.ButtonPushedFcn = createCallbackFcn(app, @compute, true);


            % Create VisualSearchButton
            app.VisualSearchButton = uibutton(app.GridLayout, 'push');
            app.VisualSearchButton.Layout.Row = 2;
            app.VisualSearchButton.Layout.Column = [1 2];
            app.VisualSearchButton.Text = 'Visual Search';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = compute_descriptors

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