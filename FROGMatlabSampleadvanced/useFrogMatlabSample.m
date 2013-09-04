Frog = double(imread('generated.tif'));
Frog = Frog / max(max(Frog));
[Pt, Fr, G, iter] = svdFROG(Frog,[], [], 800,[], 1, [], [])
