# Lattice studies of the Sp(4) gauge theory with two fundamental and three antisymmetric Dirac fermions&mdash;code release

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6472232.svg)](https://doi.org/10.5281/zenodo.6472232)

This repository contains the analysis code used to prepare the plots and tables
included in [Lattice studies of the Sp(4) gauge theory with two fundamental and three antisymmetric Dirac fermions][multirep-paper].

In particular, likely due to the Mathematica implementation of the fitting
functions, answers do not reproduce bit-wise; there are fluctuations
within error bars visible in final results.

## Health warning

This analysis was originally performed manually using Mathematica, and was
automated after the fact. The code included in this repository is therefore
largely unsuited to generalisation to other datasets than the one it was
originally designed for.

## Requirements

The analysis is written in a mix of WolframScript and Python. The various
components are joined together using Make. The code has been tested with

* Mathematica 13.0
* Python 3.9 (with requirements as documented in `environment.yml`)
* GNU Make 4.3
* (Optionally) Conda to manage dependencies

In particular, versions of Make before 4.3 will not work. This includes the
version of Make installed on macOS by default.

## Setup

### Installation

* Download the repository
* Run

      conda env create -f environment.yml

  to create a new Conda environment including the requisite packages.
  (Alternatively, create a Python environment with the listed packages, and
  ensure that you have GNU Make 4.3 or later.)
* Adjust the `Makefile` to point to the correct location of your copy of
  `wolframscript`.

### Data

* Download and extract the data. Specifically, you need the two directories
  `data`, and `fit_params`. By default it is expected that these are placed
  in the root directory of the repository, but this can be changed in the
  `Makefile`.

### Running the analysis

* With the software and data downloaded, you should be able to reproduce the
  full analysis by typing

      make

  Plots will be created in the `plots` directory, and tables in the `tables`
  directory. Intermediary files not included in the publication are held in
  the `processed_data` directory. Each of these will be created by `make`
  automatically.
* The analysis will run in parallel by using `make -j N`, where `N` is replaced
  by the number of parallel jobs to use. This will only work as long as `N`
  does not exceed the number of Mathematica kernels you are licensed to launch
  on your machine (minus any you have running).
* On a single Apple M1 CPU core, the full analysis takes around an hour.


[multirep-paper]: https://arxiv.org/abs/2202.05516
