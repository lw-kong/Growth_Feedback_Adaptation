# Effects of growth feedback on adaptive gene circuits: A dynamical understanding

This repository contains the codes and data from our paper Effects of growth feedback on adaptive gene circuits: A dynamical understanding, which is about to be published on eLife.

## Data

The circuit topologies used in this paper are stored in the folder 'Data'. Please refer to the MD file in that folder for more details.

## Simulations of circuit dynamics

The massive simulations of different network topologies with different sets of circuit parameters are run by 'LoopNet_Latin\solve_loopNet_Latin_6.m'. It relies on the network topology data from the 'Data' folder and various functions from the 'ODE' folder. The results are saved in 'save_simulations_all.mat'.

## Analysis

After the massive simulations, we perform our analysis on the simulation results, which are saved in 'save_simulations_all.mat'. So this file should always be loaded.
