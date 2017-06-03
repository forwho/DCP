function [N, K, degree, sw] = gretna_sw_harmonic_weight_noNormalization(A,wCptype, randtype, n)

% *************************************************************************
% This function is used to calculate the small-world properties (weighted
% clustering and "harmonic mean" path length) and several other related
% measures of a weighted graph (i.e. network) G that is characterized by a
% weighted connectivity matrix A with nodes N and edges K. Note that the
% small-world properties were calcualted based on the WHOLE graph.
%
%
% function [N, K, degree, sw] = gretna_sw_harmonic_weight(A,wCptype, randtype, n)
%
% input:
%           A:
%                   A weighted matrix (N*N, symmetric), e.g. an
%                   inter-regional correlation matrix (Rij, i,j=1...N).
%
%        wCptype:
%                   The definition of weighted clustering coefficient
%                   (weighted Cp). 1: Calculate weighted clustering
%                   coefficient according to Barrat et al.'s paper(PNAS
%                   2004).2: Calculate weighted clustering coefficient
%                   according to Onnela et al.'s paper (Physical Review E
%                   2005) (default).
%        randtype:
%                   0: no random matrix was generated; only get the
%                   absolute values of weighted Cp, Lp of the real netwok
%                   G; 1: The random matrix was generated using a modified
%                   Maslov's wiring program (Maslov and Sneppen 2002).
%                   Weights are randomly redistributed on the network.
%                   2: The random matrix was generated using a modified
%                   Maslov's wiring program (Maslov and Sneppen 2002).
%                   When the edges are randomly rewired, their weights are
%                   not changed (default).
%           n:
%                   The number of generated random matrix (default: n =
%                   100)
%
% output:
%           N:
%                   The number of nodes in the graph G
%           K:
%                   The number of edges in the graph G
%    degree.avedeg:
%                   The average connectivity (degree) in the graph G (i.e.
%                   the average of the degree over all nodes, where the
%                   degree of a node corresponds to the number of
%                   connections to that node).
%       degree.deg:
%                   The total strength of connections for each node. (This
%                   measure is usually used to look at the connectivity
%                   degee distribution of the graph G).
%            sw.Cp:
%                   The average weighted clustering coefficient of the
%                   weigthed graph G (i.e. the average of the clustering
%                   coefficient over all nodes, where the clustering
%                   coefficient of a node is defined as the number of
%                   existing connections between the node’s neighbors
%                   divided by all their possible connections (Watts and
%                   Strogatz 1998). If a node i has only an edge or no
%                   edges, so C(i) = 0;
%            sw.Lp:
%                   The global "harmonic" weighted shortest path length of
%                   the weighted graph G. 1/Lp = sum(sum(1/dij))/(N*(N-1).
%                   This modified path length is slightly different from
%                   the traditional path length, i.e. Lp =
%                   sum(sum(dij))/(N*(N-1)). This modififed definition has
%                   advantages in calculating the properties of a network
%                   with multiple components (Newman 2003).
%         sw.Gamma:
%                   The relative clustering coefficient (Gamma =
%                   Cp/meanCprand)
%        sw.Lambda:
%                   The relative shortest path length (Lambda =
%                   Lp/meanLprand)
%         sw.Sigma:
%                   A scalar small-world parameter (Sigma = Gamma/Lambda)
%
% For example:
%
% load Rij.txt;
% Rij: a symmetric correlation matrix (N*N)
% 
% sparsity = 0.10;
% [bmatrix] = gretna_R2b(Rij,'s',sparsity);
% data_r = Rij.*bmatrix;
% [N, K, degree, sw] =  gretna_sw_harmonic_weight(data_r, 2, 2,100);
% 
% 
% 1. wCp: Onnela's approach; no randomization
%   [N, K, degree, sw] =  gretna_sw_harmonic_weight(data_r, 2, 0, 0)
%
% 2. wCp: Barrat's approach; no randomization
%   [N, K, degree, sw] =  gretna_sw_harmonic_weight(data_r, 1, 0, 0)
% 
% 3. wCp: Onnela's approach; random: weight-edge randomization
%   [N, K, degree, sw] =  gretna_sw_harmonic_weight(data_r, 2, 2,100)
% 
% 4. wCp: Onnela's approach; random: weights redistributed
%   [N, K, degree, sw] =  gretna_sw_harmonic_weight(data_r, 2, 1,100)
% 
% 5. wCp: Barrat's approach; random: weight-edge randomization
%   [N, K, degree, sw] =  gretna_sw_harmonic_weight(data_r, 1, 2,100)
% 
% 6. wCp: Barrat's approach; random: weights redistributed
%   [N, K, degree, sw] =  gretna_sw_harmonic_weight(data_r, 1, 1,100)
% 
% It is noted that a small-world network should met the following criteria:
% Gamma >>1, Lambda ~1, Sigma >>1 (Watts and Strogatz 1998; Humphries et
% al., 2005;)
%
%
% References:
% 1. Watts DJ, Strogatz SH (1998) Collective dynamics of 'small-world'
% networks. Nature 393:440-442.
%
% 2. Maslov S, Sneppen K (2002) Specificity and stability in topology of
% protein networks. Science 296:910-913.
%
% 3. Humphries MD, Gurney K, Prescott TJ (2005) The brainstem reticular
% formation is a small world, not scale-free, network. Proc R Soc Lond B
% Biol Sci, 273:503-511.
%
% 4.Newman MEJ. The structure and function of complex networks. Siam
% Rev 2003;45(2):167–256.
%
% 5. Barrat A, Barthelemy M, Pastor-Satorras R, Vespignani A (2004) The
% architecture of complex weighted networks. Proc Natl Acad Sci U S A
% 101:3747-3752. 
% 
% 6. Onnela J-P, Saramaki J, Kertesz J, Kaski K. Intensity and coherence of
% motifs in weighted complex networks. Phys Rev E 2005; 71: 065103.
% 
% 
% Modified by Jinhui Wang based on previous work by Yong He, 2008/10/28
% *************************************************************************


if nargin < 1
    error('No input parameters'); end

if nargin == 1
    wCptype = 2; randtype = 2; n = 100; end

if nargin == 2
    randtype = 2; n = 100; end

if nargin == 3
    n = 100; end

if nargin > 4
    error('Too many input parameters, 1 <= the numer of parameters <= 3');end

% calculate the small world measurements
warning off;
A = A - diag(diag(A));
A = abs(A);
N = length(A);
degree.AveDeg = sum(sum(A))/N;
degree.Deg = sum(A,2);

% A = A/(sum(sum(A))/2);
% NNA = length(find(A~=0));
% A = A/(sum(sum(A))/NNA);
K = length(find(A))/2;

Original_A = A;
E=find(A); A(E) = 1./A(E); %invert weights: large -> short


D_real = Wei_gretna_pathlength(A);
D_real = D_real + diag(diag(1./zeros(N)));
Lp_real = 1/(sum(sum(1./D_real))/(N*(N-1)));

% weighted clustering coefficient
if wCptype == 1
    [Cp_real sw.Ci] = Wei_gretna_clustcoeff(Original_A,1);%算Cp的时候用原始的相关矩阵算，而不应该用取倒数后的矩阵
else
    [Cp_real sw.Ci] = Wei_gretna_clustcoeff(Original_A,2);%算Cp的时候用原始的相关矩阵算，而不应该用取倒数后的矩阵
end

if randtype ~= 0
    for i = 1:n
        fprintf('-');
        if randtype == 1
            RandweiM = Wei_sym_generate_srand(Original_A);
        else
            RandweiM = Wei_sym_generate_srand_WD(Original_A);
        end
        Original_RandweiM = RandweiM;
        Rand_E = find(RandweiM); RandweiM(Rand_E) = 1./RandweiM(Rand_E);

        D_rand = Wei_gretna_pathlength(RandweiM);
        D_rand = D_rand + diag(diag(1./zeros(N)));
        Lp_rand(i) = 1/(sum(sum(1./D_rand))/(N*(N-1)));

        if wCptype == 1
            [Cp_rand(i) cci_rand] = Wei_gretna_clustcoeff(Original_RandweiM,1);
        else
            [Cp_rand(i) cci_rand] = Wei_gretna_clustcoeff(Original_RandweiM,2);
        end
    end
    sw.Gamma = Cp_real/mean(Cp_rand);
    sw.Lambda = Lp_real/mean(Lp_rand);
    sw.Sigma = sw.Gamma/sw.Lambda;
end

sw.Cp = Cp_real;
sw.Lp = Lp_real;
sw.Dmatrix = D_real;
sw.regEff = sum(1./D_real,2)/(N*(N-1));

fprintf('finished!\n');

return



function D = Wei_gretna_pathlength(G)

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



function [avercc cci] = Wei_gretna_clustcoeff(W,type)

if type==1 %barrat
    A = W;
    N = size(A,1);
    cci = [];

    for i = 1:N
        NV = find(A(i,:));
        if length(NV) == 1 | length(NV) == 0
            cc = 0;
        else
            nei = A(NV,NV);
            [X Y] = find(nei);
            cc = sum([A(i,NV(X)) A(i,NV(Y))])/2/((length(NV)-1)*sum(A(i,:)));
        end
        cci = [cci cc];
    end
    avercc = mean(cci);
else
    %Onnela's weighted clustering coefficient for directed/undirected graphs
    %from Fagiolo 2006, arXiv:physics/0612169v2
    %
    % Mika Rubinov, 2007

    %avercc: the average clustering coefficient of the graph G.
    % cci: the clustering coefficiency of each node of the graph G
    % =========================================================================

    A=W ~= 0;                     %adjacency matrix
    S = W.^(1/3)+(W.').^(1/3);	%symmetrized weights matrix ^1/3
    K = sum(A+A.',2);            	%total degree (in + out)
    cyc3 = diag(S^3)/2;           %number of 3-cycles (ie. directed triangles)
    K(cyc3 == 0) = inf;             %if no 3-cycles exist, make C=0 (via K=inf)
    CYC3 = K.*(K-1)-2*diag(A^2);	%number of all possible 3-cycles
    cci = cyc3./CYC3;              %clustering coefficient
    avercc = mean(cci);
end

return



function [srand] = Wei_sym_generate_srand(A);
% This function is used to generate a random network with the same N, K
% and degree distribution as a  real network using Maslovs wiring algorithm
% (Maslov et al. 2002). Meanwhile, the correspongding weights are redistributed.
% This function is slightly revised according to Maslov's wiring program
% (http://www.cmth.bnl.gov/~maslov/).
% function [srand] = Wei_sym_generate_srand(A,B)
%      Input
%               A:
%                 weighted matrix whose elements A(i,j) is corresponding weight if
%                 there is an edge between node i and node j, otherwise
%                 A(i,j) = 0.

% Modified by Jinhui Wang 25/03/2008
% =========================================================================

Nei = A;
Nei(find(Nei)) = 1;
srand = Nei;
srand = srand - diag(diag(srand));
nrew = 0;

[i1,j1] = find(srand);
aux = find(i1>j1);
i1 = i1(aux);
j1 = j1(aux);
Ne = length(i1);

ntry = 2*Ne;

for i = 1:ntry
    e1 = 1+floor(Ne*rand);
    e2 = 1+floor(Ne*rand);
    v1 = i1(e1);
    v2 = j1(e1);
    v3 = i1(e2);
    v4 = j1(e2);
    if srand(v1,v2)<1;
%         v1
%         v2
%         srand(v1,v2)
%         pause;
    end;
    if srand(v3,v4)<1;
%         v3
%         v4
%         srand(v3,v4)
%         pause;
    end;

    if (v1~=v3)&(v1~=v4)&(v2~=v4)&(v2~=v3);
        if rand > 0.5;
            if (srand(v1,v3)==0)&(srand(v2,v4)==0);

                % the following line prevents appearance of isolated
                % clusters of size 2
                % if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);

                srand(v1,v2) = 0;
                srand(v3,v4) = 0;
                srand(v2,v1) = 0;
                srand(v4,v3) = 0;

                srand(v1,v3) = 1;
                srand(v2,v4) = 1;
                srand(v3,v1) = 1;
                srand(v4,v2) = 1;

                nrew = nrew+1;

                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;

                % the following line prevents appearance of isolated
                % clusters of size 2
                % end;

            end;
        else
            v5 = v3;
            v3 = v4;
            v4 = v5;
            clear v5;

            if (srand(v1,v3)==0)&(srand(v2,v4)==0);

                % the following line prevents appearance of isolated
                % clusters of size 2
                % if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);

                srand(v1,v2) = 0;
                srand(v4,v3) = 0;
                srand(v2,v1) = 0;
                srand(v3,v4) = 0;

                srand(v1,v3) = 1;
                srand(v2,v4) = 1;
                srand(v3,v1) = 1;
                srand(v4,v2) = 1;

                nrew=nrew+1;

                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;

                % the following line prevents appearance of isolated
                % clusters of size 2
                % end;

            end;
        end;
    end;
end;
wei = triu(A);
weivec = wei(find(wei));
randwei = weivec(randperm(length(weivec)));
Mid = triu(srand);
Mid(find(Mid)) = randwei;
srand = Mid+Mid';
return




 
function [wrand] = Wei_sym_generate_srand_WD(W);
% Network randomization method 2:
% This function is used to generate a random network with the same N, K and
% degree distribution as a  real network using Maslovs wiring algorithm
% (Maslov et al. 2002). This function is slightly revised according to
% Maslov's wiring program  (http://www.cmth.bnl.gov/~maslov/).
% Yong HE,
% Modified by wangliang to perform the randomization for weight matrix.
% =========================================================================

wrand = W-diag(diag(W));
Topo = wrand;
Topo(find(Topo)) = 1;
srand = Topo;
srand = srand - diag(diag(srand));
nrew = 0;

[i1,j1] = find(srand);
aux = find(i1>j1);
i1 = i1(aux);
j1 = j1(aux);
Ne = length(i1);

ntry = 2*Ne;% maximum randmised times

for i = 1:ntry
    e1 = 1+floor(Ne*rand);% randomly select two links
    e2 = 1+floor(Ne*rand);
    v1 = i1(e1);
    v2 = j1(e1);
    v3 = i1(e2);
    v4 = j1(e2);
    if srand(v1,v2)<1;
%         v1
%         v2
%         srand(v1,v2)
%         pause;
    end;
    if srand(v3,v4)<1;
%         v3
%         v4
%         srand(v3,v4)
%         pause;
    end;

    if (v1~=v3)&(v1~=v4)&(v2~=v4)&(v2~=v3);
        if rand > 0.5;
            if (srand(v1,v3)==0)&(srand(v2,v4)==0);

                % the following line prevents appearance of isolated clusters of size 2
                %           if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);

                srand(v1,v2) = 0;
                srand(v3,v4) = 0;
                srand(v2,v1) = 0;
                srand(v4,v3) = 0;

                srand(v1,v3) = 1;
                srand(v2,v4) = 1;
                srand(v3,v1) = 1;
                srand(v4,v2) = 1;

                wrand(v1,v3) = wrand(v1,v2);
                wrand(v2,v4) = wrand(v3,v4);
                wrand(v3,v1) = wrand(v2,v1);
                wrand(v4,v2) = wrand(v4,v3);

                wrand(v1,v2) = 0;
                wrand(v3,v4) = 0;
                wrand(v2,v1) = 0;
                wrand(v4,v3) = 0;

                nrew = nrew+1;

                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;

                % the following line prevents appearance of isolated clusters of size 2
                %            end;

            end;
        else
            v5 = v3;
            v3 = v4;
            v4 = v5;
            clear v5;

            if (srand(v1,v3)==0)&(srand(v2,v4)==0);

                % the following line prevents appearance of isolated clusters of size 2
                %           if (k1(v1).*k1(v3)>1)&(k1(v2).*k1(v4)>1);

                srand(v1,v2) = 0;
                srand(v4,v3) = 0;
                srand(v2,v1) = 0;
                srand(v3,v4) = 0;

                srand(v1,v3) = 1;
                srand(v2,v4) = 1;
                srand(v3,v1) = 1;
                srand(v4,v2) = 1;

                wrand(v1,v3) = wrand(v1,v2);
                wrand(v2,v4) = wrand(v3,v4);
                wrand(v3,v1) = wrand(v2,v1);
                wrand(v4,v2) = wrand(v4,v3);

                wrand(v1,v2) = 0;
                wrand(v3,v4) = 0;
                wrand(v2,v1) = 0;
                wrand(v4,v3) = 0;

                nrew=nrew+1;

                i1(e1) = v1;
                j1(e1) = v3;
                i1(e2) = v2;
                j1(e2) = v4;

                % the following line prevents appearance of isolated clusters of size 2
                %           end;

            end;
        end;
    end;
end;
return




function [eff] = Wei_gretna_efficiency (A, B)


% =========================================================================
% This function is used to calculate the global and local efficiency of a
% graph (i.e. network) G (Latora and Marchiori, 2001) that are
% characterized by a binarized connectivity matrix A with nodes N and edges
% K.
%
% function [eff] = mona_efficiency(A)
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
%       eff. regionalglobalE:
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


N = length(A);
D0 = Lwei(A);
D1 = Lwei(B);
for i=1:N
    D0(i,i) = inf;
    D1(i,i) = inf;
end
eff0 = 1./D0;
eff1 = 1./D1;
% global efficiency of a graph
gE = sum(sum(eff0))/(N*(N-1));%加权图的Eglob
wholegE = sum(sum(eff1))/(N*(N-1));%理想加权图的Eglob,即所有的边都存在

% global efficiency of each node;
regionalglobalE = sum(eff0,2)/(N-1);

for i = 1:N
    NV =  find(A(i,:));
    if length(NV)==0 | length(NV)==1
        regionallocalE(i,1) = 0;
    else
        C = A(NV,NV);
        DL = Lwei(C);
        for kk = 1:length(NV)
            DL(kk,kk) = inf;
        end
        localeff0 = 1./DL;
        % local efficiency of each node
        regionallocalE(i,1)  = sum(sum(localeff0))/(length(NV)*(length(NV)-1)) ;
    end
    E = B(NV,NV);
    DW = Lwei(E);
    for kk =1:length(NV)
        DW(kk,kk) = inf;
    end
    localeff1 = 1./DW;
    wholeregionallocalE(i,1)  = sum(sum(localeff1))/(length(NV)*(length(NV)-1)) ;
end

localE = sum(regionallocalE)/N;
wholelocalE = sum(wholeregionallocalE)/N;

eff.gE = gE;
eff.localE = localE;
eff.regionallocalE = regionallocalE;
eff. regionalglobalE = regionalglobalE;
eff.wholegE = wholegE;
eff.wholelocalE = wholelocalE;
eff.wholeregionallocalE = wholeregionallocalE;


return

