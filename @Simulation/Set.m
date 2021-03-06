function [ Sim ] = Set( Sim, varargin )
% Sets desired object properties

nParams = (nargin-1)/2;
if rem(nParams,1)~=0 || nargin<1
    error('Set failed: not enough inputs')
else
    for p = 1:nParams
        key = varargin{2*p-1};
        value = varargin{2*p};
        if ~isnumeric(value)
            error('Set failed: property value must be numeric');
        end
        
        switch key

            case 'tend'
                Sim.tend = value;
            case 'tstep'
                Sim.tstep = value;   
             case 'Graphics'
                Sim.Graphics = value;
            case 'WindowLeftLocation'
                Sim.WindowLeftLocation = value;                  
                            
            otherwise
                error(['Set failed: ',key,' property not found']);
        end
    end
end
