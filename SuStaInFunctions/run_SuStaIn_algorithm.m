function [] = run_SuStaIn_algorithm(data,...
    min_biomarker_zscore,max_biomarker_zscore,std_biomarker_zscore,...
    stage_zscore,stage_biomarker_index,N_startpoints,N_S_max,N_iterations_MCMC,...
    likelihood_flag,output_folder,dataset_name)
% Run the SuStaIn algorithm (E-M and MCMC) and save the output

save(strcat(output_folder,'/',dataset_name,'_SuStaIn_input.mat'))

ml_sequence_prev_EM = [];
ml_f_prev_EM = [];

for s = 1:N_S_max
    [ml_sequence_EM,ml_f_EM,ml_likelihood_EM,...
        ml_sequence_mat_EM,ml_f_mat_EM,ml_likelihood_mat_EM] = ...
        estimate_ML_SuStaIn_model_Nplus1_Clusters(data,...
        min_biomarker_zscore,max_biomarker_zscore,std_biomarker_zscore,...
        stage_zscore,stage_biomarker_index,ml_sequence_prev_EM,ml_f_prev_EM,N_startpoints,likelihood_flag);
    
    save(strcat(output_folder,'/',dataset_name,'_EM_',num2str(s),'Seq.mat'),...
        'ml_sequence_EM','ml_f_EM','ml_likelihood_EM',...
        'ml_sequence_mat_EM','ml_f_mat_EM','ml_likelihood_mat_EM');
    
    seq_init = ml_sequence_EM;
    f_init = ml_f_EM;
    [ml_sequence,ml_f,ml_likelihood,...
        samples_sequence,samples_f,samples_likelihood] = estimate_uncertainty_SuStaIn_model(data,...
        min_biomarker_zscore,max_biomarker_zscore,std_biomarker_zscore,...
        stage_zscore,stage_biomarker_index,...
        seq_init,f_init,N_iterations_MCMC,likelihood_flag);
    
    save(strcat(output_folder,'/',dataset_name,'_MCMC_',num2str(s),'Seq.mat'),...
        'ml_sequence','ml_f','ml_likelihood',...
        'samples_sequence','samples_f','samples_likelihood');
    
    ml_sequence_prev_EM = ml_sequence_EM;
    ml_f_prev_EM = ml_f_EM;
end

