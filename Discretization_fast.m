classdef Discretization_fast < handle
    %DISCRETIZATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodes     = Node();
        elements  = Element_Q1();
        materials = Material();
        
        num_dof_total;
        num_dof_solve;
        num_dof_dirich;
    end
    
    methods
        function obj = Discretization_fast()
            
            % input material
            E         = 1000;
            nu        = 0.0;
            obj.materials(1) = Material(E, nu);
            
            
            % input geometry
            l_x       = 2;
            div_x     =  1;
            l_y       =  2;
            div_y     =  1;
            
            
            % input Nodes
            el_x = l_x/div_x;
            el_y = l_y/div_y;
            
            for i=0:div_y
                for j=0:div_x
                    obj.nodes(i*(div_x+1)+j+1) = Node(i*(div_x+1)+j+1,el_x*j,i*el_y);
                end
            end
            fprintf('\nNodes:         %6i\n',(div_x+1)*(div_y+1));
            
            
            % input elements
            for i=0:div_y-1
                for j=0:div_x-1
                    obj.elements(i*div_x+j+1) = Element_Q1(i*div_x+j+1,...
                        (div_x+1)*i+j+1,...
                        (div_x+1)*i+j+2,...
                        (div_x+1)*(i+1)+j+2,...
                        (div_x+1)*(i+1)+j+1,...
                        obj.materials(1),obj);
                end
            end
            fprintf('Elements:      %6i\n',(div_x)*(div_y));
            
            
            % Load BC: tip load
            id = (div_x+1)*(div_y+1);
            value = 17;
            obj.nodes(id).bc_load(2) = value;
            
            
            % Displacement BC: left edge clamped
            for i=0:div_y
                id = i*(div_x+1)+1;
                obj.nodes(id).bc_disp(1) = 1;
                obj.nodes(id).bc_disp(2) = 1;
            end
            
            
            % assign dof numbers and fill id-matrices
            obj.assign_dofs();
            
        end
        
        
        
         
        function assign_dofs(obj)
            
            obj.num_dof_total  = 0;
            obj.num_dof_solve  = 0;
            obj.num_dof_dirich = 0;
            
            % assign free dofs
            for i=1:size(obj.nodes,2)
                if obj.nodes(i).bc_disp(1) ~= 1
                    obj.nodes(i).dof(1) = obj.num_dof_total+1;
                    obj.num_dof_total = obj.num_dof_total+1;
                    obj.num_dof_solve = obj.num_dof_solve+1;
                end
                if obj.nodes(i).bc_disp(2) ~= 1
                    obj.nodes(i).dof(2) = obj.num_dof_total+1;
                    obj.num_dof_total = obj.num_dof_total+1;
                    obj.num_dof_solve = obj.num_dof_solve+1;
                end
            end
            
            
            % assign constraint dofs
            for i=1:size(obj.nodes,2)
                if obj.nodes(i).bc_disp(1) == 1
                    obj.nodes(i).dof(1) = obj.num_dof_total+1;
                    obj.num_dof_total  = obj.num_dof_total+1;
                    obj.num_dof_dirich = obj.num_dof_dirich+1;
                end
                if obj.nodes(i).bc_disp(2) == 1
                    obj.nodes(i).dof(2) = obj.num_dof_total+1;
                    obj.num_dof_total  = obj.num_dof_total+1;
                    obj.num_dof_dirich = obj.num_dof_dirich+1;
                end
            end
            
            
            % build ID matrix
            for i=1:size(obj.elements,2)
                obj.elements(i).id_mat = zeros(1,8);
                counter = 1;
                for j=1:size(obj.elements(i).nodes,2)
                    obj.elements(i).id_mat(counter) = obj.elements(i).nodes(j).dof(1);
                    counter = counter+1;
                    obj.elements(i).id_mat(counter) = obj.elements(i).nodes(j).dof(2);
                    counter = counter+1;
                end
            end
            
        end
               

        
        
        function assemble(obj, stiffness)
            
            stiffness.init();
            
            for i=1:size(obj.elements,2)
                % get element stiffness matrix
                kele = obj.elements(i).stiffness_matrix();
                
                % assemble to global matrix
                for k=1:8                                            % rows
                    if obj.elements(i).id_mat(k) > obj.num_dof_solve
                        continue; end
                    for l=1:8                                          % columns
                        if obj.elements(i).id_mat(l) > obj.num_dof_solve
                            continue; end
                        stiffness.add_entry(obj.elements(i).id_mat(k),...
                        obj.elements(i).id_mat(l), kele(k,l) );
                    end
                end
                
            end
        end
        
        
        
        
        function output(obj)
            daspect([1,1,1]);
            axis equal;
            for i=1:size(obj.nodes,2)
                obj.nodes(i).output();
            end
            for i=1:size(obj.elements,2)
                obj.elements(i).output();
            end
        end
        
    end
    
end

