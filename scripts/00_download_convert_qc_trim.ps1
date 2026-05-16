$project = "D:\rnaseq-als-pipeline"
$sraTools = "D:\tools\sratoolkit.current-win64\sratoolkit.3.1.1-win64\bin"

$samples = @(
    "SRR22511818",
    "SRR22511830",
    "SRR22511910",
    "SRR22511922"
)

New-Item -ItemType Directory -Force -Path "$project\data\raw"
New-Item -ItemType Directory -Force -Path "$project\data\fastq"
New-Item -ItemType Directory -Force -Path "$project\data\temp"

foreach ($sample in $samples) {
    & "$sraTools\prefetch.exe" $sample --output-directory "$project\data\raw"

    & "$sraTools\fasterq-dump.exe" "$project\data\raw\$sample" `
        -O "$project\data\fastq" `
        -t "$project\data\temp" `
        --threads 4 `
        --split-files
}