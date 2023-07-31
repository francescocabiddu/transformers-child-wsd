# Word Sense Disambiguation: Children vs Large Language Models

This repository contains the simulation and analysis scripts used in the paper "Cabiddu, F., Nikolaus, M., & Fourtassi, A. (submitted). Comparing children and large language models in word sense disambiguation: Insights and challenges. Language Development Research".

## Setup

1. **Install Anaconda**: Start by installing [Anaconda](https://www.anaconda.com/).

2. **Create a virtual environment**: Initialize a virtual environment using the provided `environment.yml` file to pre-install the necessary dependencies. You can refer to the [official Conda documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file) for more details.

## Usage

If you're starting the project from scratch, follow these steps:

1. **Prepare the data**: Run the `.R` files in the `r_project` folder. These scripts generate the training and test stimuli to be used by the Python scripts for running the Transformer models.

2. **Compute sense prototypes**: After creating the training and test stimuli, execute the following command:

    ```bash
    python create_1nn_vecs.py -dataset_id ChiSense-12_for_nlm_extended -nlm_id "bert-base-uncased roberta-base"
    ```

3. **Run Transformers on test stimuli**: Use the following command:

    ```bash
    python eval_1nn.py -dataset_id ChiSense-12_for_nlm_extended -nlm_id "bert-base-uncased roberta-base"
    ```

4. **Random initialization and downsampling**: Use the following additional arguments to run models with randomly initialized weights or to downsample the training sets to 40 sentences to compute sense prototypes:

    ```bash

    # random initialization
    python create_1nn_vecs.py -dataset_id ChiSense-12_for_nlm_extended -random_init True -nlm_id "bert-base-uncased roberta-base" 

    python eval_1nn.py -dataset_id ChiSense-12_for_nlm_extended -random_init True -nlm_id "bert-base-uncased roberta-base"

    # downsampling
    python create_1nn_vecs.py -dataset_id ChiSense-12_for_nlm -random_inst True -nlm_id "bert-base-uncased roberta-base"

    python eval_1nn.py -dataset_id ChiSense-12_for_nlm -random_inst True -nlm_id "bert-base-uncased roberta-base"
    ```

5. **45 Transformers**: Here's the list of models used in the project:

    ```bash
    "albert-base-v1 albert-base-v2 albert-large-v1 albert-large-v2 albert-xlarge-v1 albert-xlarge-v2 albert-xxlarge-v1 albert-xxlarge-v2 BabyBERTa_AO-CHILDES BabyBERTa_AO-CHILDES+AO-Newselsa+Wikipedia-1 BabyBERTa_AO-Newsela BabyBERTa_Wikipedia-1 bert-base-uncased bert-large-uncased bert-large-uncased-whole-word-masking ctrl microsoft/deberta-base microsoft/deberta-large microsoft/deberta-v2-xlarge microsoft/deberta-v2-xxlarge microsoft/deberta-v3-base microsoft/deberta-v3-large microsoft/deberta-v3-small microsoft/deberta-xlarge distilbert-base-uncased distilgpt2 distilroberta-base gpt2 gpt2-large gpt2-medium gpt2-xl openai-gpt roberta-base nyu-mll/roberta-base-1B-3 nyu-mll/roberta-base-10M-2 nyu-mll/roberta-base-100M-2 roberta-large nyu-mll/roberta-med-small-1M-2 t5-base t5-large t5-small transfo-xl-wt103 xlnet-base-cased xlnet-large-cased elmo"
    ```

6. **Analyze the results**: After the models' performance data has been saved to the `results` folder, you can analyze the results using the `.Rmd` files in the `r_project` folder. Note, sense prototypes and models' output files are already available in the repository, so you can directly use the .Rmd files to generate results included in the paper and appendix if do not want to start the project from scratch. 

## Directory Structure

- `data`: Contains data for computing prototypes and test data.
- `r_project`: Includes R project files to prepare data for prototype extraction and testing. Scripts to reproduce results of the paper.
- `results`: Contains models' results, including cosine similarities.
- `saved_babyberta_models`: Contains BabyBERTa models downloaded from [BabyBERTa's GitHub repository](https://github.com/phueb/BabyBERTa).
- `vectors`: Contains models' sense prototypes.

## Scripts

- `coarsewsd20_reader.py`: Python script to load senses and training/test sentences.
- `create_1nn_vecs.py`: Python script to create sense prototypes.
- `environment.yml`: Contains Python library requirements.
- `eval_1nn.py`: Python script to evaluate model performance at test.
- `nlm_encoder2.py`: Python script to download and set up computational models.
- `vectorspace.py`: Contains utility functions, including cosine similarity calculation.
- `import_BNC.ipynb`: Processes the Spoken British National Corpus and saves it to the R project directory.

Note: The Python scripts are adapted from [this GitHub repository](https://github.com/danlou/bert-disambiguation) (retrieved in October, 2022).
