classdef Matrix_Dense < Matrix
    %MATRIX_DENSE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        values;
    end
    
    methods
        function obj = Matrix_Dense(p_neq)
            obj.num_eq = p_neq;
            obj.values = zeros(p_neq,p_neq);
        end
                
        
        
        
        function add_entry(obj, row, col, val)
            obj.values(row,col) = obj.values(row,col) + val;
        end
        
        
        
        
        function init(obj)
            %for i=1:obj.num_eq
            %    for j=1:obj.num_eq
            %        obj.values(i,j) = 0;
            %    end
            %end
            obj.values = zeros(obj.num_eq,obj.num_eq);
        end
        
        
        
        
        function output(obj)
            obj.values
        end
        
    end
    
end

