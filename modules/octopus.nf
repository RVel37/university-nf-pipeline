nextflow.enable.dsl = 2

process octopus {
    if (params.platform == 'local') {
        label 'process_low'
    } else if (params.platform == 'cloud') {
        label 'process_high'
    }

    container 'dancooke/octopus:invitae--eae1ab48_0'

    tag "$bamFile"

    input:
    tuple val(sample_id), file(bamFile), file(bamIndex)
    path indexFiles

    output:
    tuple val(sample_id), file("*.vcf*"), file("*.vcf.idx*")

    script:
    """
    echo "Running Octopus for Sample: ${bamFile}"

    # Ensure genome fasta file is properly located
    if [[ -n ${params.genome_file} ]]; then
        genomeFasta=\$(basename ${params.genome_file})
    else
        genomeFasta=\$(find -L . -name '*.fasta' | head -n 1)
    fi

    echo "Genome File: \${genomeFasta}"

    # Check if the dictionary file exists and rename it if needed
    if [[ -e "\${genomeFasta}.dict" ]]; then
        mv "\${genomeFasta}.dict" "\${genomeFasta%.*}.dict"
    fi

    # Create output VCF filename based on BAM input
    outputVcf="\$(basename ${bamFile} .bam).vcf"

    echo "Output VCF will be: \${outputVcf}"
        
    ### RUN OCTOPUS ###

    echo "Executing Octopus with BAM file: \${bamFile}"
octopus \
--working-directory . \
--reads \${bamFile} \
--reference "\${genomeFasta}" \
--output \${outputVcf}

    echo "Octopus completed for sample: \${sample_id}"
       
    """
} 