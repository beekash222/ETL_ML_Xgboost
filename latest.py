from re import sub, findall
import pandas as pd
import numpy as np
import  openpyxl

with open('C:\\Users\\user\\Desktop\\spider\\mismatch.txt', 'r') as myfile:
  string1 = myfile.read()

# our results go here
results1 = []

# loop through each line in the string
for line1 in string1.split("\n"):
  # get rid of leading and trailing whitespace
  line1 = line1.strip()
  # ignore empty lines
  if len(line1) > 0:
    # get the line's id
    id = line1.split("{")[0].strip()
    # get all values wrapped in parenthesis
    for match1 in findall("(\(.*?\))", string1):
      # add the string to the results list
      results1.append("{} {}".format(id, sub(r"\{|\}", "", match1)))
# display the results
results1

df = pd.DataFrame(results1)

df = df[0].str.split('(',n = 100, expand = True)
df = df[1].str.split(')',n = 100, expand = True)
df = df[0].str.split(')',n = 100, expand = True)
df = df[0].str.split(',',n = 100, expand = True)

df1 = pd.read_csv('C:\\Users\\user\Desktop\\spider\\column_name.txt', sep=',', engine='python')

df.columns = df1.columns

df.loc[::2,'TABLE'] = 'SOURCE'
df.loc[1::2,'TABLE'] = 'TARGET'

cols = list(df.columns)
cols = [cols[-1]] + cols[:-1]
df = df[cols]

df = df.drop_duplicates()

blankIndex=[''] * len(df)
df.index=blankIndex

writer = pd.ExcelWriter("C:\\Users\\user\\Desktop\\spider\\My_Output.xlsx", engine='xlsxwriter')

            
                
                 

# Convert the dataframe to an XlsxWriter Excel object. Note that we turn off
df.to_excel(writer, sheet_name='Sheet1', startrow=1, header=False)

# Get the xlsxwriter workbook and worksheet objects.
workbook  = writer.book
worksheet = writer.sheets['Sheet1']

format6 = workbook.add_format({"bg_color": "#00FFFF"})
format7 = workbook.add_format({"bg_color": "#808080"})

for i in range (0, len(df)):
    if df['TABLE'].iloc[i] == "SOURCE":
        for j in range (0, 5):
                worksheet.write(i+1, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[i], format6)
    elif df['TABLE'].iloc[i] == "TARGET":
        for j in range (0, 5):
                worksheet.write(i+1, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[i], format7)

format8 = workbook.add_format({"bg_color": "#FF0000"})
format9 = workbook.add_format({"bg_color": "#808080"})                

for j in range (0, 5):
    if df[df.columns[j]].iloc[0] != df[df.columns[j]].iloc[1]:
        worksheet.write(2, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[1], format8)
        
for j in range (0, 5):
    if df[df.columns[j]].iloc[2] != df[df.columns[j]].iloc[3]:
        worksheet.write(4, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[3], format8)

for j in range (0, 5):
    if df[df.columns[j]].iloc[4] != df[df.columns[j]].iloc[5]:
        worksheet.write(6, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[5], format8)


for j in range (0, 5):
    if df[df.columns[j]].iloc[6] != df[df.columns[j]].iloc[7]:
        worksheet.write(8, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[7], format8)
        
for j in range (0, 5):
    if df[df.columns[j]].iloc[8] != df[df.columns[j]].iloc[9]:
        worksheet.write(10, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[9], format8)
        
for j in range (0, 5):
    if df[df.columns[j]].iloc[10] != df[df.columns[j]].iloc[11]:
        worksheet.write(12, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[11], format8)             
        
for j in range (0, 5):
    if df[df.columns[j]].iloc[12] != df[df.columns[j]].iloc[13]:
        worksheet.write(14, df.columns.get_loc(df.columns[j])+1, df[df.columns[j]].iloc[13], format8)           

# Add a header format.
header_format = workbook.add_format({
    'bold': True,
    'text_wrap': True,
    'valign': 'top',
    'fg_color': '#FFFA22',
    'border': 1})

