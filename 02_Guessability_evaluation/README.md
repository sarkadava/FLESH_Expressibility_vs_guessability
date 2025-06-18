# Expressibility_vs_guessability/02_Guessability_evaluation


In this folder, we prepare target-answer pairs from referential experiment, compute binary guess information and cosine similarity, and run validation of the relationship between guessability and expressibility as introduced in the manuscript.


For running Python scripts, follow these steps:

1) Open Terminal/Anaconda
2) Create virtual environment

conda create --name GUESS python=3.12

conda activate GUESS

3) Add environment to Jupyter Notebook

python -m ipykernel install --user --GUESS --display-name "Python (GUESS)"

4) Install requirements

cd 'Path/to/this/folder/'

pip install -r requirements.txt

5) Download ConceptNet numberbatch

In folder \numberbatch follow the url link to download the multilingual numberbatch (version 19.08) with word embeddings,
unzip the file