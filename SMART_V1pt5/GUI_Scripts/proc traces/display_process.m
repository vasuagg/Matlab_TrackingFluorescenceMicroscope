function output = display_process




  
        %columnnames  = {'mr1' 'stdr1' 'mr2' 'stdr2' 'mr3' 'stdr3' 'mr4' 'stdr4' 'fitChannelType'};
        
        table_data = cell(24,11);
        
        table_data{1,1} = 'HHM';
        table_data{1,2} = 'yes';
                
        
        table_data{2,1} = 'maxIterEM';
        table_data{2,2} = 200;
        
        table_data{2,3} = 'threshEMToConverge';
        table_data{2,4} = 10E-6;
       

        table_data{3,1} = 'Einitial';
        table_data{3,2} = 'auto';
        
        table_data{3,3} = 'Ainitial';
        table_data{3,4} = 'auto';
        
        table_data{4,1} = 'auto_boundsMeshSize';
        table_data{4,2} = 20;
              
        table_data{4,3} = 'auto_confInt';
        table_data{4,4} = 0.97;
        
        table_data{5,1} = 'auto_MeshSpacing';
        table_data{5,2} = 'auto';
        
        table_data{6,1} = 'Detailed Balance';
        table_data{6,2} = 0;
        
        
        
        
        table_data{8,1} = 'Chanel Spec';
        table_data{8,2} = 'C1';
        table_data{8,3} = 'C2';
        table_data{8,4} = 'C3';
        table_data{8,5} = 'C4';
       
        table_data{9,1} = 'fitChannelType';
        table_data{9,2} = 'gauss';
        table_data{9,3} = 'gauss';
        table_data{9,4} = '';
        table_data{9,5} = '';
        
        table_data{10,1} = 'Error State mr';
        table_data{10,2} = 1;
        table_data{10,3} = 1;
        table_data{10,4} = [];
        table_data{10,5} = [];
        
        table_data{12,1} = 'nStates';
        table_data{12,2} = 2;
           
        table_data{13,1} = 'discStates';

        table_data{13,2} = 1;
        table_data{13,3} = 2;
        table_data{15,3} = 1;
        table_data{16,2} = 1;
        
        table_data{14,1} = 'State Spec';
        table_data{14,2} = 'State 1';
        table_data{14,3} = 'State 2';
        table_data{14,4} = 'State 3';
        table_data{14,5} = 'State 4';
        table_data{14,6} = 'State 5';
        table_data{14,7} = 'State 6';
        table_data{14,8} = 'State 7';
        table_data{14,9} = 'State 8';
        table_data{14,10} = 'State 9';
        table_data{14,11} = 'State 10';
        
        table_data{15,1} = 'State 1';
        table_data{16,1} = 'State 2';
        table_data{17,1} = 'State 3';      
        table_data{18,1} = 'State 4';
        table_data{19,1} = 'State 5';
        table_data{20,1} = 'State 6';
        table_data{21,1} = 'State 7';
        table_data{22,1} = 'State 8';
        table_data{23,1} = 'State 9';
        table_data{24,1} = 'State 10';
                                        

        
        
        
        
        
        
        
        
        table_spec.default_table1 = table_data;
        table_spec.user_table1 =  table_data;
         
       
        
        table_data = cell(24,11);
        
        
        table_data{1,1} = 'FPS';
        %table_data{1,2} = ;
              
        table_data{2,1} = 'temp';
        table_data{2,2} = 298;
        
        
        table_data{7,1} = 'FRET Spec';
        table_data{7,2} = 'no';
        
        table_data{8,1} = 'Cross Talk';
        table_data{8,2} = 0.05;
        
        table_data{9,1} = 'smooth';
        table_data{9,2} = 'no';
        
        table_data{10,1} = 'threshold';
        table_data{10,2} = 0.45;
        
        table_data{11,1} = 'fret_cutoff';
        table_data{11,2} = -0.2;
        table_data{11,3} = 1.2;
        

        

        
        
        table_spec.default_table2 = table_data;
        table_spec.user_table2 =  table_data;
        
  

        
        output  = table_spec;
