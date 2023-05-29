#!/usr/bin/env bash
set -e
{
  mkdir -p tmp

  if [ -z ${MICROBENCHMARKS+x} ]; then
    if [ ! -e tmp/Microbenchmarks ]; then
      git clone https://github.com/JuliaLang/Microbenchmarks tmp/Microbenchmarks
    fi
    dn=tmp/Microbenchmarks
  else
    dn=$MICROBENCHMARKS
  fi

  # run the benchmarks
  (
    cd $dn

    ldflags=($LDFLAGS)
    rustflags=($(echo ${ldflags[@]/#/-C link-arg=}))
    export RUSTFLAGS="${rustflags[@]}"
    export CFLAGS="$LDFLAGS"
    export FFLAGS="$LDFLAGS"

    if ${CLEAN-false}; then
      make clean
    fi
    # NOTE: fortran seems unrealistic
    bench=($(echo benchmarks/{c,julia,octave,python,rust}.csv))
    make ${bench[@]} -j
    julia bin/collect.jl ${bench[@]} >benchmarks.csv
  )

  # plot results
  julia benchmarks.jl $dn/benchmarks.csv
  exit
}