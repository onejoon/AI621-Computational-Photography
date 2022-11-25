function [HDR_log] = log_merge(ws, ims, ims_lin, logtk)
% ws : weight scheme

HDR_log = zeros(size(ims{1},1),size(ims{1},2),size(ims{1},3));

if strcmp(ws,'uniform')
    disp('Uniform weighting scheme...')
    for i=1:16
        w_tmp = ones(size(ims{i},1),size(ims{i},2),size(ims{i},3))/16;
        HDR_log = HDR_log + w_tmp.*(ims_lin{i}-logtk(i));
    end
end 

if strcmp(ws,'gaussian')
    disp('Gaussian weighting scheme...')
    W_sum = zeros(size(ims{1},1),size(ims{1},2),size(ims{1},3));
    for i=1:16
        w_tmp = normpdf(ims{i},0.5,0.2);
        W_sum = W_sum + w_tmp;
    end
    for i=1:16
        w_tmp = normpdf(ims{i},0.5,0.2);
        HDR_log = HDR_log + w_tmp./W_sum.*(ims_lin{i}-logtk(i));
    end
end 

HDR_log = exp(HDR_log);

end

