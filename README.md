# Effects of growth feedback on adaptive gene circuits: A dynamical understanding

This repository contains the code and data from our paper Dynamical mechanisms of growth-feedback effects on adaptive gene circuits, which will be published on eLife.

## Data

The circuit topologies used in this paper are stored in the folder 'Data'. Please refer to the MD file in that folder for more details.

## Simulations of circuit dynamics

The massive simulations of different network topologies with different sets of circuit parameters are run by 'LoopNet_Latin\solve_loopNet_Latin_6.m'. It relies on the network topology data from the 'Data' folder and various functions from the 'ODE' folder. The results are saved in 'save_simulations_all.mat'. Since GitHub has a limit on file size, we have uploaded this file to our [OSF repository](https://osf.io/pzy7r/).

## Analysis

After the massive simulations, we perform our analysis on the simulation results, which are saved in 'save_simulations_all.mat' in our [OSF repository](https://osf.io/pzy7r/). So this file should always be loaded.

### Distribution of different failure types

A key contribution of this work is the results showcasing distributions of various failure types across different circuit topologies. Recognizing that some readers may desire a detailed examination of distributions within specific circuit topologies, or families of circuits sharing similar motifs or connections, we have made all relevant data and code available. This enables the generation of pie charts akin to those presented in Fig. 2 of the paper, applicable to any subgroup of circuits we have studied.

After loading the MAT-file 'save_simulations_all.mat', you can run the code 'Analysis/plot_failure_reason_6_3.m' to generate the pie chart in Fig. 2 of the paper. Here, we use a loop `for network_i = 1:size(network_set,1) ... end` to generate the pie chart. By fixing `network_i` to a fixed value or including any conditions to filter out certain topologies, you may generate the pie chart for any subset of network topologies.

The categorization of failure types is accomplished by the codes 'Analysis/failure_reason_6_3.m' and 'Analysis/loss_6_3_type.m'. We have already merged their results into 'save_simulations_all.mat'.
