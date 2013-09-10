function Asig = FROG_TraceResize(Asig, N)

n1 = size(Asig,1)
n2 = size(Asig,2)

sz = n2/n1

n = min(size(Asig))

if n < N
	error(sprintf('New size, %d, must be smaller than the old size, %d!',N,n))
end

dn = n/N

n0 = (n2-N*sz)/2

Asig = Asig(n0:end-n0-1,1:dn:end);