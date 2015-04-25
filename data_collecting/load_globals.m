function load_globals(N,distribution,indx)
global grid_width nx ny code_redundence nodeNum nodes ;
path = 'data/';
filename = build_data_file_name(N,distribution,indx);
filename = [path filename];
if exist(filename,'file')
    load(filename);
end
end