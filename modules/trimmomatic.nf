process trimmomatic {
    label 'trimmomatic'
    container 'staphb/trimmomatic:latest'
    tag "$sample_id"

    //outputdir
    publishDir("$params.outdir/trimmomatic", mode:"copy")
    
    //inputs & outputs
    input: 
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("*.trimmed.fastq.gz")

    //script
    script:
    """
    echo "Trimming FASTQs with trimmomatic"
    mkdir -p trimmomatic_${sample_id}_logs

    # variable names for R1 and R2
    R1="${reads[0]}"
    R2="${reads[1]}"

    trimmomatic PE \
    -phred33 \$R1 \$R2 \
    ${sample_id}_R1.trimmed.fastq.gz ${sample_id}_R1.unpaired.fastq.gz \
    ${sample_id}_R2.trimmed.fastq.gz ${sample_id}_R2.unpaired.fastq.gz \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36 

    echo "trimming complete"
    """

}