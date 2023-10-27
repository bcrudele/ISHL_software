<h1 align="center">Team Allocator Algorithm</h1>

<p align="center">
  <img src="https://github.com/bcrudele/ISHL_software/assets/120442376/30b6321d-eec8-4ef2-8e5e-b62101f542a9.png" alt="Project Logo" width="150" height="150">
</p>

<p align="center">
  <strong>Allocates players to teams within a range of skill differences.</strong>
</p>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#usage">MATLAB Usage</a>
  <a href="#usage">Python Usage</a>
  
</p>

## Key Features

- Dynamic Entry: The algorithm requires user entry to run according to your standards. A number of teams, max skill deviation, and total samples are requested from the user before the algorithm begins. This allows for highly modular results.
- skills.xlsx: Template Excel file provides easy entry of player data and analytics.
- Output File: Generates 'output.xlsx' file for export. 

## MATLAB Usage

1. Ensure skills.xlsx is in the same folder as the runtime folder.
2. Fill out skills.xslx data sheet. Do NOT adjust pre-calculated count values in Col. 5.
3. Run through MATLAB R2022 or better.
4. Follow terminal prompts.
5. Excel file is saved with a time-stamp in the corresponding folder.

<p align="center">
  <img src="https://github.com/bcrudele/ISHL_software/assets/120442376/3799dd9f-4910-4671-935f-cbfee944c43e.png" alt="Project Screenshot">
</p>

## Python Usage

1. Ensure skills.xlsx is in the same folder as team_finder.exe
2. Fill out skills.xlsx data sheet. You can add/remove players and their corresponding skill. 
3. Terminal will appear, follow GUI input prompt for each input. This program can support up to 6 teams per sample.
4. Possible team combinations are saved to an Excel file in the same folder.

<p align="center">
  <img src="https://github.com/bcrudele/ISHL_Website/blob/main/images/python_ver_sample.png" alt="Project Screenshot">
</p>

