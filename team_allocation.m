% Taking in two arguments, this program should be able to allocate players
% to create fair teams. Should take into account variables such as
% predetermined weighted-player skill.

fprintf('==============================\n');
fprintf('        ISHL Team Sorter        \n');
fprintf('==============================\n\n');

min_ppt = 3; % Minimum allowed skaters per team
min_teams = 2; % Minimum teams allowed in league
players_per_team = 0; % Ratio of players per team requested (subject to UI)
num_teams = -1; % Number of teams requested
num_players = -1; % Number of skaters (DNI GOALIES)

players = {'x', 'y', 'z', 'p', 'q', 'u'};
    % 'Name8', 'Name9', 'Name10', 'Name11', 'Name12', 'Name13', 'Name14', 'Name15'};
ratings = [10 4 6 7 8 8];
goalies = {'Goalie1', 'Goalie2', 'Goalie3', 'Goalie4'};
team_names = {'Chicago Charge', 'Midwest Melkmen', 'The Disappointments', ...
    'Toxic Turtles'};

%% User Input

while ((mod(num_players,1) ~= 0) || (num_players <= 0) )
    fprintf("Players Available: ")
    num_players = errorHandler(num_players);
end

while ((mod(num_teams,1) ~= 0) || (num_teams <= 0) )
    fprintf("Teams Requested: ")
    num_teams = errorHandler(num_teams);
end

%% Check validity

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

%% Shuffle Function

tot = zeros(1,num_teams);
random_alloc = [];  % To be shuffled indexing vector

values = 1:num_players;

% Shuffle the vector of values using the randperm function
shuffled_values = randperm(num_players);

% Loop over the shuffled values and select each value once
for i = 1:num_players
    % Select the next shuffled value
    selected_value = values(shuffled_values(i));
    random_alloc(i) = selected_value;
end

ct = 0;

%% Output & Loading

if ~((players_per_team < min_ppt) || (num_teams < min_teams) || ...
        (num_teams > length(goalies)) || ...
        ((length(players)/num_teams) < players_per_team) )

    for i = 1:num_teams

        fprintf("\nTeam %s\n\n", team_names{i});

        fprintf("Goalie: %s, \n",goalies{i});

        for j = 1:players_per_team

            ct = ct + 1;

            fprintf("%s, ",players{random_alloc(ct)});
          
            tot(i) = tot(i) + ratings(random_alloc(ct));
            fprintf("\n")

        end
    end

    if ((num_players - ct) >= 1)

        fprintf("\n\nBenched Players\n");
        for i = 1:(num_players - ct)

            fprintf("%s,\n",players{random_alloc(i+ct)})
        end
    end
end
