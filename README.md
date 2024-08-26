# Effects of growth feedback on adaptive gene circuits: A dynamical understanding

This repository contains the codes and data from our paper Effects of growth feedback on adaptive gene circuits: A dynamical understanding, which is about to be published on eLife.

## Data

The circuit topologies used in this paper are stored in the folder 'Data'. Please refer to the MD file in that folder for more details.

## Simulations of circuit dynamics

The massive simulations of different network topologies with different sets of circuit parameters are run by 'LoopNet_Latin\solve_loopNet_Latin_6.m'. It relies on the network topology data from the 'Data' folder and various functions from the 'ODE' folder. The results are saved in 'save_simulations_all.mat'. Since GitHub has a limit on file size, we have uploaded this file to our [OSF repository](https://osf.io/yxm2v/).

## Analysis

After the massive simulations, we perform our analysis on the simulation results, which are saved in 'save_simulations_all.mat' in our [OSF repository](https://osf.io/yxm2v/). So this file should always be loaded.

### Distribution of different failure types

A key contribution of this work is the results showcasing distributions of various failure types across different circuit topologies. Recognizing that some readers may desire a detailed examination of distributions within specific circuit topologies, or families of circuits sharing similar motifs or connections, we have made all relevant data and code available. This enables the generation of pie charts akin to those presented in Fig. 2 of the paper, applicable to any subgroup of circuits we have studied.
