#!/bin/bash
#SBATCH --job-name=pbmc_extract
#SBATCH --output=logs/extract_%j.out
#SBATCH --error=logs/extract_%j.err
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --mem=32G


cd /scratch/lcanto/scDINO
export PATH="/home/lcanto/.venvs/scdino_venv/bin:$PATH"

module load miniforge3


# Set local single-node rendezvous variables (prevents port errors)
export CATALYST_CV_REQUIRED=0
export WORLD_SIZE=1
export RANK=0
export LOCAL_RANK=0
export MASTER_ADDR=localhost
export MASTER_PORT=29500



CKPT="/shares/prbour.biovision.uzh/2_research/out/lcanto/scDINO_data/pbmc_test_run/recent_run/scDINO_ViTs/full_vit_name/checkpoint.pth"
DATA_DIR="/shares/prbour.biovision.uzh/2_research/out/lcanto/scDINO_data/pbmc_raw/DeepPhenotype_PBMC_ImageSet_YSeverin/Training"
OUT_DIR="/shares/prbour.biovision.uzh/2_research/out/lcanto/scDINO_data/pbmc_test_run/extracted_features"
NORM_FILE="/scratch/lcanto/scDINO/configs/norm_pbmc.json"

mkdir -p "$OUT_DIR"
mkdir -p logs

echo "Starting Feature Extraction on $(hostname) at $(date)"
echo "Using Checkpoint: $CKPT"
echo "Dataset Source:   $DATA_DIR"
echo "Output Directory: $OUT_DIR"



/home/lcanto/.venvs/scdino_venv/bin/python /scratch/lcanto/scDINO/pyscripts/compute_CLS_features.py \
    --pretrained_weights "$CKPT" \
    --dataset_dir "$DATA_DIR" \
    --output_dir "$OUT_DIR" \
    --arch vit_tiny \
    --batch_size_per_gpu 128 \
    --num_workers 4 \
    --use_cuda True \
    --parse_params "{\
'selected_channels': [0, 1, 2],\
'channel_dict': {0: 'ch0', 1: 'ch1', 2: 'ch2'},\
'norm_per_channel_file': '$NORM_FILE'\
}"

echo "Extraction finished at $(date)"
