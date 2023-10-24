### Python version:
### Update date: 10/24/2023

"""Notes & Known bugs: 
        -does not account for duplicate samples
"""

import pandas as pd
import numpy as np
import random

min_ppt = 3  # Minimum players per team
trails_requested = 1 # Trials requested per sample in team search, known errors if != 1

### User Input and Validity Check

num_teams = 2  # Number of teams per sample calculation
input_dev = 1   # Threshold to uphold as a valid sample (sample combinations will be below this number)
num_outs = 1    # Program runs until this amount of results are found

num_teams = int(input('Number of teams: '))
input_dev = int(input('Deviation Threshold (a number 0 - 10): '))
num_outs = int(input('Samples requested (program will run until this number is met): '))

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

def sample_finder():
    valid_samples = []  
    """samples that fit given deviation"""
    valid_std = []      
    """valid_samples corresponding deviation"""

    for trial in range(1,trails_requested + 1):

        ### Sample Generator

        samples_generated = 0
        """samples generated stat."""
        allocated_players = 0             
        """iterating counter to keep track of players set on a team"""
        sample_scores = [0] * num_teams  
        """scores held in a list for each team score"""
        sample = [random.sample(range(0,available_skaters),available_skaters)]  
        """returns a random sample of skater ids"""
        g_sample = [random.sample(range(0,available_goalies),num_teams)]
        """returns a random sample of goalie ids"""
        samples_generated += 1
        ### Team Score & Sample Deviation Calculator

        for i in range(1,num_teams+1):
            # print(f'Team {i}')
            for j in range(0,(skaters_per_team)):
                # print(f'    Player: {skater_names[sample[0][j + allocated_players]]} PSR: {skater_skill[sample[0][j + allocated_players]]}')
                sample_scores[i - 1] += skater_skill[sample[0][j + allocated_players]]      
                """finds each team score based on randomized sample of names"""
            allocated_players += skaters_per_team

            sample_scores[i - 1] += goalie_skill[g_sample[0][i - 1]]
            """add goalie score to the skater scores for this sample"""

        #print(f'Sample {trial} scores: [{sample_scores}]')
        
        std_score = np.std(sample_scores)
        #print(f'Std:{std_score}')

        ### Deviation Score Tally
        if std_score <= input_dev:
                
                is_duplicate = False                        
                # Duplicate sample checker
                for existing_sample in valid_samples:
                    if existing_sample[0] == sample[0]:
                        is_duplicate = True
                        break
                
                if not is_duplicate:   
                    valid_std.append(std_score)  
                    valid_samples.append(sample)

    return(valid_samples, valid_std, g_sample)

def team_name_assignment(teams_allocated):
    team_names = ['CC', 'MM', 'DIS', 'TXT']
    
    return team_names[teams_allocated - 1]


### Error Checking

if goalies_per_team < 1:
    print('Error, not enough goalies')

elif skaters_per_team < min_ppt:
    print('Error, not enough players to fulfill team allocation request')

else:
    teams_found = []
    """used to separate successful samples into correctly sized teams"""
    subscript = 0                 
    """iterative variable to designate different samples in the output file"""
    while subscript < num_outs:

        archived_valid_samples, archived_valid_std, goalie_samples = sample_finder()   
        """returns a nested list of names, and corresponding deviations for such teams"""
        
        ### Team Splitting & Reformat for Excel File
                
        if len(archived_valid_std) != len(archived_valid_samples):
            print("Number of std ~= samples")
            break

        set_allocated = 0
        
        for sublist in archived_valid_samples:
            subscript += 1
            teams_found.append((f"Sample {subscript}:", f"Deviation: {round(archived_valid_std[set_allocated],3)}"))
            """barrier element in xl file to separate sample results"""
            set_allocated += 1

            for inner_list in sublist:
                players_allocated = 0
                temp_list = []
                goalies_allocated = 0

                for sample_num in inner_list:
                    temp_list.append(skater_names[sample_num])
                    players_allocated += 1

                    ### Team Size Allocator
            
                    if players_allocated == skaters_per_team:       
                        """when proper team size is met, the team (stored as temp_list)
                        is appended to teams_found as a list inside of a list)"""
                        temp_list.sort()
                        temp_list.insert(0,goalie_names[goalie_samples[0][goalies_allocated]])  
                        goalies_allocated += 1
                        temp_list.insert(0,team_name_assignment(goalies_allocated))
                        teams_found.append(temp_list)
                        temp_list = []
                        players_allocated = 0
                        

    ### Excel Export

    file_name = "output.xlsx"
    # column_df = [""] * skaters_per_team  //// can be used later as an argument in df for column name customization
    row_colors = ['#FFBBBB', '#BBFFBB', '#FFFFCC', '#CCFFCC','#FFBBBB', '#BBFFBB', '#FFFFCC', '#CCFFCC']
    row_colors[num_teams] = 'FFFFFF'   # for the divider color

    df = pd.DataFrame(teams_found)
    excel_writer = pd.ExcelWriter(file_name, engine='xlsxwriter')
    df.to_excel(excel_writer, sheet_name='Sheet1', index=False)
    workbook = excel_writer.book
    worksheet = excel_writer.sheets['Sheet1']

    for i, row in df.iterrows():   
        """custom color pattern (change for team purpose)"""
        color = row_colors[i % (num_teams + 1)]
        worksheet.set_row(i + 2, None, workbook.add_format({'bg_color': color}))
    excel_writer.save()

    print(df)