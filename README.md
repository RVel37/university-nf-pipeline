## nextflow variant calling pipeline, branched from UoM's pipeline
Various adaptations of this pipeline have been made and can be found in their respective branches. 

### Current work in progress on the main branch: Octopus variant caller

When running this pipeline with:
```
# REFERENCE GENOME
$ cd data/genome
$ wget https://storage.googleapis.com/gcp-public-data--broad-references/hg38/v0/Homo_sapiens_assembly38.fasta

# FASTQ SAMPLES ("small samples" for workflow development)
$ cd ../samples
$ wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR151/003/SRR1518253/SRR1518253_1.fastq.gz && \
wget https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR151/003/SRR1518253/SRR1518253_2.fastq.gz

```

The pipeline will run until the `octopus.nf` process, at which point it is returning the following error: 

"At least one command line option --reads reads-file required but none present."

So far, I verified that:
- the BAM file enters the channel correctly
- The bash script part uses the correct name of the BAM files as input
- When going into the work directory and running Octopus on its own using the same Dockerhub image, it runs perfectly.

I am open to any help or suggestions on how to fix this bug. 
