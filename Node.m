classdef Node < handle
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id;
        coord = zeros(1,2);
        
        dof   = zeros(1,2);
        sol   = zeros(1,2);
        
        bc_load   = zeros(1,2); % value of the loads
        bc_disp   = zeros(1,2); % flag: 1:supported; 0:free
    end
    
    methods
        function obj = Node(p_id, p_x, p_y)
            if nargin == 0
                return;
            end;
            obj.id = p_id;
            obj.coord(1) = p_x;
            obj.coord(2) = p_y;
        end
        
        
        function output(obj)
            color = 'b';
            if obj.bc_load(1) ~= 0 || obj.bc_load(2) ~= 0
                color = 'r';
            end
            if obj.bc_disp(1) ~= 0 || obj.bc_disp(2) ~= 0
                color = 'g';
            end
            rectangle('Position',[obj.coord(1)-0.025,obj.coord(2)-0.025,0.05,0.05],'Curvature',[1,1],'FaceColor',color);
        end

    end
    
end

