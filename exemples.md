algebre lineaire
================
-broadcast : [1:3].+[1:3]' fonctionne en julia, pas en matlab

parallelism
===========
@time (s=0.; for i=1:1000000; s += exp(sin(i)); end)
@time (s=0.; s = @parallel (+)for i=1:1000000; exp(sin(i)); end)

M = [ rand(1000,1000) for i=1:5];
@time sum(pmap(x->max(svd(x)[2]),M));



appel de functions externes
===========================
a=linspace(1,10,10)
somme(x) = ccall((:f,"zut"), Float64, (Ptr{Float64}, Int), x, size(x,1))
