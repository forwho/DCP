function network_properties_fornki(A,n,ID)
% clustering coefficient was conculated according to Onnela et al.'s paper;
% The random matrix was generated using a modified Maslov's wiring program (Maslov and Sneppen 2002).
% When the edges are randomly rewired, their weights are not changed;
% n =500;

%small-world
[N, K, degree, sw] =  gretna_sw_harmonic_weight_noNormalization(A, 2, 2,n);
% efficiency
[eff] = gretna_efficiency_weight_noNormalization (A, A);

%modularity
% M = gretna_modularity (A,n, '2');
% for num_modular=1:max(max(M.node))
%     module{num_modular}=find(M.node==num_modular);
% end   
% PC = gretna_parcoeff(A, module);
[Ci Q]=modularity_und(A);
for num_modular=1:max(max(Ci))
    module{num_modular}=find(Ci==num_modular);
end   
PC = gretna_parcoeff(A, module);

save(['network_prop_' ID],'N','K','degree','sw','eff','Q','Ci');
% save(['network_prop_' ID],'N','K','sw','sw_eff','Q','PC','rc','rc_norm');
