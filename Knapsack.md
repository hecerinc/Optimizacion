# Knapsack


## 1/0 knapsack

- single bag with max weight C
- set of items with weight w<sub>i</sub> and profit p<sub>i</sub>
- **Objective:** find subset of elements that give max profit without exceeding max weight



## Branch & Bound Solution

1. Organise elements in descending order by their `profit/weight` ratio.
2. Define a max expected profit.

### Heuristic

One way to estimate the max expected profit is to assume that the rest of the space will be filled by the best `profit/weight` ratio:

![Knapsack Heuristic](img/knapsack_heuristic.PNG)

- `ub`: best possible value
- `p`: accumulated profit
- `w`: accumulated weight


You can quickly stop branching nodes that will not yield a better answer.

These are the nodes that have a best possible value (`ub`) _smaller_ than the best obtained profit (`p`).


## Heuristic Approach

Some standard heuristics for the 0/1 Knapsack problem are:

1. **DEFAULT** (`Def`): select elements in the order given
2. **MAX PROFIT** (`MaP`): select highest profit element
3. **MIN WEIGHT** (`MiW`): select minimum weight element
4. **Max Profit/Weight** (`MPW`): select best `profit/weight` ratio




## Hyper-heuristics

### Features

For the 0/1 knapsack problem we can use the following features of the remaining elements

1. **Profit**: 
	- Normalized mean
	- Normalized median
	- Normalized standard deviation
2. **Weight**: 
	- Normalized mean
	- Normalized median
	- Normalized standard deviation
3. **Correlation**: between profit and weight. Divided by `2` plus `0.5`. MATLAB: `corr(w,p)`

**Normalized** means that the values should be in `[0,1]`. To do this, divide by the largest number in the set.


## Hyper heuristic calculation

1. Make the hyper heuristic matrix
2. Calculate the feature values for your set of items for each rule in the matrix
3. Get the eucledian distance for each feature for each rule in the matrix
4. Activate the rule with the smallest abs(distance)
5. Repeat for each iteration of the problem (remaining item in the list)

