classdef  Element < handle
    %ELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        nodes     = Node();
        material  = Material();
        
        id_mat;
    end
    
    methods (Abstract)
        k = stiffness_matrix(obj);
        output(obj);
    end
    
end
