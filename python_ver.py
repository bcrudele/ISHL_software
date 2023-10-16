# Python version:
# Update date: 10/16/2023

import pandas as pd
import numpy as np
import random

min_ppt = 2  # Minimum players per team
min_teams = 2 # Minimum teams needed in the league
ppt = 0 # Players per team (requested in UI)
team_names = ['Chicago Charge', 'Midwest Melkmen', 'The Disappointments', 'Toxic Turtles']

# User Input and Validity Check

num_teams = 2  # testing values
num_players = 6 # testing values
input_dev = 4   # testing values
num_outs = 1    # testing values

data = pd.read_excel(r"skills.xlsx") 

skater_names = data.iloc[:,0]  # Skater names 
skater_skill = data.iloc[:,1]  # Skater skill (1-10)
goalie_names = data.iloc[:,2]  # Goalie names
goalie_skill = data.iloc[:,3]  # Goalie skill (1-10)
availability = data.iloc[:,4]  # first value is skater tot. second value is goalie tot.

skaters_per_team = availability[0] // num_teams  # skaters needed per team
goalies_per_team = availability[1] // num_teams  # goalies needed per team

available_skaters = int(availability[0])        # total available skater
available_goalies = int(availability[1])        # total available goalies

if goalies_per_team < 1:
    print('Error, not enough goalies')

allocated_players = 0
sample = [random.sample(range(0,available_skaters),available_skaters)]
print(f'Sample -> {sample}')
for i in range(1,num_teams+1):
    print(f'Team {i}')
    for j in range(0,(available_skaters)):
        print(f'    Skater -> {skater_names[sample[0][j]]}')
    
    # another method could be sorting descending then sort per team
