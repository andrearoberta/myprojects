int: num_rows = 5;
int: num_columns = 5;
int: num_vehicles = 25;

% Constants
int: max_vehicles = num_rows * num_columns;

% Decision Variables
array[1..num_rows, 1..num_columns] of var 0..1: allocation;

% Constraints

% Constraint 1: Each vehicle can be allocated to at most one parking space
constraint forall(i in 1..num_rows, j in 1..num_columns)(
  allocation[i,j] <= 1
);

% Constraint 2: The number of allocated parking spaces should be equal to the number of vehicles
constraint sum([allocation[i,j] | i in 1..num_rows, j in 1..num_columns]) = num_vehicles;

% Constraint 3: Ensure vehicles are parked in the corners and then fill the central spaces
constraint
  sum([allocation[i,j] | i in {1, num_rows}, j in {1, num_columns}]) = min(num_vehicles, 4) 
  /\ sum([allocation[i,j] | i in 2..num_rows-1, j in 2..num_columns-1]) = min(num_vehicles - min(num_vehicles, 4), (num_rows - 2) * (num_columns - 2));

% Constraint 4: Fill the remaining edge spaces
constraint sum([allocation[i,j] | i in 2..num_rows-1, j in {1, num_columns}]) + sum([allocation[i,j] | i in {1, num_rows}, j in 2..num_columns-1]) = num_vehicles - min(num_vehicles, 4) - min(num_vehicles - min(num_vehicles, 4), (num_rows - 2) * (num_columns - 2));

% Solve
solve maximize sum([allocation[i,j] | i in 1..num_rows, j in 1..num_columns]);

% Output
output [
  "Parking Utilization: ", show(num_vehicles), "\n",
  "Parking Allocation:\n",
  "----------\n"
] ++
[
  if j = num_columns then show(allocation[i,j]) ++ "\n" else show(allocation[i,j]) ++ " " endif |
  i in 1..num_rows, j in 1..num_columns
];
