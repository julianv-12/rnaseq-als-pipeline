# RNA-seq ALS pipeline - QC + Trimming
# Autor: Julia
# Paso: FastQC (raw) → Trimmomatic → FastQC (trimmed) → MultiQC

$project = "D:\rnaseq-als-pipeline"

$fastqc = "D:\tools\fastqc_v0.12.1\FastQC\run_fastqc.bat"
$trimmomatic = "D:\tools\Trimmomatic-0.39\Trimmomatic-0.39\trimmomatic-0.39.jar"

$samples = @(
    "SRR22511818",
    "SRR22511830",
    "SRR22511910",
    "SRR22511922"
)

# ==============================
# 1. FASTQC RAW
# ==============================

Write-Host "Running FastQC on raw data..."

& $fastqc "$project\data\fastq\*.fastq"

mkdir "$project\data\qc_raw" -Force
move "$project\data\fastq\*_fastqc.*" "$project\data\qc_raw\" -Force

# ==============================
# 2. TRIMMING
# ==============================

Write-Host "Running Trimmomatic..."

mkdir "$project\data\trimmed" -Force

foreach ($sample in $samples) {

    java -jar $trimmomatic PE `
        -threads 4 `
        "$project\data\fastq\${sample}_1.fastq" `
        "$project\data\fastq\${sample}_2.fastq" `
        "$project\data\trimmed\${sample}_1.paired.fastq" `
        "$project\data\trimmed\${sample}_1.unpaired.fastq" `
        "$project\data\trimmed\${sample}_2.paired.fastq" `
        "$project\data\trimmed\${sample}_2.unpaired.fastq" `
        "ILLUMINACLIP:$project\refs\adapters\TruSeq3-PE.fa:2:30:10" `
        "HEADCROP:10" `
        "SLIDINGWINDOW:4:20" `
        "MINLEN:36"
}

# ==============================
# 3. FASTQC TRIMMED
# ==============================

Write-Host "Running FastQC on trimmed data..."

& $fastqc "$project\data\trimmed\*.paired.fastq"

mkdir "$project\data\qc_trimmed" -Force
move "$project\data\trimmed\*_fastqc.*" "$project\data\qc_trimmed\" -Force

# ==============================
# 4. MULTIQC
# ==============================

Write-Host "Running MultiQC..."

cd "$project\data\qc_trimmed"
multiqc .

Write-Host "Pipeline QC + trimming completed!"