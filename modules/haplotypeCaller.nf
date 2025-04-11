// Use newest nextflow dsl
nextflow.enable.dsl = 2

process haplotypeCaller {
    if (params.platform == 'local') {
        label 'process_low'
    } else if (params.platform == 'cloud') {
        label 'process_high'
    }
    container 'staphb/freebayes:1.3.8'

    tag "$bamFile"

    input:
    tuple val(sample_id), file(bamFile), file(bamIndex)
    path indexFiles

    output:
    tuple val(sample_id), file("${sample_id}*.vcf")

    script:
    """
    echo "Running HaplotypeCaller for Sample: ${bamFile}"
    echo "no actually we're running freebayes I just inserted it here to test the pipeline"

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


    freebayes \
        -f "\${genomeFasta}" \
        "${bamFile}" > \${outputVcf} 

    echo "Sample: ${sample_id} VCF: \${outputVcf}"
    """
}


process gatkIndexer {
    container 'vortexing/gatk-samtools-bcftools:4.1.8.0-1.10-1.9'
    
    input: 
    tuple val(sample_id), file(vcfFile)

    output:
    tuple val(sample_id), file(vcfFile), file("${vcfFile}.idx")

    script:
    """
    # Remove MNPs using bcftools and overwrite the original VCF file
    bcftools view --exclude-types mnps ${vcfFile} -o ${vcfFile}

    # INDEXING
    gatk IndexFeatureFile -I "${vcfFile}"
    """
}

