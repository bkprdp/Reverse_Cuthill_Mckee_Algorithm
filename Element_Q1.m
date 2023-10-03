classdef Element_Q1 < Element
    %ELEMENT_Q1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Element_Q1(p_id, p_n1, p_n2, p_n3, p_n4, p_mat, pdis)
            if nargin == 0
                return;
            end
            obj.id       = p_id;
            obj.nodes(1) = pdis.nodes(p_n1);
            obj.nodes(2) = pdis.nodes(p_n2);
            obj.nodes(3) = pdis.nodes(p_n3);
            obj.nodes(4) = pdis.nodes(p_n4);
            obj.material = p_mat;
        end
        
        
        
        
        function output(obj)
            xm = 0;
            ym = 0;
            x = zeros(1,5);
            y = zeros(1,5);
            for i=1:4
                x(i) = obj.nodes(i).coord(1);
                y(i) = obj.nodes(i).coord(2);
                xm = xm + obj.nodes(i).coord(1);
                ym = ym + obj.nodes(i).coord(2);
            end
            x(5) = obj.nodes(1).coord(1);
            y(5) = obj.nodes(1).coord(2);
            line(x,y)
            text(xm/4,ym/4,num2str(obj.id));
        end
        
        
        function k = stiffness_matrix(obj)
            fprintf('calculate stiffness of Q1\n');
            
            k         = zeros(8,8);
            
            C         = zeros(3,3);
            deriv     = zeros(4,2);
            jaco      = zeros(2,2);
            jaco_inv  = zeros(2,2);
            bop       = zeros(3,8);
            
            detJ = 0;
            fac  = 0;
                        
            % one integration point
            gp  = [ 0 ];
            gpw = [ 2 ];
            
            % four integration points
            %gp  = [-1/sqrt(3) 1/sqrt(3)];
            %gpw = [1 1];

            for m=1:size(gp,2)
                for n=1:size(gp,2)
                    xi  = gp(m);
                    eta = gp(n);
                    fac_gp = gpw(m)*gpw(n);
                    
                    
                    deriv(1,1) = -0.25*(1-eta);
                    deriv(2,1) =  0.25*(1-eta);
                    deriv(3,1) =  0.25*(1+eta);
                    deriv(4,1) = -0.25*(1+eta);
                    deriv(1,2) = -0.25*(1-xi);
                    deriv(2,2) = -0.25*(1+xi);
                    deriv(3,2) =  0.25*(1+xi);
                    deriv(4,2) =  0.25*(1+xi);
                    
                    for i=1:size(obj.nodes,2)
                        jaco(1,1) = jaco(1,1) + deriv(i,1) * obj.nodes(i).coord(1);
                        jaco(1,2) = jaco(1,2) + deriv(i,1) * obj.nodes(i).coord(2);
                        jaco(2,1) = jaco(2,1) + deriv(i,2) * obj.nodes(i).coord(1);
                        jaco(2,2) = jaco(2,2) + deriv(i,2) * obj.nodes(i).coord(2);
                    end
                    
                    detJ = det(jaco);
                    fac = fac_gp * detJ;
                    
                    jaco_inv = inv(jaco);
                    
                    for i=1:size(obj.nodes,2)
                        col = 2*i-1;
                        bop(1,col)   = jaco_inv(1,1) * deriv(i,1) + jaco_inv(1,2) * deriv(i,2);
                        bop(2,col+1) = jaco_inv(2,1) * deriv(i,1) + jaco_inv(2,2) * deriv(i,2);
                        bop(3,col)   = bop(2,col+1);
                        bop(3,col+1) = bop(1,col);
                    end
                    
                    C = obj.material.get_C();
                    
                    k = k + fac*bop.'*C*bop;
                    
                end
            end
            
            
           k
            
        end
        
        
        
    end
    
end