def get_col_widths(df):
    # First we find the maximum length of the index column   
    idx_max = max([len(str(s)) for s in df.index.values] + [len(str(df.index.name))])
    # Then, we concatenate this to the max of the lengths of column name and its values for each column, left to right
    return [idx_max] + [max([len(str(s)) for s in df[col].values] + [len(col)]) for col in df.columns]

for i, width in enumerate(get_col_widths(df)):
    worksheet.set_column(i, i, width)
    
# Write the column headers with the defined format.
for col_num, value in enumerate(df.columns.values):
    worksheet.write(0, col_num + 1, value, header_format)

##########return################

df1 = df.loc[df['TABLE'] == 'SOURCE']
df2 = df.loc[df['TABLE'] == 'TARGET']

df1 = df1.drop('TABLE', 1)
df2 = df2.drop('TABLE', 1)

color = 'orange'

def report_diff(x):
    return x[0] if x[0] == x[1] else 'SOURCE = {} ---> TARGET = {}'.format(*x)

# We want to be able to easily tell which rows have changes
def has_change(row):
    if "--->" in row.to_string():
        return "Y"
    else:
        return "N"

# Create a panel of the two dataframes
diff_panel = pd.Panel(dict(df1=df1,df2=df2))

#Apply the diff function
diff_output = diff_panel.apply(report_diff, axis=0)

# Flag all the changes
diff_output['has_change'] = diff_output.apply(has_change, axis=1)


diff_output.to_excel(writer, sheet_name='Sheet2', startrow=1, header=False)
# Get the xlsxwriter workbook and worksheet objects.
workbook1  = writer.book
worksheet1 = writer.sheets['Sheet2']
worksheet1.write(0,100,'')
# Add a header format.
header_format = workbook1.add_format({
    'bold': True,
    'text_wrap': True,
    'valign': 'top',
    'fg_color': '#FFFA22',
    'border': 1})


def get_col_widths(diff_output):
    # First we find the maximum length of the index column   
    idx_max = max([len(str(s)) for s in diff_output.index.values] + [len(str(diff_output.index.name))])
    # Then, we concatenate this to the max of the lengths of column name and its values for each column, left to right
    return [idx_max] + [max([len(str(s)) for s in diff_output[col].values] + [len(col)]) for col in diff_output.columns]

for i, width in enumerate(get_col_widths(diff_output)):
    worksheet1.set_column(i, i, width)
# Write the column headers with the defined format.
for col_num, value in enumerate(diff_output.columns.values):
    worksheet1.write(0, col_num + 1, value, header_format)

format2 = workbook.add_format({"bg_color": "#669731"})
format4 = workbook.add_format({"bg_color": "#A43829"})

for i in range (0, len(diff_output)):
    if diff_output['has_change'].ix[i] == "Y":
        worksheet1.write(i+1, diff_output.columns.get_loc("has_change")+1, diff_output['has_change'].ix[i], format2)
    elif diff_output['has_change'].ix[i] == "N":
        worksheet1.write(i+1, diff_output.columns.get_loc("has_change")+1, diff_output['has_change'].ix[i], format4)

format1 = workbook.add_format({"bg_color": "#C0C0C0"})
format3 = workbook.add_format({"bg_color": "#A43829"})

for i in range (0, len(diff_output)):
    if diff_output['has_change'].iloc[i] == "Y":
        for j in range (0, 4):
                worksheet1.write(i+1, diff_output.columns.get_loc(diff_output.columns[j])+1, diff_output[diff_output.columns[j]].iloc[i], format1)
    elif diff_output['has_change'].iloc[i] == "N":
        for j in range (0, 4):
                worksheet1.write(i+1, diff_output.columns.get_loc(diff_output.columns[j])+1, diff_output[diff_output.columns[j]].iloc[i], format3)

            
            
                
                    
                
          
            
    
            
    
# Close the Pandas Excel writer and output the Excel file.
writer.save() 
