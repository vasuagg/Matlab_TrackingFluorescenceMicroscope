
function output = initialize_temp_summary






temp_summary.proc_spec = [];

temp_summary.trace_info =[];

temp_summary.trace = [];

temp_summary.hmm_output.A = [];
temp_summary.hmm_output.E = {};
temp_summary.hmm_output.fitChannelType = {};
temp_summary.hmm_output.errorBoundsAuto = [];
temp_summary.hmm_output.errorBoundsManual = [];
temp_summary.hmm_output.auto_confInt = [];
temp_summary.hmm_output.logPx = [];
temp_summary.hmm_output.BIC = [];
temp_summary.hmm_output.SNRMat = [];
temp_summary.hmm_output.discStates = [];
temp_summary.hmm_output.noHops = [];
temp_summary.hmm_output.flags = [];
temp_summary.hmm_output.normF = [];
temp_summary.hmm_output.A_disc = [];
temp_summary.hmm_output.P = [];
temp_summary.hmm_output.reshape.rate_1to1 = NaN;
temp_summary.hmm_output.reshape.rate_1to1_error = []; %cell(1,0);


temp_summary.mod_temp_trace = [];

temp_summary.fret_summary.dltg = NaN;
temp_summary.fret_summary.mean_total_i = NaN;
temp_summary.fret_summary.snr = NaN;

temp_summary.threshold_summary.thresholded = [3 1 NaN -3; 0 1 NaN 3];
temp_summary.threshold_summary.k2to1_single = [];
temp_summary.threshold_summary.k2to1_xval = NaN;
temp_summary.threshold_summary.k2to1_single_yval = [];
temp_summary.threshold_summary.k2to1_single_residuals = NaN;
temp_summary.threshold_summary.k2to1_dobule = [NaN NaN NaN];
temp_summary.threshold_summary.k2to1_dobule_yval = [];
temp_summary.threshold_summary.k2to1_dobule_residuals = NaN;
temp_summary.threshold_summary.k1to2_single = [];
temp_summary.threshold_summary.k1to2_xval = NaN;
temp_summary.threshold_summary.k1to2_single_yval = [];
temp_summary.threshold_summary.k1to2_single_residuals = NaN;
temp_summary.threshold_summary.k1to2_dobule = [NaN NaN NaN];
temp_summary.threshold_summary.k1to2_dobule_yval = [];
temp_summary.threshold_summary.k1to2_dobule_residuals = NaN;




%thresh_summary.thresholded = [3 1 NaN -3; 0 1 NaN 3];
%thresh_summary.k1to2_xval = 10^3
% thresh_summary.k1to2_single_residuals = NaN;
% thresh_summary.k1to2_dobule_residuals = NaN;
% thresh_summary.k1to2_dobule = [NaN NaN NaN];
% thresh_summary.k2to1_dobule = [NaN NaN NaN];


output = temp_summary;


