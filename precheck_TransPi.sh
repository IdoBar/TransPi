#!/usr/bin/env bash
export mypwd="$1"
read_c() {
    #Check reads
    cd $mypwd
    if [ ! -d reads/ ];then
        echo -e "\n\t\e[31m -- ERROR: Directory \"reads\" not present. Please create a directory \"reads\" and put the reads files there --\e[39m\n"
        exit 0
    elif [ -d reads/ ];then
        ls -1 reads/*.gz 2>&1 | head -n 1 >.readlist.txt
        if [ `cat .readlist.txt | grep -c "ls:\ cannot"` -eq 1 ];then
            echo -e "\n\t\e[31m -- ERROR: Directory \"reads\" is present but empty. Please copy your reads files --\e[39m\n"
            echo -e "\n\t -- Example: IndA_R1.fastq.gz IndA_R2.fastq.gz -- \n"
            exit 0
        else
            ls -1 reads/*.gz >.readlist.txt
            if [ $(( `cat .readlist.txt | wc -l` % 2 )) -eq 0 ];then
                echo -e "\n\t -- Reads found in $( pwd )/reads/ and in pairs -- \n"
                nind=$( cat .readlist.txt | cut -f 2 -d "/" | sed 's/R\{1,2\}.*//g' | sort -u | wc -l )
                echo -e "\n\t -- Number of samples: $nind -- \n"
            elif [ $(( `cat .readlist.txt | wc -l` % 2 )) -eq 1 ];then
                echo -e "\n\t\e[31m -- ERROR: Reads found in $( pwd )/reads/ but not in pairs. Make sure you have an R1 and R2 for each sample --\e[39m\n"
                echo -e "\n\t -- Example: IndA_R1.fastq.gz IndA_R2.fastq.gz -- \n"
                nind=$( cat .readlist.txt | cut -f 2 -d "/" | sed 's/R\{1,2\}.*//g' | sort -u | wc -l )
                echo -e "\n\t\e[31m -- Number of samples: $nind --\e[39m\n"
                exit 0
            fi
        fi
        rm .readlist.txt
    fi
}
os_c() {
    if [ -f /etc/os-release ];then
        echo -e "\n\t -- Downloading Linux Anaconda3 installation -- \n"
        curl -o Anaconda3-2019.10-Linux-x86_64.sh https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
    else
        echo -e "\n\t\e[31m -- ERROR: Are you in a Linux system? Please check requirements and rerun the pre-check --\e[39m\n"
        exit 0
    fi
}
source_c() {
    if [ -f ~/.bashrc ];then
        source ~/.bashrc
    fi
}
conda_c() {
    source ~/.bashrc
    #Check conda and environment
    check_conda=$( command -v conda )
    if [ "$check_conda" != "" ];then #&& [ "$ver" -gt "45" ];then
        echo -e "\n\t -- Conda seems to be installed in your system environment --\n"
        ver=$( conda -V | cut -f 2 -d " " | cut -f 1,2 -d "." | tr -d "." )
        if [ "$ver" -gt 45 ];then
            echo -e "\n\t -- Conda is installed (v4.5 or higher). Checking environment... --\n"
            #Check environment
            check_env=$( conda env list | grep -c "TransPi" )
	    if [ "$check_env" -eq 0 ];then
                echo -e "\n\t -- TransPi environment has not been created. Checking environment file... --\n"
                if [ -f transpi_env.yml ];then
                    echo -e "\n\t -- TransPi environment file found. Creating environment... --\n"
                    conda env create -f transpi_env.yml
                else
                    echo -e "\n\t\e[31m -- ERROR: TransPi environment file not found \(transpi_env.yml\). Please check requirements and rerun the pre-check --\e[39m\n"
                    exit 0
                fi
            elif [ "$check_env" -eq 1 ];then
                echo -e "\n\t -- TransPi environment is installed and ready to be used --\n"
            fi
        fi
    else
        echo -e "\n\t -- Conda is not intalled. Please install Anaconda (https://www.anaconda.com) and rerun this script --\n"
        echo -e -n "\n\t    Do you want to install Anaconda? (y,n,exit): "
        read ans
        case $ans in
            [yY] | [yY][eE][sS])
                os_c
                echo -e "\n\t -- Starting anaconda installation -- \n"
                bash Anaconda3-2019.10*.sh
                echo -e "\n\t -- Installation done -- \n"
                rm Anaconda3-2019.10*.sh
                source_c
                if [ -f transpi_env.yml ];then
                    echo -e "\n\t -- TransPi environment file found. Creating environment... --\n"
                    conda env create -f transpi_env.yml
                else
                    echo -e "\n\t\e[31m -- ERROR: TransPi environment file not found (transpi_env.yml). Please check requirements and rerun the pre-check --\e[39m\n"
                    exit 0
                fi
            ;;
            [nN] | [nN][oO])
                echo -e "\n\t\e[31m -- ERROR: Download and Install Anaconda. Then rerun the pre-check  --\e[39m\n"
                exit 0
            ;;
            exit)
	           echo -e "\n\t -- Exiting -- \n"
               exit 0
            ;;
            *)
                echo -e "\n\n\t\e[31m -- Yes or No answer not specified. Try again --\e[39m\n"
	            conda_c
            ;;
        esac
    fi
}
pfam_c() {
    #Check PFAM files
    cd $mypwd
    if [ ! -d hmmerdb/ ];then
        echo -e "\n\t -- Creating directory for the HMMER database --\n"
        mkdir hmmerdb
        cd hmmerdb
        echo -e "\n\t -- Downloading current release of PFAM for the HMMER database --\n"
        wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
        echo -e "-- Preparing files ... --\n"
        gunzip Pfam-A.hmm.gz
    elif [ -d hmmerdb/ ];then
        echo -e "\n\t -- Directory for the HMMER database is present --\n"
        cd hmmerdb
        if [ -f Pfam-A.hmm ];then
            echo -e "\n\t -- Pfam file is present iand ready to be used --\n"
        else
            echo -e "\n\t -- Downloading current release of PFAM for the HMMER database --\n"
            wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz
            echo -e "-- Preparing files ... --\n"
            gunzip Pfam-A.hmm.gz
        fi
    fi
}
bus_dow () {
    name=$1
    cd $mypwd
    if [ ! -d busco_db/ ];then
        echo -e "\n\t -- Creating directory for the BUSCO database --\n"
        mkdir busco_db
        cd busco_db
        bname=$( echo $name | cut -f 1 -d "_" )
        if [ `cat ../buslist.txt | grep "${bname};" | wc -l` -eq 1 ];then
            echo -e "\n\t -- Downloading BUSCO \"$name\" database --\n";wait
            wname=$( cat ../buslist.txt | grep "${bname};" | cut -f 2 -d ";" )
            wget $wname
            echo -e "\n\t -- Preparing files ... --\n";wait
            tname=$( cat ../buslist.txt | grep "${bname};" | cut -f 1 -d ";" | tr [A-Z] [a-z] )
            tar -xvf ${tname}*.tar.gz
            rm ${tname}*.tar.gz
            echo -e "\n\t -- DONE with BUSCO database --\n";wait
        fi
        dname=$( cat ../buslist.txt | grep "${bname};" | cut -f 1 -d ";" | tr [A-Z] [a-z] )
        if [ -d ${dname}_odb10 ];then
            export busna=${dname}_odb10
        fi
    elif [ -d busco_db/ ];then
        cd busco_db
        bname=$( echo $name | cut -f 1 -d "_" )
        dname=$( cat ../buslist.txt | grep "${bname};" | cut -f 1 -d ";" | tr [A-Z] [a-z] )
        if [ -d ${dname}_odb10 ];then
            echo -e "\n\t -- BUSCO \"$name\" database found -- \n"
            export busna=${dname}_odb10
        else
            bname=$( echo $name | cut -f 1 -d "_" )
            if [ `cat ../buslist.txt | grep "${bname};" | wc -l` -eq 1 ];then
                echo -e "\n\t -- Downloading BUSCO \"$name\" database --\n";wait
                wname=$( cat ../buslist.txt | grep "${bname};" | cut -f 2 -d ";" )
                wget $wname
                echo -e "\n\t -- Preparing files ... --\n";wait
                tname=$( cat ../buslist.txt | grep "${bname};" | cut -f 1 -d ";" | tr [A-Z] [a-z] )
                tar -xvf ${tname}*.tar.gz
                rm ${tname}*.tar.gz
                echo -e "\n\t -- DONE with BUSCO database --\n";wait
            fi
            dname=$( cat ../buslist.txt | grep "${bname};" | cut -f 1 -d ";" | tr [A-Z] [a-z] )
            if [ -d ${dname}_odb10 ];then
                export busna=${dname}_odb10
            fi
        fi
    fi
}
bus_c () {
    cd $mypwd
    echo -e "\n\t -- Selecting BUSCO database -- \n"
    PS3="
    Please select one (1-5): "
    if [ -f buslist.txt ];then
    select var in `cat buslist.txt | grep "###" | tr -d "#"`;do
    case $var in
        BACTERIA)
            echo -e "\n\t You selected BACTERIA. Which specific database? \n"
            PS3="
	    Please select database: "
            select var1 in `cat buslist.txt | sed -n "/##BACTERIA/,/#MAIN/p" | grep -v "##" | tr -d "#"`;do
    	    case $var1 in
    	        MAIN_MENU)
                    bus_c
                ;;
                *)
                if [ "$var1" != "" ];then
                    if [ `cat buslist.txt | grep -c "$var1"` -ge 1 ];then
                        bus_dow $var1
                    fi
                else
                    echo -e "\n\t Wrong option. Try again \n"
                    bus_c
                fi
            ;;
            esac
            break
            done
	   ;;
       EUKARYOTA)
            echo -e "\n\tYou selected EUKARYOTA. Which specific database? \n"
            PS3="
	    Please select database: "
            select var1 in `cat buslist.txt | sed -n "/##EUKARYOTA/,/#MAIN/p" | grep -v "##" | tr -d "#"`;do
        	case $var1 in
        	    MAIN_MENU)
                    bus_c
                ;;
                Arthropoda_\(Phylum\))
                    select var2 in `cat buslist.txt | sed -n "/##ARTHROPODA/,/#MAIN/p" | grep -v "##" | tr -d "#"`;do
                    case $var2 in
                    MAIN_MENU)
                        bus_c
                    ;;
                    *)
                    if [ "$var2" != "" ];then
                        if [ `cat buslist.txt | grep -c "$var2"` -ge 1 ];then
                            bus_dow $var2
                        fi
                    else
                        echo -e "\n\t Wrong option. Try again \n"
                        bus_c
                    fi
                    esac
                    break
                    done
                ;;
                Fungi_\(Kingdom\))
                    select var2 in `cat buslist.txt | sed -n "/##FUNGI/,/#MAIN/p" | grep -v "##" | tr -d "#"`;do
                    case $var2 in
                    MAIN_MENU)
                        bus_c
                    ;;
                    *)
                    if [ "$var2" != "" ];then
                        if [ `cat buslist.txt | grep -c "$var2"` -ge 1 ];then
                            bus_dow $var2
                        fi
                    else
                        echo -e "\n\t Wrong option. Try again \n"
                        bus_c
                    fi
                    esac
                    break
                    done
                ;;
                Plants_\(Kingdom\))
                    select var2 in `cat buslist.txt | sed -n "/##PLANTS/,/#MAIN/p" | grep -v "##" | tr -d "#"`;do
                    case $var2 in
                    MAIN_MENU)
                        bus_c
                    ;;
                    *)
                    if [ "$var2" != "" ];then
                        if [ `cat buslist.txt | grep -c "$var2"` -ge 1 ];then
                            bus_dow $var2
                        fi
                    else
                        echo -e "\n\t Wrong option. Try again \n"
                        bus_c
                    fi
                    esac
                    break
                    done
                ;;
                Protists_\(Clade\))
                    select var2 in `cat buslist.txt | sed -n "/##PROTIST/,/#MAIN/p" | grep -v "##" | tr -d "#"`;do
                    case $var2 in
                    MAIN_MENU)
                        bus_c
                    ;;
                    *)
                    if [ "$var2" != "" ];then
                        if [ `cat buslist.txt | grep -c "$var2"` -ge 1 ];then
                            bus_dow $var2
                        fi
                    else
                        echo -e "\n\t Wrong option. Try again \n"
                        bus_c
                    fi
                    esac
                    break
                    done
                ;;
                Vertebrata_\(Sub_phylum\))
                    select var2 in `cat buslist.txt | sed -n "/##VERTEBRATA/,/#MAIN/p" | grep -v "##" | tr -d "#"`;do
                    case $var2 in
                    MAIN_MENU)
                        bus_c
                    ;;
                    *)
                    if [ "$var2" != "" ];then
                        if [ `cat buslist.txt | grep -c "$var2"` -ge 1 ];then
                            bus_dow $var2
                        fi
                    else
                        echo -e "\n\t Wrong option. Try again \n"
                        bus_c
                    fi
                    esac
                    break
                    done
                ;;
                *)
                if [ "$var1" != "" ];then
                    if [ `cat buslist.txt | grep -c "$var1"` -ge 1 ];then
                        bus_dow $var1
                    fi
                else
                    echo -e "\n\t Wrong option. Try again \n"
                    bus_c
                fi
                ;;
            esac
            break
            done
        ;;
        ARCHAEA)
            echo -e "\n\tYou selected ARCHAEA. Which specific database? \n"
            PS3="
	    Please select database: "
            select var1 in `cat buslist.txt | sed -n "/##ARCHAEA/,/#MAIN/p" | grep -v "##" | tr -d "#"`;do
            case $var1 in
            	MAIN_MENU)
                    bus_c
                ;;
                *)
                if [ "$var1" != "" ];then
                    if [ `cat buslist.txt | grep -c "$var1"` -ge 1 ];then
                        bus_dow $var1
                    fi
                else
                    echo -e "\n\t Wrong option. Try again \n"
                    bus_c
                fi
                ;;
            esac
            break
            done
        ;;
        EXIT)
            echo -e "\n\t Exiting \n"
            exit 0
        ;;
        *)
            echo -e "\n\t Wrong option. Try again \n"
            bus_c
            ;;
    esac
    break
    done
    else
        echo -e "\n\t\e[31m -- ERROR: Please make sure that file \"buslist.txt\" is available. Please check requirements and rerun the pre-check --\e[39m\n\n"
	    exit 0
    fi
}
uni_c () {
    cd $mypwd
    cd uniprot_db
    PS3="
    Please select UNIPROT database to use: "
    select var in `ls *fasta`;do
        if [ "$var" != "" ];then
            echo -e "\n\t -- UNIPROT database selected: \"$var\" --\n"
            export unina=${var}
        else
            echo -e "\n\t Wrong option. Try again \n"
            uni_c
        fi
    break
    done
}
unicomp_c () {
    echo -e -n "\n\t    Do you want to uncompress the file(s)? (y,n,exit): "
    read ans
    case $ans in
        [yY] | [yY][eE][sS])
            echo -e "\n\n\t -- Uncompressing file(s) ... -- \n"
            gunzip *fasta.gz
        ;;
        [nN] | [nN][oO])
            echo -e "\n\t\e[31m -- ERROR: Please uncompress the file(s) and rerun the pre-check  --\e[39m\n"
            exit 0
        ;;
        exit)
            echo -e "\n\t -- Exiting -- \n"
            exit 0
        ;;
        *)
            echo -e "\n\n\t\e[31m -- Yes or No answer not specified. Try again --\e[39m\n"
            unicomp_c
        ;;
    esac
}
uniprot_c () {
    #Check UNIPROT
    cd $mypwd
    if [ ! -d uniprot_db/ ];then
        echo -e "\n\t -- Creating directory for the UNIPROT database --\n"
        mkdir uniprot_db
        cd uniprot_db/
        myuni=$( pwd )
        echo -e "\n\t -- TransPi uses customs protein databases from UNIPROT for the annotation -- \n"
        echo -e -n "\n\t    Do you want to download the current metazoan proteins from UNIPROT? (y,n,exit): "
        read ans
        case $ans in
            [yY] | [yY][eE][sS])
                echo -e "\n\n\t -- Downloading metazoa protein dataset from UNIPROT -- \n"
                echo -e "\n\t -- This could take a couple of minutes depending on connection. Please wait -- \n"
                curl -o uniprot_metazoa_33208.fasta.gz "https://www.uniprot.org/uniprot/?query=taxonomy:33208&format=fasta&compress=yes&include=no"
                gunzip uniprot_metazoa_33208.fasta.gz
                uni_c
            ;;
            [nN] | [nN][oO])
                echo -e "\n\t\e[31m -- ERROR: Please download your desire UNIPROT database and save it at \"$myuni\". rerun the pre-check  --\e[39m\n"
                exit 0
            ;;
            exit)
                echo -e "\n\t -- Exiting -- \n"
                exit 0
            ;;
            *)
                echo -e "\n\n\t\e[31m -- Yes or No answer not specified. Try again --\e[39m\n"
                uniprot_c
            ;;
        esac
    elif [ -d uniprot_db/ ];then
        cd uniprot_db/
        myuni=$( pwd )
        echo -e "\n\t -- UNIPROT database directory found at: $myuni -- \n"
        ls -1 *.fasta 2>&1 | head -n 1 >.unilist.txt
        if [ `cat .unilist.txt | grep -c "ls:\ cannot"` -eq 1 ];then
            ls -1 *.fasta.gz 2>&1 | head -n 1 >.unilist.txt
            if [ `cat .unilist.txt | grep -c "ls:\ cannot"` -eq 1 ];then
                echo -e "\n\t\e[31m -- ERROR: Directory \"$myuni\" is empty. Please download a UNIPROT database and rerun the pre-check --\e[39m\n"
                rm .unilist.txt
                uniprot_c
            else
                echo -e "\n\t\e[31m -- Directory \"$myuni\" is available but UNIPROT database is compressed --\e[39m\n"
                unicomp_c
                uni_c
                rm .unilist.txt
            fi
        else
            echo -e "\n\t -- Here is the list of UNIPROT files found at: $myuni -- \n"
            uni_c
            rm .unilist.txt
        fi
    fi
}
java_c () {
	export NXF_VER=20.01.0-edge && curl -s https://get.nextflow.io | bash 2>.error_nextflow
	check_err=$( head -n 1 .error_nextflow | grep -c "java: command not found" )
	if [ $check_err -eq 1 ];then
		echo -e "\n\t\e[31m -- ERROR: Please install Java 1.8 (or later). Requirement for Nextflow --\e[39m\n"
		exit 0
	fi
	rm .error_nextflow
}
nextflow_c () {
    #Check Nextflow
    cd $mypwd
    check_next=$( command -v nextflow | wc -l )
    if [ $check_next -eq 1 ];then
        echo -e "\n\t -- Nextflow is installed -- \n"
    elif [ $check_next -eq 0 ];then
	check_next=$( ./nextflow info | head -n 1 | wc -l )
        if [ $check_next -eq 1 ];then
            echo -e "\n\t -- Nextflow is installed -- \n"
	    else
            echo -e -n "\n\t    Do you want to install Nextflow? (y or n): "
            read ans
            case $ans in
                [yY] | [yY][eE][sS])
                    echo -e "\n\t -- Downloading Nextflow ... -- \n"
                    java_c
		    		echo -e "\n\t -- Nextflow is now installed on $mypwd (local installation) -- \n"
                ;;
                [nN] | [nN][oO])
                    echo -e "\n\t\e[31m -- ERROR: Download and Install Nextflow. Then rerun the pre-check  --\e[39m\n"
                    exit 0
                ;;
                *)
                    echo -e "\n\n\t\e[31m -- Yes or No answer not specified. Try again --\e[39m\n"
                    nextflow_c
                ;;
            esac
	    fi
    fi
}
#evi_bash_c () {
#    if [ -f ~/.bashrc ];then
#        if [ `cat ~/.bashrc | grep -c "evigene"` -eq 0 ];then
#            echo -e "\n\t -- PATHs added to the "~/.bashrc". Before running the pipeline please "source ~/.bashrc" -- \n"
#            echo -e "# EvidentialGene\nexport PATH=\"\$PATH:${mypwd}/evigene/scripts/prot/\"\n# EvidentialGene(other scripts)\nexport PATH=\"\$PATH:${mypwd}/evigene/scripts/\"\n">> ~/.bashrc
#            echo -e "export PATH=\"\$PATH:${mypwd}/evigene/scripts/ests/\"\nexport PATH=\"\$PATH:${mypwd}/evigene/scripts/genes/\"\nexport PATH=\"\$PATH:${mypwd}/evigene/scripts/genoasm/\"\n">> ~/.bashrc
#            echo -e "export PATH=\"\$PATH:${mypwd}/evigene/scripts/omcl/\"\nexport PATH=\"\$PATH:${mypwd}/evigene/scripts/rnaseq/\"\n" >> ~/.bashrc
#            rm .varfile.sh
#            source_c
#        else
#            rm .varfile.sh
#            source_c
#        fi
#    fi
#}
evi_c () {
	cd $mypwd
    check_evi=$( command -v tr2aacds.pl | wc -l )
    if [ $check_evi -eq 0 ];then
        if [ ! -d evigene/ ];then
        echo -e "\n\t -- EvidentialGene is not installed -- \n"
        echo -e -n "\n\t    Do you want to install EvidentialGene? (y or n): "
        read ans
        case $ans in
            [yY] | [yY][eE][sS])
                echo -e "\n\t -- Downloading EvidentialGene ... -- \n"
                wget http://arthropods.eugenes.org/EvidentialGene/other/evigene_old/evigene_older/evigene19may14.tar 
                tar -xf evigene19may14.tar
                mv evigene19may14/ evigene/
                rm evigene19may14.tar
            ;;
            [nN] | [nN][oO])
                echo -e "\n\t\e[31m -- ERROR: Download and Install EvidentialGene. Then rerun the pre-check  --\e[39m\n"
                exit 0
            ;;
            *)
                echo -e "\n\n\t\e[31m -- Yes or No answer not specified. Try again --\e[39m\n"
                evi_c
            ;;
        esac
        else
            echo -e "\n\t -- EvidentialGene directory was found at $mypwd (local installation) -- \n"
        fi
    elif [ $check_evi -eq 1 ];then
        echo -e "\n\t -- EvidentialGene is already installed -- \n"
    fi
}
trisql_c () {
    source ~/.bashrc
    check_conda=$( command -v conda )
    if [ "$check_conda" == "" ];then
        echo -e "\n\t\e[31m -- Looks like conda is not installed--\e[39m\n"
        exit 0
    fi
    if [ ! -e *.sqlite ];then
        echo -e "\n\t -- Custom sqlite database for Trinotate is not installed -- \n"
        echo -e -n "\n\t    Do you want to install the custom sqlite database? (y or n): "
        read ans
        case $ans in
            [yY] | [yY][eE][sS])
                echo -e "\n\t -- This could take a couple of minutes depending on connection. Please wait -- \n"
                if [ ! -f ~/anaconda3/etc/profile.d/conda.sh ];then
                    echo -e -n "\n\t    Provide the full PATH of your Anaconda installation (Examples: /home/bioinf/anaconda3 ,  ~/tools/anaconda3 ,  ~/tools/py3/anaconda3): "
                    read ans
                    source ${ans}/etc/profile.d/conda.sh
                    conda activate TransPi
                    check_sql=$( command -v Build_Trinotate_Boilerplate_SQLite_db.pl | wc -l )
                    if [ $check_sql -eq 0 ];then
                        echo -e "\n\t -- Script "Build_Trinotate_Boilerplate_SQLite_db.pl" from Trinotate cannot be found -- \n"
                        echo -e "\n\t\e[31m -- Verify your conda installation --\e[39m\n"
                        exit 0
                    elif [ $check_sql -eq 1 ];then
                        Build_Trinotate_Boilerplate_SQLite_db.pl Trinotate
                        rm Pfam-A.hmm.gz uniprot_sprot.dat.gz
                    fi
                elif [ -f ~/anaconda3/etc/profile.d/conda.sh ];then
                    source ~/anaconda3/etc/profile.d/conda.sh
                    conda activate TransPi
                    check_sql=$( command -v Build_Trinotate_Boilerplate_SQLite_db.pl | wc -l )
                    if [ $check_sql -eq 0 ];then
                        echo -e "\n\t -- Script "Build_Trinotate_Boilerplate_SQLite_db.pl" from Trinotate cannot be found -- \n"
                        echo -e "\n\t\e[31m -- Verify your conda installation --\e[39m\n"
                        exit 0
                    elif [ $check_sql -eq 1 ];then
                        Build_Trinotate_Boilerplate_SQLite_db.pl Trinotate
                        rm Pfam-A.hmm.gz uniprot_sprot.dat.gz
                    fi
                fi
            ;;
            [nN] | [nN][oO])
                echo -e "\n\t\e[31m -- ERROR: Generate the custom trinotate sqlite database at "${mypwd}/sqlite_db". Then rerun the pre-check  --\e[39m\n"
                exit 0
            ;;
            *)
                echo -e "\n\n\t\e[31m -- Yes or No answer not specified. Try again --\e[39m\n"
                trisql_c
            ;;
        esac
    else
        echo -e "\n\t -- Custom sqlite database for Trinotate found at "${mypwd}/sqlite_db" -- \n"
    fi
}
buildsql_c () {
    cd ${mypwd}
    if [ -d sqlite_db/ ];then
        cd sqlite_db
        trisql_c
    else
        mkdir sqlite_db/
        cd sqlite_db
        trisql_c
    fi
}
cbs_dtu_c () {
    cd $mypwd
    if [ -f cbs-dtu-tools.tar.gz ] && [ ! -d cbs-dtu-tools/ ];then
        echo -e "\n\t -- Preparing scripts of CBS-DTU -- \n"
        echo -e "\n\t -- Uncompressing files -- \n"
        tar -xvf cbs-dtu-tools.tar.gz
        #rnammer
        cd cbs-dtu-tools/rnammer/
        name=$( pwd )
        sed -i "s|/home/ubuntu/pipe/rnammer|$name|g" rnammer
        cd ..
        #signalP
        cd signalp-4.1/
        name=$( pwd )
        sed -i "s|/home/ubuntu/pipe/signalp-4.1|$name|g" signalp
        cd ..
    elif [ -f cbs-dtu-tools.tar.gz ] && [ -d cbs-dtu-tools/ ];then
        cd cbs-dtu-tools/rnammer/
        name=$( pwd )
        sed -i "s|/home/ubuntu/pipe/rnammer|$name|g" rnammer
        cd ..
        #signalP
        cd signalp-4.1/
        name=$( pwd )
        sed -i "s|/home/ubuntu/pipe/signalp-4.1|$name|g" signalp
        cd ..
    elif [ ! -f cbs-dtu-tools.tar.gz ] && [ ! -d cbs-dtu-tools/ ];then
        echo -e "\n\t\e[31m -- ERROR: Please make sure the cbs-dtu-tools.tar.gz is available. Then rerun the pre-check  --\e[39m\n"
        exit 0
    fi
}
util_c () {
    source ~/.bashrc
    cpath=$( conda env list | grep "TransPi" | awk '{print $2}' )
    sed -i "s|RealBin/util|RealBin|g" ${cpath}/bin/RnammerTranscriptome.pl
}
get_var () {
    cd $mypwd
    #echo "=$mypwd/" >${mypwd}/.varfile.sh
    echo "buscodb=$mypwd/busco_db/$busna" >${mypwd}/.varfile.sh
    echo "uniname=$unina" >>${mypwd}/.varfile.sh
    echo "uniprot=$mypwd/uniprot_db/$unina" >>${mypwd}/.varfile.sh
    echo "pfloc=$mypwd/hmmerdb/Pfam-A.hmm" >>${mypwd}/.varfile.sh
    echo "pfname=Pfam-A.hmm" >>${mypwd}/.varfile.sh
    echo "nextflow=$mypwd/nextflow" >>${mypwd}/.varfile.sh
    echo "Tsql=$mypwd/sqlite_db/*.sqlite" >>${mypwd}/.varfile.sh
    echo "rnam=$mypwd/cbs-dtu-tools/rnammer/rnammer" >>${mypwd}/.varfile.sh
    echo "tmhmm=$mypwd/cbs-dtu-tools/tmhmm-2.0c/bin/tmhmm" >>${mypwd}/.varfile.sh
    echo "signalp=$mypwd/cbs-dtu-tools/signalp-4.1/signalp" >>${mypwd}/.varfile.sh
    vpwd=$mypwd
    echo "mypwd=$mypwd" >>${vpwd}/.varfile.sh
    source .varfile.sh
    echo -e "\n\t -- INFO to use in the pipeline --\n"
    echo -e "\t Pipeline PATH:\t\t $mypwd"
    echo -e "\t BUSCO database:\t $buscodb"
    echo -e "\t UNIPROT database:\t $uniprot"
    echo -e "\t PFAM files:\t\t $pfloc"
    echo -e "\t NEXTFLOW:\t\t $nextflow \n\n"
    cat template.nextflow.config | sed -e "s|mypwd|mypwd=\"${mypwd}\"|" -e "s|buscodb|buscodb=\"${buscodb}\"|" -e "s|uniprot|uniprot=\"${uniprot}\"|" \
        -e "s|uniname|uniname=\"${uniname}\"|" -e "s|pfloc|pfloc=\"${pfloc}\"|" -e "s|pfname|pfname=\"${pfname}\"|" -e "s|Tsql|Tsql=\"${Tsql}\"|" \
        -e "s|reads=|reads=\"${mypwd}|" -e "s|rnam|rnam=\"${rnam}\"|" -e "s|tmhmm|tmhmm=\"${tmhmm}\"|" -e "s|signalp|signalp=\"${signalp}\"|" >nextflow.config
#    evi_bash_c
    #Temporary rm of .varfile.sh
    rm .varfile.sh
}
#Main
if [ "$mypwd" == "" ] || [ "$mypwd" == "-h" ] || [ "$mypwd" == "-help" ] || [ "$mypwd" == "--help" ];then
    echo -e "\n\t Script for checking the requirenments of TransPi \n"
    echo -e "\t Usage:\n\n\t\t pre-check_TransPi.sh WORK_PATH \n"
    echo -e "\n\t\t\t WORK_PATH = PATH to run TransPi and download the requirenments \n\n\t\t\t\t Example: /home/bioinf/run/ \n"
    exit 0
elif [ ! -d "$mypwd" ];then
    echo -e "\n\t -- Please provide a valid PATH to run TransPi -- \n"
    exit 0
elif [ -d "$mypwd" ];then
    cd $mypwd
    read_c
    conda_c
    pfam_c
    bus_c
    uniprot_c
    nextflow_c
    evi_c
    buildsql_c
    cbs_dtu_c
    util_c
    echo -e "\n\t -- If no \"ERROR\" was found and all the neccesary databases are installed proceed to run TransPi -- \n"
    get_var
fi
