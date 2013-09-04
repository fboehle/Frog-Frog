function  myfigure(objectname)

    object = findobj('Name', objectname);
    if(object)
        set(0,'CurrentFigure',object);
    else
        figure('Name', objectname,'NumberTitle','off');
    end
end
