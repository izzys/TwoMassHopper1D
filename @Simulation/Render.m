function [] = Render(Sim,t,X,flag)
% Renders the simulation graphics
    switch flag
        case 'init'
            t = t(1);
            
            if Sim.Once
                % Open new figure
                if Sim.Fig
                    figure(Sim.Fig);
                    if isempty(findobj(gcf,'Type','uicontrol'))
                        % Make window larger
                        set(Sim.Fig,'Position', [100 200,...
                            Sim.FigWidth Sim.FigHeight]);
                    end
                else
                    Sim.Fig = figure();
                    % Make window larger
                    set(Sim.Fig,'Position', [100 200,...
                        Sim.FigWidth Sim.FigHeight]);
                end
                set(gca,'LooseInset',get(gca,'TightInset')*2)
                cla % clear previous render
                axis equal
             
                set(Sim.Fig,'DeleteFcn' ,@Sim.DeleteFcnCB)
                axis([Sim.FlMin Sim.FlMax Sim.HeightMin Sim.HeightMax]);
       
                % Initialize display timer
                Sim.hTime = uicontrol('Style', 'text',...
                    'String', sprintf(Sim.TimeStr,t),...
                    'HorizontalAlignment','left',...
                    'FontSize',11,...
                    'Units','normalized',...
                    'Position', [0.76 0.78 0.08 0.12],...
                    'backgroundcolor',get(gca,'color')); 
                
                % Initialize convergence display
                Sim.hConv = uicontrol('Style', 'text',...
                    'String', sprintf(Sim.ConvStr,1,'-'),...
                    'HorizontalAlignment','left',...
                    'FontSize',11,...
                    'Units','normalized',...
                    'Position', [0.76 0.7 0.08 0.12],...
                    'backgroundcolor',get(gca,'color')); 

                % Add a 'Stop simulation' button
                Sim.StopButtonObj = uicontrol('Style', 'pushbutton', 'String', 'Stop Simulation',...
                    'Units','normalized','FontSize',10,...
                    'Position', [0.76 0.92 0.09 0.03],...
                    'Callback', @Sim.StopButtonCB);
                
                 % Add a 'Pause simulation' button
                 Sim.PauseButtonObj = uicontrol('Style', 'pushbutton', 'String', 'Pause ',...
                     'Units','normalized','FontSize',10,...
                     'Position', [0.76 0.96 0.09 0.03],...
                     'Callback', @Sim.PauseButtonCB);                 
                 
                 
                Sim.Once = 0;

            end
    end

    
    if ~isempty(X)
        
        [COMy]=Sim.Mod.GetPos(X,'COM');

         Sim.FlMin = -1.5*Sim.AR;
         Sim.FlMax =  1.5*Sim.AR;
         Sim.HeightMin = COMy-4/Sim.AR;
         Sim.HeightMax = COMy+4/Sim.AR;
        
         axis([Sim.FlMin Sim.FlMax Sim.HeightMin Sim.HeightMax]);      

        % Update model render
        Sim.Mod = Sim.Mod.Render(X(Sim.ModCo));
        % Update environment render
        Sim.Env = Sim.Env.Render(Sim.FlMin,Sim.FlMax);
        % Update time display
        set(Sim.hTime,'string',...
            sprintf(Sim.TimeStr,t(1), int2str(Sim.StepsTaken)) );
        % Update convergence display
        Period = find(Sim.stepsSS>0,1,'first');
        if ~isempty(Period)
            diff = norm(Sim.ICstore(Sim.indICtoCheck,1) - Sim.ICstore(Sim.indICtoCheck,1+Period));
            set(Sim.hConv,'string',...
                sprintf(Sim.ConvStr,diff,int2str(Period)),...
                    'backgroundcolor',[0.5 1 0.5]);
        else
            
            diff = norm(Sim.ICstore(Sim.indICtoCheck,1) - Sim.ICstore(Sim.indICtoCheck,2));
            set(Sim.hConv,'string',...
                sprintf(Sim.ConvStr,diff,'-'),...
                    'backgroundcolor',get(gca,'color'));
        end

    end
    status = Sim.StopSim;
    drawnow
%      frame = getframe;
%      writeVideo(Sim.VideoWriterObj,frame);
end