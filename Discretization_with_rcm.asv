classdef Discretization_with_rcm < handle
    %DISCRETIZATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodes     = Node();
        elements  = Element_Q1();
        materials = Material();
        kele;
        
        num_dof_total;
        num_dof_solve;
        num_dof_dirich;
    end
    
    methods
        function obj = Discretization_with_rcm()
            
            % input material
            prompt    = {'Youngs Modulus:','Poissons ratio:'};
            dlg_title = 'Material';
            num_lines = 1;
            def       = {'1000', '0.3'};
            answer    = inputdlg(prompt,dlg_title,num_lines,def);
            E         = str2double( answer{1} );
            nu        = str2double( answer{2} );
            obj.materials(1) = Material(E, nu);
            
            
            % input geometry
            prompt    = {'length x:','No. of Elements x:','length y:','No. of Elements y:'};
            dlg_title = 'Geometry';
            num_lines = 1;
            def       = {'4', '2','2','1'};
            answer    = inputdlg(prompt,dlg_title,num_lines,def);
            l_x       = str2double( answer{1} );
            div_x     = str2double( answer{2} );
            l_y       = str2double( answer{3} );
            div_y     = str2double( answer{4} );
            
           
            % input Nodes
            el_x = l_x/div_x;
            el_y = l_y/div_y;
            
            %for i=0:div_y
             %   for j=0:div_x
                    obj.nodes(6) = Node(6,0,0);
                    obj.nodes(3) = Node(3,el_x,0);
                    obj.nodes(5) = Node(5,el_x*2,0);
                    obj.nodes(2) = Node(2,0,el_y);
                    obj.nodes(4) = Node(4,el_x,el_y);
                    obj.nodes(1) = Node(1,el_x*2,el_y);
                %end
            %end
            fprintf('\nNodes:         %6i\n',(div_x+1)*(div_y+1));
            
            
            % input elements
            %for i=0:div_y-1
             %   for j=0:div_x-1
                    obj.elements(1) = Element_Q1(1,6,3,4,2,obj.materials(1),obj);
                    obj.elements(2) = Element_Q1(2,3,5,1,4,obj.materials(1),obj);

              %  end
            %end
            fprintf('Elements:      %6i\n',(div_x)*(div_y));
            
            
            % input point loads
            load = menu('Select a loading:','tip load','tip moment','load in center');
            
            prompt    = {'Value of load:'};
            dlg_title = 'Loading';
            num_lines = 1;
            def       = {'-10'};
            answer    = inputdlg(prompt,dlg_title,num_lines,def);
            val       = str2double( answer{1} );
            
            switch load
                case 1
                    % tip load
                    id = 1;
                    obj.nodes(id).bc_load(2) = val;
                case 2
                    % tip moment
                    val =  val/l_y;
                    id1 = 1;
                    id2 = 5;
                    obj.nodes(id1).bc_load(1) = val;
                    obj.nodes(id2).bc_load(1) = -val;
                case 3
                    % load in middle
                    id = 4;
                    obj.nodes(id).bc_load(2) = val;
            end
            
            
            % input displacement bc
            support = menu('Select a support:','simply supported','clamped');
            
            switch support
                case 1
                    % simply supported
                    id1 = 6;
                    id2 = 5;
                    obj.nodes(id1).bc_disp(1) = 1;
                    obj.nodes(id1).bc_disp(2) = 1;
                    obj.nodes(id2).bc_disp(2) = 1;
                    
                case 2
                    % clamped
                    for i=0:div_y
                        id = [6,2];
                        obj.nodes(id(i+1)).bc_disp(1) = 1;
                        obj.nodes(id(i+1)).bc_disp(2) = 1;
                    end
            end
            assign_dofs(obj);
        end
        
        
        
        
        function assign_dofs(obj)
            
             obj.num_dof_total  = 0;
             obj.num_dof_solve  = 0;
             obj.num_dof_dirich = 0;
%             
%             % assign free dofs
            for i=1:size(obj.nodes,2)
                if obj.nodes(i).bc_disp(1) ~= 1 || obj.nodes(i).bc_disp(1) == 1
                    obj.nodes(i).dof(1) = obj.num_dof_total+1;
                    obj.num_dof_total = obj.num_dof_total+1;
                    obj.num_dof_solve = obj.num_dof_solve+1;
                end
                if obj.nodes(i).bc_disp(2) ~= 1 || obj.nodes(i).bc_disp(2) == 1
                    obj.nodes(i).dof(2) = obj.num_dof_total+1;
                    obj.num_dof_total = obj.num_dof_total+1;
                    obj.num_dof_solve = obj.num_dof_solve+1;
                end
            end
%             
%             
%             
%             % assign constraint dofs
%             for i=1:size(obj.nodes,2)
%                 if obj.nodes(i).bc_disp(1) == 1
%                     obj.nodes(i).dof(1) = obj.num_dof_total+1;
%                     obj.num_dof_total  = obj.num_dof_total+1;
%                     obj.num_dof_dirich = obj.num_dof_dirich+1;
%                 end
%                 if obj.nodes(i).bc_disp(2) == 1
%                     obj.nodes(i).dof(2) = obj.num_dof_total+1;
%                     obj.num_dof_total  = obj.num_dof_total+1;
%                     obj.num_dof_dirich = obj.num_dof_dirich+1;
%                 end
%             end
            
            
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
        
        
        
        
        
            
         function assemble(obj,stiffness)      
            stiffness.init();
            for i=1:size(obj.elements,2)
                
                % get element stiffness matrix
                obj.kele(:,:,i) = obj.elements(i).stiffness_matrix();
                
                % assemble to global matrix
                for k=1:8                                            % rows
                   % if obj.elements(i).id_mat(k) > obj.num_dof_solve
                       % continue; end
                    for l=1:8                                          % columns
                      %  if obj.elements(i).id_mat(l) > obj.num_dof_solve
                           % continue; end
                        stiffness.add_entry(obj.elements(i).id_mat(k),...
                        obj.elements(i).id_mat(l), obj.kele(k,l,i) );
                        
                        stiffness.output
                    end
                end
              %stiffenss.output
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

