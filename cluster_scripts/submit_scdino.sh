#!/bin/bash
#SBATCH --job-name=scdino_full_pbmc      # Job name
#SBATCH --output=scdino_%j.out   # Saves the normal output text
#SBATCH --error=scdino_%j.err   # Saves any error messages if it crashes
#SBATCH --time=04:00:00             # Time limit 
#SBATCH --mem=32G                   # Request 32 GB of RAM
#SBATCH --gpus=1                    # Request 1 GPU 


source /home/lcanto/.venvs/scdino_venv/bin/activate
cd /scratch/lcanto/scDINO

# Set local single-node rendezvous variables (prevents port errors)
export WORLD_SIZE=1
export RANK=0
export LOCAL_RANK=0
export MASTER_ADDR=localhost
export MASTER_PORT=29500


# Run the full 100-epoch training on your GPU
python pyscripts/main_dino.py \
    --parse_params "{
        'config_file': 'configs/scDINO_full_pipeline.yaml',
        'dataset_dir': '/shares/prbour.biovision.uzh/2_research/out/lcanto/scDINO_data/pbmc_raw/DeepPhenotype_PBMC_ImageSet_YSeverin/Training',
        'output_dir': '/scratch/lcanto/scDINO/test_run_output',
        'norm_per_channel_file': 'configs/norm_pbmc.json',
        'images_are_RGB': False,
        'epochs': 100,
        'warmup_epochs': 10,
        'batch_size_per_gpu': 64,
        'num_workers': 4,
        'arch': 'vit_small'
    }"


