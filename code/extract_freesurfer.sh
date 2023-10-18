#!/bin/bash
set -e -u -x

subid="$1"
wd=${PWD}

cd inputs/data
7z x ${subid}_freesurfer-*.zip
if [[ ! -d ./freesurfer/${subid} ]]; then
    if [[ ${subid} == *"_ses-"* ]]; then
        echo "Detected a multises input. Renaming freesurfer directory"
        subid_only=$(echo ${subid} | cut -d "_" -f 1)
        mv "./freesurfer/${subid_only}" "./freesurfer/${subid}"
    else
        echo "unclear what the freesurfer directory should be for ${subid}"
        exit 1
    fi
fi

cd $wd

mkdir -p freesurfer/${subid}

bash ./freesurfer_tabulate/collect_stats_to_tsv.sh \
    ${subid} \
    ${PWD}/inputs/data/freesurfer \
    ${PWD}/fstabulate-containers/.datalad/environments/fmriprep-20-2-3/image \
    ${PWD}/fstabulate-containers/.datalad/environments/neuromaps-main/image \
    ${PWD}/freesurfer/${subid}

