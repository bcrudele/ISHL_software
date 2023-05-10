% Taking in two arguments, this program should be able to allocate players
% to create fair teams. Should take into account variables such as
% predetermined weighted-player skill.

fprintf('==============================\n');
fprintf('        ISHL Team Sorter        \n');
fprintf('==============================\n\n');

min_ppt = 3; % Minimum allowed skaters per team
min_teams = 2; % Minimum teams allowed in league
players_per_team = 0; % Ratio of players per team requested (subject to UI)
players = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P'}; % 16 char
ratings = [10    9    8    7    6    5    4    3    2    1    1    2    3    4    5    6];
goalies = {'G1', 'G2', 'G3', 'G4'};
gratings = [10    1     5     5];        % Goalie ratings
team_names = {'Chicago Charge', 'Midwest Melkmen', 'The Disappointments', ...
    'Toxic Turtles'};

%% User Input
while (players_per_team < min_ppt || num_teams < min_teams || ... 
        num_teams > length(goalies) ||length(players)/num_teams < players_per_team)

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

    if players_per_team < min_ppt
        fprintf("Minimum players per team requirement not met. \n")

    elseif num_teams < min_teams
        fprintf("Not enough teams requested. Current league minimum -> %.f\n", min_teams);

    elseif num_teams > length(goalies)
        fprintf("Not enough goalies to fufill team number request\n")

    elseif ((length(players)/num_teams) < players_per_team)
        fprintf("Not enough skaters to fufill team number request\n")
    end
end

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

                tot(i) = tot(i) + ratings(random_alloc(ct)); % add player rating

            end

            tot(i) = tot(i) + gratings(i); % add goalie rating

        end

    end

    %% Output & Loading

    ct = 0;

    fprintf("  Result #%.f ======================== \n\n", k)

    for z = 1:num_teams

        filecell{((k - 1) * num_teams) + z + 1, 1} = k;

        fprintf("%s skill: %.f\n",team_names{z}, tot(z))

        filecell{((k - 1) * num_teams) + z + 1, 2} = team_names{z};

        filecell{((k - 1) * num_teams) + z + 1, 3} = tot(z);

        fprintf("Goalie: %s, \n",goalies{z});

        filecell{((k - 1) * num_teams) + z + 1, 5} = goalies{z};

        for j = 1:players_per_team

            ct = ct + 1;

            filecell{((k - 1) * num_teams) + z + 1, 5 + j } ...
                = players{random_alloc(ct)}; % 5 col. for pre-entries

            fprintf("%s, ",players{random_alloc(ct)});

        end

        fprintf("\n\n");

    end

    filecell{((k - 1) * num_teams) + z + 1, 4} = std(tot);

    fprintf("Stdev -> %0.5f\n", std(tot))

    fprintf("\n")

end

xlswrite('output.xlsx', filecell);  % Save filecell as an Excel file
