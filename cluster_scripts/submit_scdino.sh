#!/bin/bash
#SBATCH --job-name=scdino_fast_test
#SBATCH --output=scdino_%j.out
#SBATCH --error=scdino_%j.err
#SBATCH --time=04:00:00
#SBATCH --gpus=1
#SBATCH --mem=32G

cd /scratch/lcanto/scDINO
export PATH="/home/lcanto/.venvs/scdino_venv/bin:$PATH"


# Set local single-node rendezvous variables (prevents port errors)
export WORLD_SIZE=1
export RANK=0
export LOCAL_RANK=0
export MASTER_ADDR=localhost
export MASTER_PORT=29500


# Run the full 100-epoch training on your GPU
/home/lcanto/.venvs/scdino_venv/bin/python pyscripts/main_dino.py \
    --parse_params "{
        'config_file': 'configs/scDINO_full_pipeline.yaml',
        'dataset_dir': '/shares/prbour.biovision.uzh/2_research/out/lcanto/scDINO_data/pbmc_raw/DeepPhenotype_PBMC_ImageSet_YSeverin/Training',
        'output_dir': '/scratch/lcanto/scDINO/test_run_output',
        'norm_per_channel_file': 'configs/norm_pbmc.json',
        'images_are_RGB': False,
        'epochs': 10,
        'warmup_epochs': 0,
        'batch_size_per_gpu': 16,
        'num_workers': 4,
        'arch': 'vit_tiny'
    }"

