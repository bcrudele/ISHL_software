% Taking in two arguments, this program should be able to allocate players
% to create fair teams. Should take into account variables such as
% predetermined weighted-player skill.

fprintf('==============================\n');
fprintf('        ISHL Team Sorter        \n');
fprintf('==============================\n\n');

min_ppt = 3; % Minimum allowed players per team
min_teams = 2;
players_per_team = 0; % Subject to user entry
num_teams = 0; % Number of teams
num_bench = 0; % Number of players to have on the bench atleast (extra)
num_players = 0;
neg_ct = 0;
int_ct = 0;

players = {'Joey', 'Teddy', 'Anthony P.', 'Andy', 'Karl', 'Anthony', 'Graham', ...
    'Jack', 'Ryan', 'Jared', 'Moo', 'Bad', 'Monk', 'You', 'Sus'};
goalies = {'Brandon', 'Sam', 'Jackabox', 'Funny monke'};
team_names = {'Chicago Charge', 'Midwest Melkmen', 'The Disappointments', ...
    'Toxic Turtles'};
fprintf("Minimum Skaters required per team -> %.f\n===\n", min_ppt);

%% User Input

while ((mod(num_players,1) ~= 0) || (num_players <= 0) )
    num_players = input('League Skaters Available: ');
    if (mod(num_players,1) ~= 0)
        int_ct = int_ct + 1;
    elseif (num_players <= 0)
        neg_ct = neg_ct + 1;
    end
    if (int_ct == 1 || neg_ct == 1)
        fprintf("\nERROR: Please enter a")
        if (int_ct == 1)
            fprintf("n integer value")
        else
            fprintf(" non-negative value")
        end
        fprintf("\n")
    end
end

neg_ct = 0;
int_ct = 0;

while ((mod(num_teams,1) ~= 0) || (num_teams <= 0) )
    num_teams = input('Number of teams requested: ');
    if (mod(num_teams,1) ~= 0)
        int_ct = int_ct + 1;
    elseif (num_teams <= 0)
        neg_ct = neg_ct + 1;
    end
    if (int_ct == 1 || neg_ct == 1)
        fprintf("\nERROR: Please enter a")
        if (int_ct == 1)
            fprintf("n integer value")
        else
            fprintf(" non-negative value")
        end
        fprintf("\n")
    end
end

%% Check validity

players_per_team = num_players/num_teams; % Number of players per team

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

random_alloc = [];

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
