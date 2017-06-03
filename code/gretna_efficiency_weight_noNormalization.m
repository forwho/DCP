function [eff] = gretna_efficiency_weight_noNormalization (A, B)


% =========================================================================
% This function is used to calculate the global and local efficiency of a
% graph (i.e. network) G (Latora and Marchiori, 2001) that are
% characterized by a adjacent connectivity matrix and a weight matrix B.
%
% function [eff] = gretna_efficiency_weight(A, B)
%
% input:
%           A:
%               a weighted matrix of corresponding to adjacency matrix.
%           B:
%               the whole weighted matrix, i.e., all possible edges exist
%
% output:
%       eff.gE:
%               global efficiency of a graph G (corresponding to global
%               average path length).
%       eff.localE:
%               local efficiency of a graph G (corresponding to average
%               clustering coefficient).
%       eff.regionallocalE:
%               regionally local efficiency of each node in a graph G (like
%               clustering coefficient of each node).
%       eff.regionalglobalE:
%               regionally nodal efficiency of each node in a graph G.
%               (This measure can be used to identify hub nodes of the
%               graph G. A high value indicates a high ability to manage
%               information flow of the network).
%
% Reference:
% 1. Latora V, Marchiori M (2001, 2003) Efficient behavior of small-world
% networks. Phys Rev Lett 87: 198701.
%
% Yong HE, BIC, MNI, McGill 2007/05/01
% Jinhui Wang, ICNL, BNU 2008/03/11
% =========================================================================

A = A - diag(diag(A));
A = abs(A);
N = length(A);

B = B - diag(diag(B));
B = abs(B);

% NNA = length(find(A~=0));
% A = A/(sum(sum(A))/NNA);
% B = B/(sum(sum(B))/(N*(N-1)));

E = find(A); A(E) = 1./A(E);
E = find(B); B(E) = 1./B(E);


D0 = gretna_pathlength_wei(A);
D1 = gretna_pathlength_wei(B);
for i=1:N
    D0(i,i) = inf;
    D1(i,i) = inf;
end
eff0 = 1./D0;
eff1 = 1./D1;
% global efficiency of a graph
gE = sum(sum(eff0))/(N*(N-1));%加权图的Eglob
ideal_gE = sum(sum(eff1))/(N*(N-1));%理想加权图的Eglob,即所有的边都存在

% global efficiency of each node;
regionalglobalE = sum(eff0,2)/(N-1);
ideal_regionalglobalE = sum(eff1,2)/(N-1);

for i = 1:N
    NV =  find(A(i,:));
    if length(NV)==0 | length(NV)==1
        regionallocalE(i,1) = 0;
        ideal_regionallocalE(i,1) = 0;
    else
        C = A(NV,NV);
        DL = gretna_pathlength_wei(C);
        for kk = 1:length(NV)
            DL(kk,kk) = inf;
        end
        localeff0 = 1./DL;
        % local efficiency of each node
        regionallocalE(i,1)  = sum(sum(localeff0))/(length(NV)*(length(NV)-1)) ;

        E = B(NV,NV);
        DW = gretna_pathlength_wei(E);
        for kk =1:length(NV)
            DW(kk,kk) = inf;
        end
        localeff1 = 1./DW;
        ideal_regionallocalE(i,1)  = sum(sum(localeff1))/(length(NV)*(length(NV)-1)) ;
    end
end

localE = sum(regionallocalE)/N;
ideal_localE = sum(ideal_regionallocalE)/N;

% efficiency in a weighted graph (thresholded);
eff.gE = gE;
eff.locE = localE;
eff.regionallocalE = regionallocalE;
eff.regionalglobalE = regionalglobalE;

% efficiency in an ideal graph (i.e,correlation matrix);
eff.ideal_gE = ideal_gE;
eff.ideal_locE = ideal_localE;
eff.ideal_regionallocalE = ideal_regionallocalE;
eff.ideal_regionalglobalE = ideal_regionalglobalE;

%normalized efficiency
eff.ngE = eff.gE/eff.ideal_gE; 
eff.nlocE = eff.locE/eff.ideal_locE;
eff.nregionallocalE = eff.regionallocalE./eff.ideal_regionallocalE;
eff.nregionalglobalE = eff.regionalglobalE./eff.ideal_regionalglobalE;

return




function D = gretna_pathlength_wei(G)

%Characteristic path length for weighted graph G (Dijkstra's algorithm)
% 
% Mika Rubinov, 2007
% =========================================================================

n = length(G);
D = zeros(n); D(~eye(n)) = inf;     %distance matrix

for u = 1:n
    S = true(1,n);                %distance permanence (true is temporary)
    G1 = G;
    V = u;
    while 1
        S(V) = 0;                 %distance u->V is now permanent
        G1(:,V) = 0;              %no in-edges as already shortest
        for v = V
            W = find(G1(v,:));	%neighbours of shortest nodes
            for w = W;
                D(u,w) = min(D(u,w),D(u,v)+G1(v,w));
                %the smallest of old (if exist) and current path lengths
            end
        end

        minD = min(D(u,S));
        if isempty(minD)||isinf(minD), break, end;
        %isempty: all nodes reached; isinf: some nodes cannot be reached
        V = find(D(u,:)==minD);
    end
end
return