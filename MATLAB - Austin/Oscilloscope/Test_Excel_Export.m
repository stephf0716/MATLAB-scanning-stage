td1 = [1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9];
td2 = [9 8 7 6 5 4 3 2 1 9 8 7 6 5 4 3 2 1 9 8 7 6 5 4 3 2 1 9 8 7 6 5 4 3 2 1];
filename = 'testdata.xlsx';
td1 = td1.';
td2 = td2.';
test_data = [td1 td2];
xlswrite(filename, test_data, 'Data', 'B2:C36')
warning('off','MATLAB:xlswrite:AddSheet')