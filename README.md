# An Off-line Optimized Planner for the Generation of Path and Orientation of Industrial Robots

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

A personal implementation of this structure could be found into the **[BM_Filter folder](/BM_Filter/)**

## Optimization

My contribute to this work is to try to optimize the trajectory planner in order to obtain a choosable trade-off between accuracy on the path and a constant scalar velocity of the manipulator. <br>
In order to pursue the constant velocity of the robot a first step is to manipulatethe points by using **[Nurbs](https://en.wikipedia.org/wiki/Non-uniform_rational_B-spline)**. A *p*-th degree Nurbs curve
is defined as follows:
$$\mathbf{C}(u) = \dfrac{\sum\limits_{i=0}^{n} N_{i,p}(u)w_i\mathbf{P_i}}{\sum\limits_{i=0}^{n}N_{i,p}(u)w_i}$$

Tuning the weights of the Nurbs it is possible to take a point and bring it closer or push it away the associated control point. So, an algorithm able to automatically understand whether and where to move a certain point in order to flatten the curve if required has been implemented. The algorithm has been built so to have a local influence on the curve, so to avoid any modification of the curve when no action of reshaping is required, and to give to the user the possibility to decide how much heavy the modification should be.
After the reshaping another elaboration is needed for the geometric path is needed in order to make the cascade of filters works properly.
Two different algorithms have been implemented, in order to cope with the differences between trajectory planning on the geometric path and on the orientations. In fact, the filter works with uniform B-splines and so, if the objective is a constant scalar velocity of the manipulator, it is of crucial importance the distribution of the points along the path. The time duration between two consecutive points cannot change and must be equal to a certain time period T, so, being impossible to change the time, the only possible action is to redistribute the points so to have the same distance in terms of arc length between each couple of them. The result is the spatial distribution of the point which can bes seen in right image below.

![image](https://github.com/Gabri92/An-Off-line-Optimized-Planner-for-the-Generation-of-Path-and-Orientation-of-Industrial-Robots/assets/64957258/aa0a902c-5098-4fe7-87f4-c884b444cc8f)

In order to plan the trajectory for the set of orientations a quaternion approach was implemented. The quaternions path on the hood, and in many of these kinds of processes, shows a pretty constant behaviour interrupted by an abrupt change of value in the area where the manipulator changes its orientation. On a first sight, this problem would seem to be solvable through a low pass filter, but the solution is not so immediate since each quaternion framework is connected to the geometric path and must be coherent with it. Since a model designed to reach a constant scalar velocity of the robot was implemented, the frameworks of the manipulator must be consistent with this model. An appropriate and simple approach in order to obtain a smooth and less oscillatory behaviour is to compute the lines passing through two consecutive pairs of points and to assign the weight of the point on the base of the angle which the two lines form.
The result on a single quaternion is shown on the below figure.

![image](https://github.com/Gabri92/An-Off-line-Optimized-Planner-for-the-Generation-of-Path-and-Orientation-of-Industrial-Robots/assets/64957258/ce9cee0e-5477-458a-89af-8a0fd81cac2b)

All of the optimization's algorithm can be found in the **[Optimization](/Optimization/)** folder.
