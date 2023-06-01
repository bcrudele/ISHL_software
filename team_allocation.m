% ==============================================================================
%  Title: Team Allocator Algorithm
%  Author: Brandon Crudele
%  Date: 06/1/2023
%  Description: Allocates available players to a specified number of teams.
%
%       Takes into account skill ratings specified by the end user. Data is
%       exported to an Excel file named with a timestamp at the run-time.
% ==============================================================================
%  Inputs:
%   - Players Available
%   - Teams Requested
%   - Maximum Team Skill Difference
%   - Number of Results
% ==============================================================================
%  Dependencies:
%  1. MATLAB R2022b or later
%  2. skills.xlsx (template file)
% ==============================================================================
%  Notes:
%  - Will only allocate teams depending on the amount of available goalies.
%    One goalie will be allocated per team.
%  - Algorithm may reject certain user-inputs and return an error message.
%  - Only enter integer and non-negative values for user-input.
%  - Ensure you are using the proper 'skills.xlsx' template file for the
%    algorithm to function properly.
%  Install Notes:
%  - Save application to a memorable location. 
%  - Open the application folder to enter information. 
%  - Use 'skills.xlsx' to enter player information. 
%  - Run 'ISHL_team_allocation.exe' and allow terminal to boot. 
%  - Follow prompts to aquire results. 
%  - Results will be stores in an output file to the application folder.
% ==============================================================================

fprintf('==============================\n');
fprintf('        ISHL Team Sorter        \n');
fprintf('==============================\n\n');

min_ppt = 2; % Minimum allowed skaters per team
min_teams = 2; % Minimum teams allowed in league
players_per_team = 0; % Ratio of players per team requested (subject to UI)
sortedTeams = {};
tempTeams ={};
stringID = {};

team_names = {'Chicago Charge', 'Midwest Melkmen', 'The Disappointments', ...
    'Toxic Turtles'};

%% User Input & Validity Check

while (players_per_team < min_ppt || num_teams < min_teams || ...
        valid_counts(1)/num_teams < players_per_team || ...
        valid_counts(2) < num_teams)

    num_teams = -1; % Number of teams requested
    num_players = -1; % Number of skaters (DNI GOALIES)
    input_dev = -1; % Input deviation request
    num_outs = -1; % Number outputs requested


    while ((mod(num_players,1) ~= 0) || (num_players <= 0) )
        fprintf("Players Available: ")
        num_players = errorHandler(num_players);
    end

    while ((mod(num_teams,1) ~= 0) || (num_teams <= 0) )
        fprintf("Teams Requested: ")
        num_teams = errorHandler(num_teams);
    end

    while ((mod(input_dev,1) ~= 0) || (input_dev <= 0) )
        fprintf("Maximum Skill Deviation: ")
        input_dev = errorHandler(input_dev);
    end

    while ((mod(num_outs,1) ~= 0) || (num_outs <= 0) )
        fprintf("# of Combinations Requested: ")
        num_outs = errorHandler(num_outs);
    end

    players_per_team = num_players/num_teams;

    % Modular Input ===

    data = readcell("skills.xlsx","NumHeaderLines",1);

    players = data(1:num_players,1);  % player names

    goalies = data(1:num_teams,3);     % goalie names

    data = readmatrix("skills.xlsx","NumHeaderLines",1);

    ratings = data(1:num_players,2);  % player ratings

    gratings = data(1:num_teams,4);   % goalie ratings

    valid_counts = data(1:2,5); % Checks the availability count of each position

    % End Modular Input ===

    if players_per_team < min_ppt
        fprintf("Minimum players per team requirement not met. \n")

    elseif num_teams < min_teams
        fprintf("Not enough teams requested. Current league minimum -> %.f\n", min_teams);

    elseif valid_counts(2) < num_teams
        fprintf("Not enough goalies to fufill team number request\n" + ...
            "Current league goalies available -> %.f\n", valid_counts(2));

    elseif (valid_counts(1)/num_teams < players_per_team)
        fprintf("Not enough skaters to fufill team number request\n")
    end
