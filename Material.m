classdef Material < handle
    %MATERIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        youngs;
        poisson;
    end
    
    methods
        function obj = Material(p_E,p_n)
            if nargin == 0
                return;
            end
            obj.youngs = p_E;
            obj.poisson = p_n;
        end
        

        function c = get_C(obj)
            vor = obj.youngs/( (1+obj.poisson)*(1-2*obj.poisson) );
            
            a1 = vor * (1-obj.poisson);
            b1 = vor * obj.poisson;
            c1 = vor * (1-2.0*obj.poisson)/2.0;
            
            c(1,1)=a1;
            c(1,2)=b1;
            c(1,3)=0.0;
            
            c(2,1)=b1;
            c(2,2)=a1;
            c(2,3)=0.0;
            
            c(3,1)=0.0;
            c(3,1)=0.0;
            c(3,3)=c1;
        end
    end
    
end

