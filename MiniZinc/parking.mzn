int: n = 5;     % Dimensione della griglia

array[1..n, 1..n] of int: parking =              % Mappa del parcheggio
    array2d(1..n, 1..n,
        [
            1, 1, 1, 1, 1,
            0, 1, 1, 1, 1,
            1, 1, 1, 0, 1,
            1, 1, 1, 1, 1,
            1, 1, 1, 1, 1
        ]);

% Mappa del parcheggio (0=spazio libero, 1=spazio occupato)
int: carX = 4;                            % Coordinate x della macchina
int: carY = 2;                            % Coordinate y della macchina

% Definizione delle variabili decisionali
var int: targetX;                      % Coordinata x del parcheggio target
var int: targetY;                      % Coordinata y del parcheggio target
var int: distance;                     % Distanza minima tra la macchina e il parcheggio (squared Euclidean distance)
var int: numFreeSpaces;                % Numero di spazi di parcheggio liberi nelle vicinanze del parcheggio target

% Vincoli
constraint targetX >= 1 /\ targetX <= n;        % La coordinata x del parcheggio target è all'interno della griglia
constraint targetY >= 1 /\ targetY <= n;        % La coordinata y del parcheggio target è all'interno della griglia
constraint parking[targetX, targetY] = 0;      % Il parcheggio target è uno spazio libero

% Calcolo della distanza euclidea quadrata tra la macchina e il parcheggio target
constraint distance = (targetX - carX)^2 + (targetY - carY)^2;

% Calcolo del numero di spazi di parcheggio liberi nelle vicinanze del parcheggio target
constraint numFreeSpaces = sum(i in targetX-1..targetX+1, j in targetY-1..targetY+1)(
  if i >= 1 /\ i <= n /\ j >= 1 /\ j <= n /\ parking[i, j] = 0 then 1 else 0 endif
);


% Obiettivo: minimizzare la distanza tra la macchina e il parcheggio target
solve ::int_search([distance, -numFreeSpaces], input_order, indomain_min) minimize distance;

% Inserimento del veicolo nel parcheggio target
array[1..n, 1..n] of var 0..1: parked;
constraint forall(i in 1..n, j in 1..n)(
  parked[i,j] = if i = targetX /\ j = targetY then 1 else parking[i,j] endif
);

% Output
output ["Griglia del parcheggio:\n"]++
[if j = n then show(parked[i, j]) ++ "\n" else show(parked[i, j]) ++ " " endif | i in 1..n, j in 1..n] ++
["----------\n"];

output ["Il parcheggio target si trova alle coordinate: (", show(targetX), ", ", show(targetY), ")\n"];

output ["Distanza minima dalla macchina: ", show(sqrt(distance)),"\n"];

output ["Numero di spazi di parcheggio liberi nelle vicinanze: ", show(numFreeSpaces),"\n"];