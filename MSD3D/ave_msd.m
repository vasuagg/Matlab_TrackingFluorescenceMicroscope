function ave_dx=ave_msd(dx,T)

for j=1:1:length(T)
    w_dx(j,:)=(T(j)/sum(T))*dx(j,:);
end

ave_dx=sum(w_dx,1);