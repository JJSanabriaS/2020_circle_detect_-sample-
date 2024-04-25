classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        CIRCLEDETECTIONINMATLABLabel  matlab.ui.control.Label
        RminButton                    matlab.ui.control.Button
        RmaxButton                    matlab.ui.control.Button
        UIAxes                        matlab.ui.control.UIAxes
        UIAxes2                       matlab.ui.control.UIAxes
        SelectfigureButton            matlab.ui.control.Button
        CircledetectionButton         matlab.ui.control.Button
        EditField                     matlab.ui.control.NumericEditField
        EditField2                    matlab.ui.control.NumericEditField
    end

    
    methods (Access = private)
        
          end
    
    methods (Access = public)
        
        function resultsh = circle(x,y,r)
            %function h = circle(x,y,r)
            hold on
            th = 0:pi/50:2*pi;
            xunit = r * cos(th) + x;
            yunit = r * sin(th) + y;
            h = plot(xunit, yunit);
            hold off
        end
    end
    

    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            clc
            clear
            %close(app.UIFigure)
            Rmin=70;
            Rmax=100;
            assignin('base','Rmin',Rmin);
            assignin('base','Rmax',Rmax);
            
        end

        % Button pushed function: SelectfigureButton
        function SelectfigureButtonPushed(app, event)
            [filename, pathname] = uigetfile({'*.jpg';'*.gif';'*.bmp';'*.*'}, ...
        'Pick a file');
            ImagePath=strcat(pathname,filename);
            Img=imread(ImagePath);
            disp('carregamento da imagem base')
            imshow(Img,'Parent',app.UIAxes);
            assignin('base','Img',Img);
        end

        % Button pushed function: CircledetectionButton
        function CircledetectionButtonPushed(app, event)
            Img=evalin('base','Img');
            Img=im2bw(Img(:,:,3)); 
            Rmax=evalin('base','Rmax');
            Rmin=evalin('base','Rmin');
            disp('valoracao dos radios e inicio do processo')
            if or((Rmin<0),(Rmax<=0))
                 Rmin=70;
                 Rmax=100;
                 f = msgbox('Algum dos valores e invalido, seram restablecidos os valores por defeito', 'Error','error');
            end
            if Rmax<Rmin
                %Rmin=70;
                Rmax=100;
                f = msgbox('O valor máximo e invalido, sera restablecido o valor por defeito', 'Error','error');
            end
                
                
            [centersDark, radiiDark] = imfindcircles(Img, [Rmin Rmax], ...
                                        'ObjectPolarity','bright','sensitivity',0.90);
            %imagesc(Img);
            %axes(app.UIAxes2);
            imshow(Img,'Parent',app.UIAxes2);
            %hold on
            tam=size(centersDark);
            tam1=size(radiiDark);
            %hold on
            hold(app.UIAxes2,'on');
            for mov1=1:1:tam(1)
                %for mov2=1:1:tam(2)
                th = 0:pi/50:2*pi;
                rad=[centersDark(mov1,:)];
                xunit = radiiDark(mov1) * cos(th) + rad(1);
                yunit = radiiDark(mov1)* sin(th) + rad(2);
               %hold on
                plot(app.UIAxes2,xunit, yunit,'r*');
                %end
            end
                
            %viscircles(app.UIAxes2,centersDark, radiiDark,'LineStyle','--');
            %hold off
        end

        % Value changed function: EditField
        function EditFieldValueChanged(app, event)
            value = app.EditField.Value;
            assignin('base','Rmin',value);
        end

        % Value changed function: EditField2
        function EditField2ValueChanged(app, event)
            value = app.EditField2.Value;
            assignin('base','Rmax',value);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.Resize = 'OFF';

            % Create CIRCLEDETECTIONINMATLABLabel
            app.CIRCLEDETECTIONINMATLABLabel = uilabel(app.UIFigure);
            app.CIRCLEDETECTIONINMATLABLabel.Position = [222 425 188 22];
            app.CIRCLEDETECTIONINMATLABLabel.Text = 'CIRCLE DETECTION IN MATLAB';

            % Create RminButton
            app.RminButton = uibutton(app.UIFigure, 'push');
            app.RminButton.Position = [46 369 100 22];
            app.RminButton.Text = 'Rmin';

            % Create RmaxButton
            app.RmaxButton = uibutton(app.UIFigure, 'push');
            app.RmaxButton.Position = [46 333 100 22];
            app.RmaxButton.Text = 'Rmax';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [10 121 300 185];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, '')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            app.UIAxes2.Position = [309 121 300 185];

            % Create SelectfigureButton
            app.SelectfigureButton = uibutton(app.UIFigure, 'push');
            app.SelectfigureButton.ButtonPushedFcn = createCallbackFcn(app, @SelectfigureButtonPushed, true);
            app.SelectfigureButton.Position = [123 60 100 22];
            app.SelectfigureButton.Text = 'Select figure';

            % Create CircledetectionButton
            app.CircledetectionButton = uibutton(app.UIFigure, 'push');
            app.CircledetectionButton.ButtonPushedFcn = createCallbackFcn(app, @CircledetectionButtonPushed, true);
            app.CircledetectionButton.Position = [422 60 100 22];
            app.CircledetectionButton.Text = 'Circle detection';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'numeric');
            app.EditField.ValueChangedFcn = createCallbackFcn(app, @EditFieldValueChanged, true);
            app.EditField.Position = [177 369 100 22];
            app.EditField.Value = 70;
            

            % Create EditField2
            app.EditField2 = uieditfield(app.UIFigure, 'numeric');
            app.EditField2.ValueChangedFcn = createCallbackFcn(app, @EditField2ValueChanged, true);
            app.EditField2.Position = [180 333 100 22];
            app.EditField2.Value = 100;
            
        end
    end

    methods (Access = public)

        % Construct app
        function app = app1_exported

            % Create and configure components
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