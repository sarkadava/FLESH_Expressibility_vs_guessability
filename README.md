# Github repository to project Self-reported expressibility predicts communicative success: Open dataset, validation, and simulation

This repository stores coding pipeline to process, analyze & model data associated with the manuscript 'Self-reported expressibility predicts communicative success: Open dataset, validation, and simulation'. This project investigates whether perceived expressibility predicts real-time guessability of concepts in novel communication game.

This project has been preregistered on November 24, 2024 on [AsPredicted (#200596)](https://aspredicted.org/kmry-vx5s.pdf). 

## Structure of the project
[:dog:] Open dataset of perceived expressibility with raw values and modeled posterior estimates
[:white_check_mark:] Validation of perceived expressibility against real-time guessability
[:computer:] Simulation of experiments with varying design parameters using validated expressibility

## Repository structure
<pre>
├── 01_Expressibility              # Data, scripts, and models for modelling expressibility estimates ratings
│   ├── rawdata                    # Raw data to be preprocessed and modelled
|   ├── data                       # Processed dataframes
|   ├── scripts                    # Scripts for pre-processing and modelling  
|   ├── models                     # Models

├── 02_Guessability_evaluation     # Data, scripts, and models for evaluating the relationship between expressibility and guessability
│   ├── rawdata                    # Raw data to be preprocessed and modelled
│   ├── data                       # Processed dataframes
│   ├── scripts                    # Scripts for pre-processing and modelling  
|   ├── models                     # Models 
|   ├── plots                      # Visualizations 
│
├── 03_Simulations                 # Data, scripts and models for expressibility-related simulations 
│   ├── data                       # Processed dataframes
│   ├── scripts                    # Scripts for pre-processing and modelling  
|   ├── models                     # Models 
</pre>

## Prerequisites

- Python, jupyter notebook
- R, R studio

Werever necessary, a README contains information about how to install necessary Python packages. Rmarkdowns contain session info to retrieve the version of R and used packages.

## How to cite

