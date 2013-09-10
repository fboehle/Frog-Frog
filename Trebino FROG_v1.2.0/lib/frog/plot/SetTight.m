function SetTight(ax);
%called in response to axis tight
%we can assume that ax is length=1

ch = allchild(ax);
%allchild is important because it finds things with handlevisibility "off",
%which is very important in a user object world

limits = [inf -inf inf -inf inf -inf];
hasdepth = 0;

for i=1:length(ch),
    switch get(ch(i),'type')
    case {'patch','surface','line'}
        data{i} = get(ch(i),{'xdata','ydata','zdata'});
    case 'image'
        data{i} = get(ch(i),{'xdata','ydata','cdata'});
        
        % Offset data limits by half a pixel
        siz = size(data{i}{3});
        data{i}{1} = [min(data{i}{1}) max(data{i}{1})];
        data{i}{2} = [min(data{i}{2}) max(data{i}{2})];
        dx = diff(data{i}{1}); dy = diff(data{i}{2});
        if isequal(siz(2),1)
            % single x value, set range +/- half that value
            data{i}{1} = data{i}{1} + [-1 1]/2;
        else
            data{i}{1} = data{i}{1} + [-dx dx]/(siz(2)-1)/2;
        end
        if isequal(siz(1),1)
            % single y value, set range +/- half that value
            data{i}{2} = data{i}{2} + [-1 1]/2;
        else
            data{i}{2} = data{i}{2} + [-dy dy]/(siz(1)-1)/2;
        end
        data{i}{3} = [];
    case 'text'
        % Ignore text like the axes object does.  This
        % handles filtering out the xlabel, ylabel, zlabel, and
        % title objects as well.
        data{i} = cell(1,3);
    otherwise
        data{i} = cell(1,3);
    end
    
    if ~isempty(data{i}{1})
        limits(1:2) = [min(limits(1),min(data{i}{1}(:))) ...
                max(limits(2),max(data{i}{1}(:)))];
    end
    if ~isempty(data{i}{2})
        limits(3:4) = [min(limits(3),min(data{i}{2}(:))) ...
                max(limits(4),max(data{i}{2}(:)))];
    end
    if ~isempty(data{i}{3}),
        limits(5:6) = [min(limits(5),min(data{i}{3}(:))) ...
                max(limits(6),max(data{i}{3}(:)))];
        
        if limits(5)~=limits(6)
            hasdepth = 1;
        end
    end
end

% Protect against axis limit values being the same
ndx = find(diff(limits)==0 & [1 0 1 0 1]);

% handle log scales
logscales = [0 0 0 0 0 0];
logscales(1) = strcmp(get(ax,'xscale'),'log');
logscales(3) = strcmp(get(ax,'yscale'),'log');
if hasdepth
    logscales(5) = strcmp(get(ax,'zscale'),'log');
end

if ~isempty(ndx)
    if any(logscales(ndx))
        for i = 1:length(ndx)
            j = ndx(i);
            if logscales(i)
                % handle semilogx(1,1:10)
                % Scale upper 10 (log)
                % Scale lower limit by .1 (log)
                limits(j+1) = limits(j) * 10;
                limits(j) = limits(j) / 10;
            else
                % handle semilogy(1:10,1)
                % Bump upper and lower limits by 1
                limits(j+1) = limits(j)+1;
                limits(j) = limits(j)-1;
            end
        end
    else
        % Bump upper and lower limits by 1
        % handle semilogx(1:10,1)
        % handle semilogy(1,1:10)
        % handle plot(1,1:10), plot(1,1), plot(1:10,1)
        limits(ndx+1) = limits(ndx)+1;
        limits(ndx) = limits(ndx)-1;
    end
end

if all(isfinite(limits(1:4))),
    set(ax,...
        'xlim',limits(1:2),...
        'ylim',limits(3:4))
end

if hasdepth
    set(ax,'zlim',limits(5:6))
end
