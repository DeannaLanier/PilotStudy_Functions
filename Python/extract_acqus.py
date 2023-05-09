import os
import pandas as pd

def extract_acqus(dir_path, save=False):

# Created in python3
# Date 05/08/2023
# Author: Deanna Lanier

# Description: extract_acqus searches a directory of raw data folders for the 'acqus' file
# assocuated with each sample. It parses that file and save the data in a data frame with the following format
# Col1 = File_ID; Col2 = Date data were acquired; Col3 = Time data were acquired; and Col4 = Other information

# Input :
    # dir_path = the path to the directory that contains your raw data (pruker format)
    # save = True/False (default is False) will save your file into the working directory when True

# Output:
    # if save = True, acqus_info.csv
    # dataframe 
    
    # Check if directory exists
    if not os.path.isdir(dir_path):
        raise ValueError("Directory not found.")
    
    # Initialize empty lists to store folder names and file information
    folder_names = []
    file_info = []
    
    # Inialize the file name we are searching for
    file_name = "acqus"

    # Walk through all subdirectories and search for the file name
    for dirpath, dirnames, filenames in os.walk(dir_path):
        if file_name in filenames:
            
            # Get the full path of the file
            file_path = os.path.join(dirpath, file_name)
            with open(file_path, 'r') as f:
                
                # Read the first 7 lines of the file
                file_lines = f.readlines()[0:7]
                
                # Extract the information from the line that starts with $$
                file_info_line = [line.strip() for line in file_lines if line.startswith('$$')][0]

                # Extract the subdirectory name and store it in the list
                folder_names.append(os.path.basename(dirpath))
                
                # Add the file information to the list
                file_info.append(file_info_line.split('$$ ')[1])

    # Create a dataframe with two columns: 'Subdirectory Names' and 'File Information'
    df = pd.DataFrame({'File_ID': folder_names, 'File_Information': file_info})
    df[['Date', 'Time', 'Other']] = df['File_Information'].str.split(' ', 2, expand=True)
    df['Date'] = pd.to_datetime(df['Date'], format='%Y-%m-%d')
    df['Time'] = pd.to_datetime(df['Time'], format='%H:%M:%S.%f').dt.time
    df = df.sort_values(by=['File_ID'])
    df = df.drop('File_Information', axis=1)
    
    # Save dataframe as csv if save=True
    if save:
        df.to_csv('acqus_info.csv', index=False)
    
    return df
