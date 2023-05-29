# adapted from github.com/JuliaLang/Microbenchmarks/blob/master/bin/benchmarks.ipynb
using DataFrames
using CairoMakie
using StatsBase
using CSV

# load benchmark data from file
benchmarks = CSV.read(first(ARGS), DataFrame; header=["language", "benchmark", "time"])

# capitalize and decorate language names from datafile
dict = Dict(
  "c"=>"C",
  "julia"=>"Julia",
  "lua"=>"LuaJIT",
  "fortran"=>"Fortran",
  "java"=>"Java",
  "javascript"=>"JavaScript",
  "matlab"=>"Matlab",
  "mathematica"=>"Mathematica",
  "python"=>"Python",
  "octave"=>"Octave",
  "r"=>"R",
  "rust"=>"Rust",
  "go"=>"Go"
)
benchmarks[!, :language] = map(lang -> dict[lang], benchmarks[!, :language])

# normalize benchmark times by C times
ctime = benchmarks[benchmarks[!, :language] .== "C", :]
benchmarks = innerjoin(benchmarks, ctime, on=:benchmark, makeunique=true)

select!(benchmarks, Not(:language_1))
rename!(benchmarks, :time_1=>:ctime)
benchmarks[!, :normtime] = benchmarks[!, :time] ./ benchmarks[!, :ctime]

# compute the geometric mean for each language
langs = []
means = []
priorities = []
for lang ∈ values(dict)
  data = benchmarks[benchmarks[!, :language] .== lang, :]
  isempty(data) && continue
  gmean = geomean(data[!, :normtime])
  push!(langs, lang)
  push!(means, gmean)
  if lang == "C"
    push!(priorities, 1)
  elseif lang == "Julia"
    push!(priorities, 2)
  else
    push!(priorities, 3)
  end
end

# add the geometric means back into the benchmarks dataframe
langmean = DataFrame(language=langs, geomean=means, priority=priorities)
benchmarks = innerjoin(benchmarks, langmean, on=:language)

# put C first, Julia second, and sort the rest by geometric mean
sort!(benchmarks, [:priority, :geomean])
sort!(langmean, [:priority, :geomean])

display(langmean[:,1:2])

fig = Figure()
ax = Axis(fig[1, 1]; yscale=log10, xticks=(1:length(langs), langs))
pos = Dict(l => i for (i, l) ∈ enumerate(langs))

colors = Iterators.Stateful(Iterators.cycle(Makie.wong_colors()))
bench_cols = Dict{String, Any}()
plots = []
labels = []
for row ∈ eachrow(benchmarks)
  color = get!(() -> popfirst!(colors), bench_cols, row.benchmark)
  p = scatter!(ax, pos[row.language], row.normtime; color, label=row.benchmark)
  if row.benchmark ∉ labels
    push!(labels, row.benchmark)
    push!(plots, p)
  end
end
Legend(fig[1, 2],  plots, labels, "benchmark"; labelsize=10)
save(joinpath("figures", "benchmarks.png"), fig; px_per_unit=2)
