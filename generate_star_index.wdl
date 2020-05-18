version 1.0

# ENCODE micro rna seq pipeline: generate star index
# Maintainer: Otto Jolanki

#CAPER docker quay.io/encode-dcc/mirna-seq-pipeline:v1.1
#CAPER singularity docker://quay.io/encode-dcc/mirna-seq-pipeline:v1.1

workflow generate_STAR_index {
    input {
        # Reference .fasta
        File reference_sequence
        # Annotation .gtf
        File annotation
        # Output filename
        String output_filename
        Int ncpus
        Int ramGB
        String disks = "local-disk 50 SSD"
    }

    call generate_index { input:
        genome_file=reference_sequence,
        annotation_file=annotation,
        output_file=output_filename,
        ncpus=ncpus,
        ramGB=ramGB,
        disks=disks,
    }
}

task generate_index {
    input {
        File genome_file
        File annotation_file
        String output_file
        Int ncpus
        Int ramGB
        String disks
    }

    command {
        python3 $(which generate_star_index.py) \
            --ncpus ${ncpus} \
            --annotation_file ${annotation_file} \
            --genome_file ${genome_file} \
            --output_file ${output_file}
    }

    output {
        File star_index = glob(output_file)[0]
        File star_log = glob("generate_star_index.log")[0]
    }

    runtime {
        cpu: ncpus
        memory: "${ramGB} GB"
        disks: disks
    }
}