end

% Timestamp when algorithm begins
timestamp = datestr(now, 'mmddyy_HHMMSS');
startTime = datetime;

%% Shuffle Function

filecell = cell(((num_outs * num_teams) + 1),(floor(players_per_team)) + 3);
filecell{1,1} = 'Result #';
filecell{1,2} = 'Team';
filecell{1,3} = 'Team Skill';
filecell{1,4} = 'Deviation';
filecell{1,5} = 'Goalie';

for k = 6:(5 + floor(players_per_team))
    filecell{1,k} = 'Player';
end

%% Team Rating Calculator

possibilities = 0;

for k = 1:num_outs % num_outs

    tot = 0:999:num_teams*999;

    while (std(tot) >= input_dev)

        tot = zeros(1,num_teams);
        random_alloc = [];  % To be shuffled indexing vector

        values = 1:num_players;

        % Shuffle the vector of values using the randperm function
        shuffled_values = randperm(num_players);

        % Loop over the shuffled values and select each value once
        for i = 1:num_players
            selected_value = values(shuffled_values(i));
            random_alloc(i) = selected_value;
        end

        ct = 0;

        for i = 1:num_teams

            for j = 1:players_per_team

                ct = ct + 1;

                tempTeams{j,i} = players{random_alloc(ct)};

                tot(i) = tot(i) + ratings(random_alloc(ct)); % add player rating

            end

            tot(i) = tot(i) + gratings(i); % add goalie rating

        end

        tempTeams = sort(tempTeams); % sorts players names alphabetically

        sortedTeams = reshape(tempTeams,numel(tempTeams),1);

        possibilities = possibilities + 1;

    end

    %% Output & Loading

    ct = 0;
    % fprintf("========================\n")
    % fprintf("  Result #%.f \n\n", k)

    for z = 1:num_teams

        filecell{((k - 1) * num_teams) + z + 1, 1} = k;

        % fprintf("%s skill: %.f\n",team_names{z}, tot(z))

        filecell{((k - 1) * num_teams) + z + 1, 2} = team_names{z};

        filecell{((k - 1) * num_teams) + z + 1, 3} = tot(z);

        % fprintf("Goalie: %s, \n",goalies{z});

        filecell{((k - 1) * num_teams) + z + 1, 5} = goalies{z};

        for j = 1:players_per_team

            ct = ct + 1;

            filecell{((k - 1) * num_teams) + z + 1, 5 + j } ...
                = sortedTeams{ct};

            % fprintf("%s, ",sortedTeams{ct});
        end

        % fprintf("\n\n");

    end

    filecell{((k - 1) * num_teams) + z + 1, 4} = std(tot);

    % fprintf("Skill Deviation -> %0.5f\n", std(tot))

    % fprintf("\n")

    stringID{k} = strjoin(sortedTeams(1:numel(sortedTeams)), '');

end

endTime = datetime;
runtime = seconds(endTime- startTime);


[uniqueStringID, ~, stringIDIndices] = unique(stringID, 'stable');

uniqueResults = {};

for i = 1:numel(uniqueStringID)
    indices = find(stringIDIndices == i);
    uniqueResults{i} = num2str(indices(1));
end

for i = 1:numel(uniqueResults)

    filecell{str2double(uniqueResults{i}) * num_teams ,1} = ...
        sprintf('***%.f***', str2double(uniqueResults{i}));
end

% Create a filename using the timestamp
filename = sprintf('output_%s.xlsx', timestamp);

writecell(filecell, filename);  % Save filecell as an Excel file

[uniqueStringID, ~, stringIDIndices] = unique(stringID, 'stable');

% End Screen Result

fprintf('==============================\n');
fprintf('        Runtime Info        \n\n');
fprintf('Time Elapsed:              %.2fs\n',runtime);
fprintf('Trials Generated:          %.f\n',k);
fprintf('Unique Teams Generated:    %.f\n',numel(uniqueStringID));
fprintf('Total Shuffles:            %.f\n', possibilities);