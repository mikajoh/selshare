[![Travis-CI Build Status](https://travis-ci.org/mikajoh/selshare.svg?branch=master)](https://travis-ci.org/mikajoh/selshare)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/mikajoh/selshare?branch=master&svg=true)](https://ci.appveyor.com/project/mikajoh/selshare)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/mikajoh/selshare/master/LICENSE)


Research Compendium for "**Conjoint Experiments on Selective Reading and Sharing on Social Media**" by [Erik Knudsen](erik.knudsen@uib.no) and [Mikael Poul Johannesson]((emailto:mikael.johannesson@uib.no)). 

**This is work in progress.** Comments, questions, and suggestions are very welcomed! Please contact me at [mikael.johannesson@uib](emailto:mikael.johannesson@uib.no). 

This compendium is structured as an R package (see [here](https://github.com/ropensci/rrrpkg) if you are unfamiliar with this concept). The R package itself includes custom functions used in the data preparation and analysis. The code and data needed to reproduce the results are in the `analysis/` folder. The experiments were in run the [**Norwegian Citizen Panel**](http://www.nsd.uib.no/nsddata/serier/norsk_medborgerpanel_eng.html).


## Getting the Code and Data


You can install this research compendium by running the following in R (note that you need the `devtools` package installed):

```r
library(devtools)
install_github("mikajoh/selshare")
```

You can also clone this compendium using git or download it as a .zip archive. If you have git and you are on a \*nix system then running the following code in a shell should automate the procedure.

```bash
git clone https://github.com/mikajoh/selshare.git && cd selshare
```

The prepared data needed for the final analysis is available in the compendium (`analysis/data/`). The raw data is not openly available in the compendium due to data protection regulations. However, it is freely available for researchers [here](http://www.nsd.uib.no/nsddata/serier/norsk_medborgerpanel_eng.html) (at the Norwegian Data Science Archive). Alternatively, just send me an email at [mikael.johannesson@uib](emailto:mikael.johannesson@uib.no). 

## Running the Code

As mentioned the code to reproduce the results is in the `analysis/` folder. The files needs to be run in order. It is currently structured as follows.


```r
analysis/
├── 01_data_rsp.R       # Prepares rsp data from previous NCP waves (`ncp_rsp_w17.csv`)
├── 02_data_w8.R        # Prepares the experiment in wave 8 of the NCP (`ncp_exp_w8.csv`)
├── 03_data_w9.R        # Prepares the experiment in wave 9 of the NCP (`ncp_exp_w9.csv`)
├── data/               # The data output from .R file 01_-03_ needed to run the analyses.
│   ├── ncp_exp_w8.csv
│   ├── ncp_exp_w9.csv
│   └── ncp_rsp_w17.csv
├── output/
└── raw/                         # Raw data (current the raw NCP data is not included)
    ├── documentation/*.pdf      # Documention and codebooks for the various NCP waves.
    ├── ncp_exp_w9_headlines.csv
    ├── ncp_rsp_w17_vars.csv
    ├── Norwegian citizen panel - wave 1-7 EN.sav # [NOT INCLUDED]
    ├── Norwegian Citizen Panel - wave 8 EN.sav   # [NOT INCLUDED]
    └── Norwegian Citizen Panel - wave 9 EN.sav   # [NOT INCLUDED]

```
