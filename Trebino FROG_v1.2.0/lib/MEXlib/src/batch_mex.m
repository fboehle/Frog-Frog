
all_dir = dir;
nn = length(all_dir);
fprintf(1, 'Batch compile MEX for FROG code. Issue had been found in MagRepl with standard gcc library in Linux/Mac. Window user with $MS$ visual studio installed is fine with MagRepl.\nPlease do NOT compile MagRepl.cpp in Linux/Mac.\n MagRepl.m is attached in the library as a replacement.\n')

OS = input('What is your OS? Please choose from the following. If your OS is not listed, please compile one file and change this file extension inside this batch script accordingly.\n[1] Mac 64 bit\n[2] Linux 64 bit\n[3] Window 64 bit\n[4] Other OS\nPlease enter 1-4 ..');
if OS > 4 || OS <1
   fprintf(1,'Invaild input, exiting program\n');
   break;
end

if OS == 4
    fprintf(1,'For other OS, please compile one single cpp file, \ncheck the extension and modify this file accordingly.\nExiting program\n');
	break;
end
    
    
for ii = 1:nn
    temp = all_dir(ii);
    if temp.isdir
        if strcmp(temp.name,'Doxygen') || strcmp(temp.name,'.') || ...
                strcmp(temp.name,'..') || strcmp(temp.name,'CVS') || ...
                strcmp(temp.name,'MagRepl') || strcmp(temp.name,'Util')
            'SKIP';
        else
            chdir(temp.name);
            cmd = sprintf('mex %s.cpp', temp.name);
            fprintf(1, 'Compiling %s.cpp', temp.name);
            evalin('base', cmd)
            
            switch OS
                % Different OS get different mex extension
                
                case 1
                    % Mac 64 bit
                    cmd = sprintf('copyfile %s.mexmaci64 ../%s.mexmaci64', temp.name, temp.name);
                    
                case 2
                    % Linux 64 bit
                    cmd = sprintf('copyfile %s.mexa64 ../%s.mexa64', temp.name, temp.name);
                    
                case 3
                    % Window 64 bit
                    cmd = sprintf('copyfile %s.mexw64 ../%s.mexw64', temp.name, temp.name);
                    
            end
            
            evalin('base', cmd)
            chdir('..');
        end
    end
end

% Issues have been observed in Linux // Mac system with the gcc standard library incompatible
% to the code in MagRepl. A replacement file MagRepl.m is attached in the package to Linux and
% Mac users. There is no issue for Window user with MS Visual Studio express installed as the
% compiler.
if OS == 3
    chdir('MagRepl');
    evalin('base','mex MagRepl.cpp');
    evalin('base','copy MagRepl.mexw64 ../MagRepl.mexw64');
end