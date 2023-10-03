classdef NumPro < handle
    %NUMPRO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=public)
        
        
       
        discretization;
        matrix;
        K;rcmk;
    end
    
    methods (Access=public)
        function obj = NumPro(i)
            fprintf('**************************************************\n');
            fprintf('*                                                *\n');
            fprintf('*                  N u m P r o                   *\n');
            fprintf('*                      ML                        *\n');
            fprintf('*                                                *\n');
            fprintf('**************************************************\n');
            fprintf('*                                                *\n');
            fprintf('*  Copyright (C) 2013                            *\n');
            fprintf('*     Institut fuer Baustatik und Baudynamik     *\n');
            fprintf('*     Universitaet Stuttgart                     *\n');
            fprintf('*     Malte von Scheven                          *\n');
            fprintf('*                                                *\n');
            fprintf('**************************************************\n');
            
            
            % create discretization object
            if nargin == 1
                obj.discretization = Discretization_fast();
            else
                obj.discretization = Discretization();
            end

            obj.matrix = Matrix_dense(obj.discretization.num_dof_total);
            obj.discretization.assemble(obj.matrix);
            obj.K=obj.matrix.values;
            obj.rcmk=symrcm(obj.K);
            obj.discretization.output();
        end
    end
    
end

