int: n = 5;     % Grid size

array[1..n, 1..n] of int: parking =              % Parking map
    array2d(1..n, 1..n,
        [
            1, 1, 1, 1, 1,
            0, 1, 1, 1, 1,
            1, 1, 1, 0, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1
        ]);

% Parking map (0=free space, 1=occupied space)
int: carX = 4;                            
int: carY = 2;                            

var int: targetX;                     % Target parking lot x coordinate
var int: targetY;                      % Target parking lot y coordinate
var int: distance;                     % Minimum distance between the car and the parking lot (squared Euclidean distance).
var int: numFreeSpaces;                % Number of free parking spaces in the vicinity of the target parking lot


constraint targetX >= 1 /\ targetX <= n;        % The x-coordinate of the target parking lot is within the grid.
constraint targetY >= 1 /\ targetY <= n;        % % The y-coordinate of the target parking lot is within the grid.
constraint parking[targetX, targetY] = 0;      % Target parking is free space

% Calculation of the squared Euclidean distance between the car and the target parking lot.
constraint distance = (targetX - carX)^2 + (targetY - carY)^2;

% Calculation of the number of free parking spaces in the vicinity of the target parking lot
constraint numFreeSpaces = sum(i in targetX-1..targetX+1, j in targetY-1..targetY+1)(
  if i >= 1 /\ i <= n /\ j >= 1 /\ j <= n /\ parking[i, j] = 0 then 1 else 0 endif
);


% Objective: to minimize the distance between the car and the target parking lot.
solve ::int_search([distance, -numFreeSpaces], input_order, indomain_min) minimize distance;

% Entering the vehicle in the target parking lot.
array[1..n, 1..n] of var 0..1: parked;
constraint forall(i in 1..n, j in 1..n)(
  parked[i,j] = if i = targetX /\ j = targetY then 1 else parking[i,j] endif
);


output ["Parking grid:\n"]++
[if j = n then show(parked[i, j]) ++ "\n" else show(parked[i, j]) ++ " " endif | i in 1..n, j in 1..n] ++
["----------\n"];

output ["The target parking lot is located at the coordinates: (", show(targetX), ", ", show(targetY), ")\n"];

output ["Minimum distance from the car: ", show(sqrt(distance)),"\n"];

output ["Number of free parking spaces nearby: ", show(numFreeSpaces),"\n"];