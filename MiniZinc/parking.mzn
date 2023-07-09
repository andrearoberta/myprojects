int: num_rows = 20;
int: num_columns = 20;
int: num_vehicles = 100;

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

% Constraint 3: Ensure vehicles are parked in the most central seats and gradually towards the central side seats
constraint forall(k in 1..(num_rows div 2))(
  let {
    int: start_row = k;
    int: end_row = num_rows - k + 1;
    int: start_col = k;
    int: end_col = num_columns - k + 1;
    int: max_vehicles_layer = (end_row - start_row + 1) * (end_col - start_col + 1);
    int: vehicles_layer = min(num_vehicles, max_vehicles_layer)
  } in
  sum([allocation[i,j] | i in start_row..end_row, j in start_col..end_col]) = vehicles_layer
);

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
