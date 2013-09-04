Frog = imread('generated.tif');

[Pt, Gt, Fr, eps, iter] = svdFROG(Frog,[],[],[],[],1)

