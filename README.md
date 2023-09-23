# An Off-line Optimized Planner for the Generation of Path and Orientation of Industrial Robots

## Introduction
## Reference
My complete work of thesis is publicly available on the Politecnico di Torino's website at **[this link](https://webthesis.biblio.polito.it/13103/)**.
## Algorithm explanation

The code in this repository has as a main objective the study of an optimal trajectory generator for a 6-axis industrial robot. As a case of study for this algorithm an operation of sealing of a hood has been taken in consideration of which is given a cloud of point describing the mentioned above operation, both from the path and the wrist orientation perspective in quaternions, as it can be seen from the figure below.

![image](https://github.com/Gabri92/An-Off-line-Optimized-Planner-for-the-Generation-of-Path-and-Orientation-of-Industrial-Robots/assets/64957258/0c0df686-a43a-44ff-a3ac-2668a9b71448)

Interpolating those points we can se that the path could be divide into two differente section:
* A technological path, where the robot is actually welding the hood
* A re-orientation path, where to robot detach from the hood and change its orientation in order to follow the rest of the technological path
![image](https://github.com/Gabri92/An-Off-line-Optimized-Planner-for-the-Generation-of-Path-and-Orientation-of-Industrial-Robots/assets/64957258/1f6f0278-f8ac-4a4b-866e-c8b53ee990da)

The focus here is to find a trajectory law which is an optimal trade-off between speed and accuracy of the robot approaching these two different paths in a unique work session.

## Trajectory planning based on FIR filters

The work is mainly based on the approach developed by Luigi Biagiotti and Claudio Melchiorri in **[this paper](https://ieeexplore.ieee.org/document/5509131)**. 
The work is divided into three parts, which gives life to structure in the below figure:

1. Given the via-points from the user, an algorithm to obtain the related control points is built
2. Building of a piecewise constant function from the control points
3. Sending this function into a cascade of particulars filters, called moving average filters

![image](https://github.com/Gabri92/An-Off-line-Optimized-Planner-for-the-Generation-of-Path-and-Orientation-of-Industrial-Robots/assets/64957258/0d70092a-32a1-4c97-971f-5cfeeb0623cd)

A personal implementation of this structur could be found into the **[BM_Filter folder](/BM_Filter/)**

## Optimization

My contribute to this work is to try to optimize the trajectory planner in order to obtain a choosable trade-off between accuracy on the path and a constant scalar velocity of the manipulator. <br>
In order to pursue the constant velocity of the robot a first step is to manipulatethe points by using **[Nurbs](https://en.wikipedia.org/wiki/Non-uniform_rational_B-spline)**. Nurbs curve
is defined as follows:
$$\dfrac{\sum\limits_{i=0}^{n} N_{i,p}(u)w_i\mathbf{P_i}}{\sum\limits_{i=0}^{n}N_{i,p}(u)w_i}$$
