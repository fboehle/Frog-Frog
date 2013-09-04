clear all

[X,Y] = meshgrid(-2:.2:2, -2:.2:2);                                
Z = X .* exp(-X.^2 - Y.^2);                                        
surf(X,Y,X,Y,X)
