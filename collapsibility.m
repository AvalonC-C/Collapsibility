function c = collapsibility(nQ, nLayers, e)
%%
% This code calculates the per node variability in nodal modularity in a 
% multiplex network.
%
% Version: 1.0, 05/10/2025 
%
% Avalon Campbell-Cousins - avalon.campbell-cousins@ed.ac.uk
% Javier Escudero - jescuder@ed.ac.uk
%
% c = collapsibility(nQ, nLayers, e);
%
% Input: 
%
% nQ - a 1x(nxL)vector of multiplex nodal modularity values where n is the 
% number of nodes in the network and L (nLayers) is the number of layers. 
% nQ is calculated with separated code available here: 
% https://github.com/AvalonC-C/Nodal_Modularity 
%
% nLayers - the number of layers in the multiplex network. 
%
% e - the collapsibility threshold. This is any value in the range [0,1] 
% and can be interpreted as the percentage of variability which we accept. 
% i.e., e=0.2 means that two layers are collapsible if the difference in 
% nQ in the two layers is less than 20%. The default value of e is 0.2.  
%
% Output:
%
% c - the collapsibility of each node in the network (nx1 vector).
%
% To do:
%
% Cite the thesis when available.
%

%%
    if nargin < 3, e = 0.2; end
    
    nNodes = numel(nQ)/nLayers; 
    
    % Check if input is multiplex
    if(rem(nNodes,1) ~=0) 
        error('The input must be a multiplex networks such that nQ is divisible by nLayers');
    end
    
    c = zeros(nNodes, 1);

    for node = 1:nNodes
        count = 0;

        % get avg nQ for a node
        temp = zeros(nLayers,1);
        node_idx = node;
        for x = 1:nLayers
            temp(x) = nQ(node_idx);
            node_idx = node+(x*nNodes);
        end

        avg_nQ = mean(temp);

        % calculate collapsibility
        for layer1 = 0:nLayers-1
            for layer2 = (layer1 + 1):nLayers-1
                if abs(nQ(node+(layer1*nNodes)) - nQ(node+(layer2*nNodes))) < e*avg_nQ
                    count = count + 1;
                end
            end
        end
        c(node) = count / ((nLayers)*(nLayers-1)/2);
    end

end

