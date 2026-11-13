#!/bin/bash
#SBATCH --job-name=scDINO_run       # Job name
#SBATCH --output=cluster_scripts/logs/run_%j.out   # Saves the normal output text
#SBATCH --error=cluster_scripts/logs/run_%j.err    # Saves any error messages if it crashes
#SBATCH --time=02:00:00             # Time limit 
#SBATCH --mem=32G                   # Request 32 GB of RAM
#SBATCH --gpus=1                    # Request 1 GPU 


module load cuda/11.8               # Optional: Load if your venv needs a specific CUDA module

source /scratch/$USER/scdino_venv/bin/activate

cd /scratch/$USER/scDINO

# Run the python script
python main_dino.py

