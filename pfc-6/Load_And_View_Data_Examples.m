%% example script to load and parse mPfC data from a few sessions
%% and some visualisations
% Mark Humphries 12/2/2018

clear all; close all; 

filepath = './'; % folders for each session are in this root directory: change here for other paths

% here we will load all of the "learning" sessions
learning_trial_number = [23;23;14;5;10;12;5;18;11;8];
analyse_trial_session = {'201222','201227','201229','181012','181020','150628','150630','150707','190214','190228'};

Qt = 0.001;  % quantisation of spike-data: convert from ms to s

binsize = 1; % 1 second bins for population rate histogram

%% load data, plot rate histogram and rate distributions
for iS = 1:numel(analyse_trial_session)
    iS
    SpkData(iS).fname = analyse_trial_session{iS};
    SpkData(iS).learningtrial = learning_trial_number(iS);
    spkdata = importdata([filepath SpkData(iS).fname '/' SpkData(iS).fname '_SpikeData.dat']);  % [time-stamp (ms); neuron]
    WakeEpoch = importdata([filepath SpkData(iS).fname '/' SpkData(iS).fname '_WakeEpoch.dat']); % start and end times of Wake epoch (ms)
    PreEpoch = importdata([filepath SpkData(iS).fname '/' SpkData(iS).fname '_SwsPRE.dat']);
    PostEpoch = importdata([filepath SpkData(iS).fname '/' SpkData(iS).fname '_SwsPOST.dat']);
    Trials = importdata([filepath SpkData(iS).fname '/' SpkData(iS).fname '_Behavior.dat']);  
    
    SpkData(iS).nTrials = size(Trials,1);
    SpkData(iS).NeuronIDs = unique(spkdata(:,2));
    
    spkdata(:,1) = spkdata(:,1).*Qt; % convert to seconds
    
    SpkData(iS).spks = spkdata;
    
    % chop into trial+ITI chunks
    SpkData(iS).TrialStart = Trials(:,1) .* Qt;                     % start time of each trial (in s)
    SpkData(iS).TrialEnd = Trials(:,2) .* Qt;                       % end time of each trial (in s)
    SpkData(iS).ITIEnd = [Trials(2:end,1); WakeEpoch(2)] .* Qt;     % end of each inter-trial interval (in s);   
    
    %% whole population
    % visualise population activity from start of first trial to the end of
    % the last trial (including all ITIs)
    bins = SpkData(iS).TrialStart(1):binsize:SpkData(iS).ITIEnd(end);  
    blnTrialts = SpkData(iS).spks(:,1) >= SpkData(iS).TrialStart(1) & SpkData(iS).spks(:,1) <= SpkData(iS).ITIEnd(end); % all times within trials
    trialspks = SpkData(iS).spks(blnTrialts,:);

    hPfC = hist(trialspks(:,1),bins);

    figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',[10 15 25 6]);
    bar(bins,hPfC,1,'FaceColor',[0 0 0]); hold on
    shading flat
    for iT = 1:numel(SpkData(iS).TrialStart)
        line([SpkData(iS).TrialStart(iT) SpkData(iS).TrialStart(iT)],[0 max(hPfC+10)],'Color',[0.8 0.2 0.2])  % red lines indicate trial start
    end
    axis tight
    title([num2str(SpkData(iS).fname) ' population activity']); ylabel('Population rate (spikes/s)'); xlabel('Time (s)')
   
    
    %% each neuron
    T = SpkData(iS).ITIEnd(end) - SpkData(iS).TrialStart(1); % total elapsed time
    for iN = 1:numel(SpkData(iS).NeuronIDs)
        ts = trialspks(trialspks(:,2)==SpkData(iS).NeuronIDs(iN),1); % time-stamps of all spikes in trials from this neuron
        SpkData(iS).rates(iN) = numel(ts) ./ T;
        ISIs = diff(ts);
        SpkData(iS).CV(iN) = mean(ISIs) ./ std(ISIs);
    end
    
    figure
    subplot(211),ecdf(SpkData(iS).rates);
    title([num2str(SpkData(iS).fname) ' rate distribution']); xlabel('Rate (spikes/s)'); ylabel('P')
    subplot(212),ecdf(SpkData(iS).CV);
    title([num2str(SpkData(iS).fname) ' regularity distribution']); xlabel('CV of ISI'); ylabel('P')
    
    %% outcome dependence: difference of mean rates on error and correct trials
    Ttrials = SpkData(iS).TrialEnd -  SpkData(iS).TrialStart; 
    blnOutcome = logical(Trials(:,4));  % outcome of each trial
     for iN = 1:numel(SpkData(iS).NeuronIDs)
        ts = trialspks(trialspks(:,2)==SpkData(iS).NeuronIDs(iN),1); % time-stamps of all spikes in trials from this neuron
        
        for iT = 1:numel(SpkData(iS).TrialStart)
            trialrates(iT) = sum(ts >= SpkData(iS).TrialStart(iT) & ts <= SpkData(iS).TrialEnd(iT))./ Ttrials(iT);
        end
        SpkData(iS).correctrates(iN) = mean(trialrates(blnOutcome));
        SpkData(iS).errorrates(iN) = mean(trialrates(~blnOutcome));  
    end
    SpkData(iS).diffErrCorr = SpkData(iS).correctrates - SpkData(iS).errorrates;
    [srtDiff,ixSrt] = sort(SpkData(iS).diffErrCorr);
    ixPos = find(srtDiff >= 0); ixNeg = find(srtDiff < 0);
    figure
    barh(ixPos,srtDiff(ixPos),0.8,'FaceColor',[0.7 0.4 0.3]); hold on
    barh(ixNeg,srtDiff(ixNeg),0.8,'FaceColor',[0.3 0.4 0.8]); 
    set(gca,'YLim',[0.5,numel(SpkData(iS).NeuronIDs)+0.5],'YTick',[1:5:numel(SpkData(iS).NeuronIDs)]);
    title([num2str(SpkData(iS).fname) ' correct vs error preference']);
    xlabel('f(correct) - f(error) (spikes/s)'); ylabel('Neurons')
 pause
end
