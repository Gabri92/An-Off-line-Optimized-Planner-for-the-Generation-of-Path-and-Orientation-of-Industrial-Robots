# An Off-line Optimized Planner for the Generation of Path and Orientation of Industrial Robots

## Introduction
## Reference
My complete work of thesis is publicly available on the Politecnico di Torino's website at **[this link](https://webthesis.biblio.polito.it/13103/)**.
## Algorithm explanation

The code in this repository has as a main objective the study of an optimal trajectory generator for a 6-axis industrial robot. As a case of study for this algorithm an operation of sealing of a hood has been taken in consideration of which is given a cloud of point describing the mentioned above operation, both from the path and the wrist orientation perspective in quaternions, as it can be seen from the figure below.

![image](https://github.com/Gabri92/An-Off-line-Optimized-Planner-for-the-Generation-of-Path-and-Orientation-of-Industrial-Robots/assets/64957258/0c0df686-a43a-44ff-a3ac-2668a9b71448)

## Trajectory planning based on FIR filters

The work is mainly based on the approach developed by Luigi Biagiotti and Claudio Melchiorri in **[this paper](https://ieeexplore.ieee.org/document/5509131)**. 
The work is divided into three parts, which gives life to structure in the below figure:

1. Given the via-points from the user, an algorithm to obtain the related control points is built
2. Building of a piecewise constant function from the control points
3. Sending this function into a cascade of particulars filters, called moving average filters

![image](https://github.com/Gabri92/An-Off-line-Optimized-Planner-for-the-Generation-of-Path-and-Orientation-of-Industrial-Robots/assets/64957258/0d70092a-32a1-4c97-971f-5cfeeb0623cd)

A personal implementation of this structur could be found into the **[BM_Filter folder](/BM_Filter/)**

My contribute to this work is to try to optimize the trajectory planner in order to obtain a choosable trade-off between accuracy on the path and a constant scalar velocity of the manipulator.
