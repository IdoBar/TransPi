# TransPi - TRanscriptome ANalysiS PIpeline

```text
 _______                                 _____   _
|__   __|                               |  __ \ (_)
   | |     _ __    __ _   _ __    ___   | |__) | _
   | |    |  __|  / _  | |  _ \  / __|  |  ___/ | |
   | |    | |    | (_| | | | | | \__ \  | |     | |
   |_|    |_|     \__,_| |_| |_| |___/  |_|     |_|
 ```

[![Prepint](http://d2538ggaoe6cji.cloudfront.net/sites/default/files/images/favicon.ico)](https://doi.org/10.1101/2021.02.18.431773)[**Preprint**](https://doi.org/10.1101/2021.02.18.431773) &ensp;[![Chat on Gitter](https://img.shields.io/gitter/room/PalMuc/TransPi.svg?colorB=26af64&style=popout)](https://gitter.im/PalMuc/TransPi) &ensp;[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)&ensp;[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)&ensp;[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
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

TransPi is based on the scientific workflow manager [Nextflow](https://www.nextflow.io). It is designed to help researchers get the best reference transcriptome assembly for their organisms of interest. It performs multiple assemblies with different parameters to then get a non-redundant consensus assembly. It also performs other valuable analyses such as quality assessment of the assembly, BUSCO scores, Transdecoder (ORFs), and gene ontologies (Trinotate), etc. All these with minimum input from the user but without losing the potential of a comprehensive analysis.

## Pipeline processes

![TransPi flowchart](https://sync.palmuc.org/index.php/s/nrd3KPnfnz7AipF/preview)

**Figure 1.** TransPi v1.0.0 flowchart showing the various steps and analyses it can performed. For simplicity, this diagram does not show all the connections between the processes. Also, it omits other additional options like the BUSCO distribution and transcriptome filtering with psytrans (see Section 2.6). ORFs=Open reading Frames; HTML=Hypertext Markup Language.

## Manual

TransPi documentation and examples can be found [here](https://palmuc.github.io/TransPi/)

# Publication

Preprint of TransPi including kmer, reads length, and reads quantities tests can be found [here](https://doi.org/10.1101/2021.02.18.431773). Also we tested the pipeline with over 45 samples from different phyla.

TransPi has been peer-reviewed and recommended by Peer Community In Genomics
(https://doi.org/10.24072/pci.genomics.100009)

## Citation

If you use TransPi please cite the peer-reviewed publication:

Rivera-Vicéns, R.E., García-Escudero, CA., Conci, N., Eitel, M., and Wörheide, G. (2021). TransPi – a comprehensive TRanscriptome ANalysiS PIpeline for de novo transcriptome assembly. bioRxiv 2021.02.18.431773; doi: https://doi.org/10.1101/2021.02.18.431773

# Funding

- European Union’s Horizon 2020 research and innovation programme under the Marie Skłodowska-Curie grant agreement No 764840 (ITN IGNITE).

- Advanced Human Capital Program of the National Commission for Scientific and Technological Research (CONICYT)

- Lehre@LMU (project number: W19 F1; Studi forscht@GEO)

- LMU Munich’s Institutional Strategy LMUexcellent within the framework of the German Excellence Initiative

# Future work

- Cloud deployment of the tool

# Issues

I tested TransPi using conda, singularity and apptainer (IB). However, if you find a problem or get an error please let me know by opening an issue.

1. The precheck script fails to download the UniProt database due to change in the API, so large databases need to be downloaded manually from the web interface at this point - see [Issue #52](https://github.com/PalMuc/TransPi/issues/52) 
2. Missing BUSCO container in the configuration - [Issue #53](https://github.com/PalMuc/TransPi/issues/53#issuecomment-1268051333). In some HPC systems, a firewall/proxy blocks automatic download of containers. This can be fixed by downlodaing all the required containers manually with the following command (make sure that `$NXF_SINGULARITY_CACHEDIR` is defined in your `~/.bashrc` and that you have [GNU-Parallel](https://www.gnu.org/software/parallel/) installed)  
```
grep "singularity_pull_docker_container" TransPi.nf | cut -f 2 -d '"' | sort | uniq | tr -d \' | parallel --dry-run --rpl  "{outfile} s=https://==; s=[:/]+=-=g;" wget {} -o $NXF_SINGULARITY_CACHEDIR/{outfile}.img
``` 

3. Use the single TransPiContainer container and profile to fix issues with some of the tools (see the [documentation](https://palmuc.github.io/TransPi/#_containers)).  
4. Apptainer was not supported in the original implementation of TransPi - I fixed this in commit [#06a5174](https://github.com/IdoBar/TransPi/commit/06a5174d6384a84a65604da91b15e49464f3adbb) . Please note that you must use Nextflow v[22.11.1-edge](https://github.com/nextflow-io/nextflow/releases/tag/v22.11.1-edge) (`NXF_VER=22.11.1-edge`), which is one of the  few Nextflow versions that support both Apptainer *AND* older `dsl1` pipelines (at least until TransPi will be migrated to `dsl2`).
5. `Trinity` and `Velvet-Oases` jobs are failing though they seem to complete without a problem (no output files are copied across from the compute nodes). It can be one of these possibilities:  
    a) It appears that the way TransPi is writing the version numbers throws an error (when `$v` is defined multiple times). I fixed it by using a single `echo`/`printf` statement parsing the versions on the spot instead of assigning the temporary variables and printing them with multiple `echo` commands. This is probably has to do with pipes failing silently (see below).  
    b) Some processes, such as `summary_custom_uniprot`, include complex pipelines (including multiple commands of `grep`, `sed`, `cut`, `awk`, etc.), fail due to `set -o pipefail` directive. It can be fixed by adding `set +o pipefail` to the top of the script.  
6. `Rnammer` fails - it needs to be setup to use `hmmsearch2` (which can be downloaded from [this link](http://eddylab.org/software/hmmer/hmmer-2.3.2.tar.gz) and remove the `--cpu 1` flag from `core-rnammer`, see details [here](https://groups.google.com/g/trinityrnaseq-users/c/WZjkGSMUT3I)).  It can be done with the following command: `sed -i.bak 's/--cpu 1 //g' rnammer-1.2/core-rnammer`
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
9. Process `summary_custom_uniprot` fails because of weird table merging and file redundancies done in bash. I edited `Tranbspi//bin/custom_uniprot_hits.R` to perform these tasks and export the `csv` file with the results.  

## Chat

If you have further questions and need help with TransPi you can chat with us in the [TransPi Gitter chat](https://gitter.im/PalMuc/TransPi)
