nextflow.enable.dsl = 2

nextflow.trace.enable = true

process octopus {
    if params.platform == 'local' {
        label 'process_low'
    } else if params.platform == 'cloud' {
        label 'process_high'
    }
    container 'dancooke/octopus:invitae--eae1ab48_0'

    tag "$bamFile"
    input:
    tuple val(sample_id), file(bamFile), file(bamIndex), path indexFiles

    output:
    tuple val(sample_id), file("*.vcf"), file("*.vcf.idx")

    script:
    """
    echo "Running Octopus for Sample: ${bamFile}"

    if [[ -n ${params.genome_file} ]]; then
        genomeFasta=\$(basename ${params.genome_file})
    else
        genomeFasta=\$(find -L . -name '*.fasta')
    fi

    echo "Genome File: \${genomeFasta}"

    # Rename the dictionary file to the expected name if it exists
    if [[ -e "\${genomeFasta}.dict" ]]; then
        mv "\${genomeFasta}.dict" "\${genomeFasta%.*}.dict"
    fi

    outputVcf="\$(basename ${bamFile} _sorted_dedup_recalibrated.bam).vcf"

    ### RUN OCTOPUS ###
    octopus \
        --reference \${genomeFasta} \
        --reads ${bamFile} \
        --output \${outputVcf} \
        
    """
}