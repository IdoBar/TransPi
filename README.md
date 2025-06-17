# TransPi - TRanscriptome ANalysiS PIpeline

```text
 _______                                 _____   _
|__   __|                               |  __ \ (_)
   | |     _ __    __ _   _ __    ___   | |__) | _
   | |    |  __|  / _  | |  _ \  / __|  |  ___/ | |
   | |    | |    | (_| | | | | | \__ \  | |     | |
   |_|    |_|     \__,_| |_| |_| |___/  |_|     |_|
 ```
[![Chat on Gitter](https://img.shields.io/gitter/room/PalMuc/TransPi.svg?colorB=26af64&style=popout)](https://gitter.im/PalMuc/TransPi)
[![Nextflow](https://img.shields.io/badge/nextflow%20DSL1-%3D22.11.1--edge-23aa62.svg?labelColor=000000&logo=data:image/svg%2bxml;base64,PHN2ZyB3aWR0aD0iMjUxIiBoZWlnaHQ9IjI1MiIgdmlld0JveD0iMCAwIDI1MSAyNTIiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+DQo8cGF0aCBkPSJNMCA0Ny42MzQ1QzM5LjQ1IDUwLjI1NDMgNzEuMDYgODEuOTQyMiA3My41NCAxMjEuNDNIMTE5LjYxQzExNy4wNSA1Ni40NzM5IDY0LjkzIDQuMjU3NDQgMCAxLjU1NzYyVjQ3LjYzNDVaIiBmaWxsPSIjMjJBRTYzIi8+DQo8cGF0aCBkPSJNNzMuOCAxMzEuOTM5QzcxLjE4IDE3MS4zODYgMzkuNDkgMjAyLjk5NCAwIDIwNS40NzRWMjUxLjU0MUM2NC45NiAyNDguOTgxIDExNy4xOCAxOTYuODY1IDExOS44OCAxMzEuOTM5SDczLjhaIiBmaWxsPSIjMjJBRTYzIi8+DQo8cGF0aCBkPSJNMTc2LjIwMSAxMjEuMTZDMTc4LjgyMSA4MS43MTIyIDIxMC41MTEgNTAuMTA0MyAyNTAuMDAxIDQ3LjYyNDVWMS41NTc2MkMxODUuMDQxIDQuMTE3NDQgMTMyLjgyMSA1Ni4yMzM5IDEzMC4xMjEgMTIxLjE2SDE3Ni4yMDFaIiBmaWxsPSIjMjJBRTYzIi8+DQo8cGF0aCBkPSJNMjUwLjAwMSAyMDUuNDY0QzIxMC41NTEgMjAyLjg0NSAxNzguOTQxIDE3MS4xNTcgMTc2LjQ2MSAxMzEuNjY5SDEzMC4zOTFDMTMyLjk1MSAxOTYuNjI1IDE4NS4wNzEgMjQ4Ljg0MiAyNTAuMDAxIDI1MS41NDFWMjA1LjQ2NFoiIGZpbGw9IiMyMkFFNjMiLz4NCjwvc3ZnPg==)](https://www.nextflow.io/)
[![run with conda](https://img.shields.io/badge/run%20with-conda-3EB049.svg?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed.svg?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with apptainer/singularity](https://img.shields.io/badge/run%20with-apptainer%2Fsingularity-1E95D3.svg?labelColor=000000&logo=data:image/svg%2bxml;base64,PHN2ZyB3aWR0aD0iMjQ1IiBoZWlnaHQ9IjI0MCIgdmlld0JveD0iNjAgMCAzMTAgMjUwIiBmaWxsPSJub25lIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgk8cGF0aCBkPSJtIDI3MC4xOCwyNTMuOTggYyAtMS44LC0xLjIgLTMuNCwtMyAtNC40LC01LjIgbCAtNTIuNiwtMTE3LjQgYyAtMi4yLC00LjggLTMuOCwtOC42IC01LjIsLTExLjYgLTIuMiwtNC40IC0yLjIsLTUuNiAtMi4yLC02LjQgMCwtMi4yIDAuOCwtMy44IDIuNiwtNC44IHYgLTQuNCBoIC00My4yIHYgNC40IGMgMC44LDAuNCAxLjIsMS4yIDEuOCwxLjggMC40LDAuOCAwLjgsMS44IDAuOCwzIDAsMS4yIC0wLjQsMyAtMS44LDUuNiAtMS4yLDIuNiAtMi42LDUuNiAtNC40LDkuNCBsIC01MS44LDExNyBjIC0wLjgsMS44IC0yLjIsNC40IC0zLjgsNy40IC0xLjgsMyAtNC44LDQuNCAtOC4yLDQuOCB2IDMuOCBoIDQ5LjYgdiAtMy44IGMgLTUuNiwwIC04LjIsLTIuMiAtOC4yLC01LjYgMCwtMS44IDAuOCwtNC44IDMsLTkgMS44LC0zLjQgMy44LC03LjggNS42LC0xMiAyNC42LDkuNCA1Mi4yLDEwIDc2LjgsMC44IDIuMiw0LjQgMy44LDguMiA1LjIsMTEuMiAxLjgsMy40IDIuNiw2LjQgMi42LDguNiAwLDIuMiAtMC44LDMuOCAtMi4yLDQuOCAtMS4yLDAuNCAtMi4yLDAuOCAtMy40LDEuMiB2IDMuOCBoIDUwLjQgdiAtMy44IGMgLTIuOCwtMS44IC01LjQsLTIuOCAtNywtMy42IHogbSAtMTExLjQsLTQ3IDI3LjYsLTYxLjQgMjgsNjIuMiBjIC0xOCw2IC0zNy40LDYgLTU1LjYsLTAuOCB6IiBmaWxsPSJ3aGl0ZSIvPiA8cGF0aCBkPSJtIDg5Ljc4LDE0MC45OCBjIDAsLTkgMS4yLC0xNy42IDMuNCwtMjYuNCBsIC0yOCwtMTIuNiBjIC0zLjgsMTIgLTYsMjQuNiAtNiwzNy42IDAsMzUgMTQuMiw2OC42IDM5LjgsOTIuOCBsIDEuOCwtMy40IDExLjIsLTI1LjQgYyAtMTMuNiwtMTcuNCAtMjIuMiwtMzkgLTIyLjIsLTYyLjYgeiIgZmlsbD0iIzkzOTU5OCIvPiA8cGF0aCBkPSJtIDMxMC4xOCwxMDIuNTggLTI4LDEyLjYgYyAyLjIsOC4yIDMuNCwxNi44IDMuNCwyNS44IDAsMjMuOCAtOC42LDQ1LjggLTIyLjgsNjIuNiBsIDExLjYsMjUuNCAxLjgsMy40IGMgMjUuNCwtMjQuMiAzOS44LC01Ny44IDM5LjgsLTkyLjggLTAuMiwtMTIuNCAtMi4yLC0yNSAtNS44LC0zNyB6IiBmaWxsPSIjRjc5NDIxIi8+IDxwYXRoIGQ9Im0gNzEuMTgsODYuOTggMjcuNiwxMi42IGMgMTQuNiwtMzEgNDQuOCwtNTMgODAuMiwtNTYuMiB2IC0zMC42IGMgLTQ2LDIuNiAtODguNCwzMS40IC0xMDcuOCw3NC4yIHoiIGZpbGw9IiMxRTk1RDMiLz4gPHBhdGggZD0ibSAzMDQuMTgsODYuOTggYyAtMTkuNCwtNDIuOCAtNjEuOCwtNzEuNiAtMTA4LjQsLTc0LjYgdiAzMC42IGMgMzUuOCwzIDY2LDI1IDgwLjYsNTYuMiB6IiBmaWxsPSIjNkZCNTQ0Ii8+PC9zdmc+)](https://sylabs.io/docs/)
[![release](https://img.shields.io/github/v/release/PalMuc/TransPi?label=release&logo=github)](https://github.com/PalMuc/TransPi/releases/latest)

# Table of contents

* [General info](#General-info)
  * [Pipeline processes](#Pipelie-processes)
  * [Manual](#Manual)
* [Publication](#Publication)
  * [Citation](#Citation)
* [Funding](#Funding)
* [Future work](#Future-work)
* [Issues](#Issues)
  * [Chat](#Chat)

# General info

TransPi – a comprehensive TRanscriptome ANalysiS PIpeline for de novo transcriptome assembly

TransPi is based on the scientific workflow manager [Nextflow](https://www.nextflow.io). It is designed to help researchers get the best reference transcriptome assembly for their organisms of interest. It performs multiple assemblies with different parameters to get a non-redundant consensus assembly. It also performs other valuable analyses such as quality assessment of the assembly, BUSCO scores, Transdecoder (ORFs), and gene ontologies (Trinotate), etc. All these with minimum input from the user but without losing the potential of a comprehensive analysis.

## Pipeline processes

![TransPi flowchart](https://sync.palmuc.org/index.php/s/nrd3KPnfnz7AipF/preview)

**Figure 1.** TransPi v1.0.0 flowchart showing the various steps and analyses it can perform. For simplicity, this diagram does not show all the connections between the processes. Also, it omits other additional options like the BUSCO distribution and transcriptome filtering with psytrans (see Section 2.6). ORFs=Open reading Frames; HTML=Hypertext Markup Language.

## Manual

TransPi documentation and examples can be found [here](https://palmuc.github.io/TransPi/)

# Publication

A manuscript detailing TransPi, including kmer, reads length, and reads quantity tests, can be found in the [bioRxiv preprint](https://doi.org/10.1101/2021.02.18.431773) and [MER publication](https://onlinelibrary.wiley.com/doi/10.1111/1755-0998.13593) (see citations below). 

We also tested the pipeline with over 45 samples from different phyla.  
TransPi has been peer-reviewed and recommended by Peer Community In Genomics
(https://doi.org/10.24072/pci.genomics.100009)

## Citation

If you use TransPi please cite the peer-reviewed publication:

Rivera-Vicéns, R.E. et al. (2022) ‘TransPi—a comprehensive TRanscriptome ANalysiS PIpeline for de novo transcriptome assembly’, Molecular Ecology Resources, 22(5), pp. 2070–2086. Available at: https://doi.org/10.1111/1755-0998.13593.

Or the bioRxiv preprint:  

Rivera-Vicéns, R.E., García-Escudero, CA., Conci, N., Eitel, M., and Wörheide, G. (2021). TransPi – a comprehensive TRanscriptome ANalysiS PIpeline for de novo transcriptome assembly. bioRxiv 2021.02.18.431773; doi: https://doi.org/10.1101/2021.02.18.431773

# Funding

- European Union’s Horizon 2020 research and innovation programme under the Marie Skłodowska-Curie grant agreement No 764840 (ITN IGNITE).

- Advanced Human Capital Program of the National Commission for Scientific and Technological Research (CONICYT)

- Lehre@LMU (project number: W19 F1; Studi forscht@GEO)

- LMU Munich’s Institutional Strategy LMUexcellent within the framework of the German Excellence Initiative

# Future work

- Cloud deployment of the tool

# Issues

I (IB) tested TransPi using conda, singularity and apptainer. However, if you find a problem or get an error, please let me know by opening an issue.

1. The precheck script fails to download the UniProt database due to a change in the API, so large databases need to be downloaded manually from the web interface at this point - see [Issue #52](https://github.com/PalMuc/TransPi/issues/52) 
2. Missing BUSCO container in the configuration - [Issue #53](https://github.com/PalMuc/TransPi/issues/53#issuecomment-1268051333). In some HPC systems, a firewall/proxy blocks the automatic download of containers. This can be fixed by downloading all the required containers manually with the following command (make sure that `$NXF_SINGULARITY_CACHEDIR` is defined in your `~/.bashrc` and that you have [GNU-Parallel](https://www.gnu.org/software/parallel/) installed)  
```
grep "singularity_pull_docker_container" TransPi.nf | cut -f 2 -d '"' | sort | uniq | tr -d \' | parallel --dry-run --rpl  "{outfile} s=https://==; s=[:/]+=-=g;" wget {} -o $NXF_SINGULARITY_CACHEDIR/{outfile}.img
``` 

3. Use the single TransPiContainer container and profile to fix issues with some of the tools (see the [documentation](https://palmuc.github.io/TransPi/#_containers)).  
4. Apptainer was not supported in the original implementation of TransPi - I fixed this in commit [#06a5174](https://github.com/IdoBar/TransPi/commit/06a5174d6384a84a65604da91b15e49464f3adbb). Please note that you must use Nextflow v[22.11.1-edge](https://github.com/nextflow-io/nextflow/releases/tag/v22.11.1-edge) (`NXF_VER=22.11.1-edge`), which is one of the  few Nextflow versions that support both Apptainer *AND* older `dsl1` pipelines (at least until TransPi will be migrated to `dsl2`).
5. `Trinity` and `Velvet-Oases` jobs are failing, though they seem to complete without a problem (no output files are copied across from the compute nodes). It can be one of these possibilities:  
    a) It appears that the way TransPi is writing the version numbers throws an error (when `$v` is defined multiple times). I fixed it by using a single `echo`/`printf` statement, parsing the versions on the spot instead of assigning the temporary variables and printing them with multiple `echo` commands. This probably has to do with pipes failing silently (see below).  
    b) Some processes, such as `summary_custom_uniprot`, include complex pipelines (including multiple commands of `grep`, `sed`, `cut`, `awk`, etc.), fail due to `set -o pipefail` directive. It can be fixed by adding `set +o pipefail` to the top of the script.  
6. `Rnammer` fails - it needs to be set up to use `hmmsearch2` (which can be downloaded from [this link](http://eddylab.org/software/hmmer/hmmer-2.3.2.tar.gz) and remove the `--cpu 1` flag from `core-rnammer`, see details [here](https://groups.google.com/g/trinityrnaseq-users/c/WZjkGSMUT3I)).  It can be done with the following command: `sed -i.bak 's/--cpu 1 //g' rnammer-1.2/core-rnammer`
7. `rnaQUAST` fails -- it requires an additional tool (GeneMark S-T) to be installed and put in the `$PATH` separately. See details [here](https://github.com/ablab/rnaquast/issues/5#issuecomment-823996456). It can be installed as follows:  
```
mkdir -p ~/tools/GeneMarkST && cd ~/tools/GeneMarkST
wget http://topaz.gatech.edu/GeneMark/tmp/GMtool_ZozF5/gmst_linux_64.tar.gz
tar xzf gmst_linux_64.tar.gz
ln -s $PWD/gmst.pl ~/bin/
``` 
8. `signalp` fails - need to edit the executable to allow it to find where it is being run from and increase the sequence limit (see [here](https://www.seqanswers.com/forum/bioinformatics/bioinformatics-aa/29132-how-to-increase-sequence-limit-in-signalp#post236326)) with the following command:  
```
sed -ri.bak 's|SIGNALP} = '\''.+|SIGNALP} = "\$FindBin::RealBin"|; s/BEGIN/use FindBin\;
\nBEGIN/; s/MAX_ALLOWED_ENTRIES=.+/MAX_ALLOWED_ENTRIES=2000000;/' signalp
```
9. Process `summary_custom_uniprot` fails because of weird table merging and file redundancies done in bash. I edited `Tranbspi/bin/custom_uniprot_hits.R` to perform these tasks and export the `csv` file with the results.  

## Chat

If you have further questions and need help with TransPi you can try to chat with the original authors in the [TransPi Gitter chat](https://gitter.im/PalMuc/TransPi), raise an [Issue](https://github.com/IdoBar/TransPi/issues) in this repo or message me on my LinkedIn [Ido Bar](https://www.linkedin.com/in/idobar/) or X ([@DrIdoBar](https://x.com/DrIdoBar)) profiles.
