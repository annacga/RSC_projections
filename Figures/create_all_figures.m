
load_all_data()          % find explanation of sData structure in: sData_template.m
load_LNP_results()       % if not available run analysis/cellClassification
load_decoding_results()  % if not available run decoding
load_skaggs_results()    % if not available run skaggs
helper.createRMaps;

create_figure_1;
create_figure_2;
create_figure_3;

