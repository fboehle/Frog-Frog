function val = get(FrogObj, name)
%GET returns the specified value from the FrogBase object.
%	FrogObj		the FrogBase object.
%	name		the name of the parameter to return.

%	$Id: get.m,v 1.1 2006-11-11 00:13:32 pablo Exp $

switch name
    % See FrogBase constructor for descriptions.
    case 'Asig'
        val = FrogObj.Asig;
    case 'Esig'
        val = FrogObj.Esig;
    case 'tau'
        val = FrogObj.tau;
    case 'w2'
        val = FrogObj.w2;
    case 'Et'
        val = FrogObj.Et;
    case 'EtOrig'
        val = FrogObj.EtOrig;
    case 't'
        val = FrogObj.t;
    case 'G'
        val = FrogObj.G;
    case 'Z'
        val = FrogObj.Z;
    case 'BestG'
        val = FrogObj.BestG;
    case 'BestG.Et'
        val = FrogObj.BestG.Et;
    case 'BestG.G'
        val = FrogObj.BestG.G;
    case 'BestG.Z'
        val = FrogObj.BestG.Z;
    case 'Best.Iter'
        val = FrogObj.BestG.Iter;
    case 'BestZ'
        val = FrogObj.BestZ;
    case 'BestZ.Et'
        val = FrogObj.BestZ.Et;
    case 'BestZ.G'
        val = FrogObj.BestZ.G;
    case 'BestZ.Z'
        val = FrogObj.BestZ.Z;
    case 'BestZ.Iter'
        val = FrogObj.BestZ.Iter;
    case 'TypeName'
        val = FrogObj.TypeName;
    case 'NonLinName'
        val = FrogObj.NonLinName;
    case 'DomainName'
        val = FrogObj.DomainName;
    case 'AlgoName'
        val = FrogObj.AlgoName;
        % We just want the base object.
    case 'BaseObj'
        val = FrogObj;
        
    otherwise
        error('FrogAlgo:get:InvalidName','Invalid property, %s.', name);
end
