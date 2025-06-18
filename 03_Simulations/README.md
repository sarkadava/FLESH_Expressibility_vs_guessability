# Expressibility_vs_guessability/Simulations

In this folder, we use the expressibility ratings to simulate experiments with varying parameters, namely number of participants, number of concepts and the categories concepts are drawn from.

To run the Python script for simulations, follow these steps:

1) Open Terminal/Anaconda
2) Create virtual environment

conda create --name GUESS python=3.12   # if you already created the environment, skip this step

conda activate GUESS

3) Add environment to Jupyter Notebook

python -m ipykernel install --user --GUESS --display-name "Python (GUESS)"

4) Install requirements

cd 'Path/to/this/folder/'

pip install -r requirements.txt

