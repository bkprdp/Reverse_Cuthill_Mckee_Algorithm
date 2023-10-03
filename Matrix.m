classdef Matrix < handle
    %MATRIX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        num_eq;
    end
    
    methods (Abstract)
        add_entry(obj, row, col, val);
        init(obj);
        output(obj);
    end
    
end

