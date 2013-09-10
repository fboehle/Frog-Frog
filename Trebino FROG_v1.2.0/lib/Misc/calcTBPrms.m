function TBPrms = calcTBPrms(Et,t,Ew,w)
[m,n] = size(Et);
[p,q] = size(t);
if m ~= p 
    t = t';
end
[m,n] = size(Ew);
[p,q] = size(w);
if m ~= p 
    w = w';
end


dt = mean(diff(t));
dw = mean(diff(w));
normIt  = abs(Et).^2/trapz(abs(Et).^2)/dt;
normIw  = abs(Ew).^2/trapz(abs(Ew).^2)/dw;

mean_t  = trapz(t.*normIt)*dt;
mean_t2 = trapz(t.^2 .* normIt)*dt;
tVar    = mean_t2 - mean_t^2;
mean_w  = trapz(w.*normIw)*dw;
mean_w2 = trapz(w.^2.*normIw)*dw;
wVar    = mean_w2 - mean_w^2;
%     mean_w  = trapz(t,gradient(unwrap(angle(Et)),dt).*normIt);
%     mean_w2 = trapz(t,gradient(sqrt(normIt),dt).^2 + ...
%                 gradient(unwrap(angle(Et)),dt).^2.*normIt);
%     wVar2   = mean_w2 - mean_w^2;
TBPrms = sqrt(tVar)*sqrt(wVar);