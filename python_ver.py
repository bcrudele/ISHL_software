# Python version:
# Update date: 10/16/2023

import pandas as pd
import numpy as np
import random

min_ppt = 2  # Minimum players per team
min_teams = 2 # Minimum teams needed in the league
ppt = 0 # Players per team (requested in UI)
trails_requested = 3 # Trials requested for team search
team_names = ['Chicago Charge', 'Midwest Melkmen', 'The Disappointments', 'Toxic Turtles']

# User Input and Validity Check

num_teams = 2  # testing values
num_players = 4 # testing values
input_dev = 4   # testing values
num_outs = 1    # testing values

data = pd.read_excel(r"skills.xlsx") 

skater_names = data.iloc[:,0]  # Skater names 
skater_skill = data.iloc[:,1]  # Skater skill (1-10)
goalie_names = data.iloc[:,2]  # Goalie names
goalie_skill = data.iloc[:,3]  # Goalie skill (1-10)
availability = data.iloc[:,4]  # first value is skater tot. second value is goalie tot.

skaters_per_team = int(availability[0]) // num_teams  # skaters needed per team
goalies_per_team = int(availability[1]) // num_teams  # goalies needed per team

available_skaters = int(availability[0])        # total available skater
available_goalies = int(availability[1])        # total available goalies

if goalies_per_team < 1:
    print('Error, not enough goalies')

def sample_finder():
    valid_samples = []  # samples that fit given deviation
    for trial in range(1,trails_requested + 1):

        allocated_players = 0
        sample_scores = [0] * num_teams
        sample = [random.sample(range(0,available_skaters),available_skaters)]

        trial += 1
        for i in range(1,num_teams+1):
            # print(f'Team {i}')
            for j in range(0,(skaters_per_team)):
                # print(f'    Player: {skater_names[sample[0][j + allocated_players]]} PSR: {skater_skill[sample[0][j + allocated_players]]}')
                sample_scores[i - 1] += skater_skill[sample[0][j + allocated_players]]      # finds each team score
            allocated_players += skaters_per_team

        # print(f'Sample {trial} scores: [{sample_scores}]')
        std_score = np.std(sample_scores)
        # print(f'Std:{std_score}')

        if std_score <= input_dev:
                is_duplicate = False   # duplicate checker
                for existing_sample in valid_samples:
                    if existing_sample[0] == sample[0]:
                        is_duplicate = True
                        break
    
                if not is_duplicate:     
                    valid_samples.append(sample)

    return(valid_samples)

archived_valid_samples = sample_finder()

teams_found = []

for sublist in archived_valid_samples:
    for inner_list in sublist:
        players_allocated = 0
        temp_list = []
        for sample_num in inner_list:
            temp_list.append(skater_names[sample_num])
            players_allocated += 1

            if players_allocated == skaters_per_team:
                teams_found.append(temp_list)
                temp_list = []
                players_allocated = 0

print (teams_found)