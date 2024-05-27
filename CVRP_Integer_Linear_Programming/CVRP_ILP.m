% Example parameters
% data = load("final_project/model.mat");
% n = data.city;
% m = data.veh;
% c = data.maps;

n = 5; % Number of customer locations (excluding the depot)
m = 2; % Number of vehicles
Q = 10; % Vehicle capacity constraint
d = [0, 1, 1, 1, 1, 1]; % Demand of each customer point (excluding depot)
c = [0  15 29 20 21 16;
     15 0  19 15 17 16;
     29 19 0  15 18 16;
     20 15 15 0  22 16;
     21 17 18 22 0  16;
     16 16 16 16 16 0]; % Distance matrix (including depot)

% Call the function
[routes, totalDistance] = solve_CVRP(n, m, Q, d, c);

% Display Results
fprintf('Optimal total distance: %.2f\n', totalDistance);
for k = 1:m
    fprintf('Route for vehicle %d: ', k);
    fprintf('%d ', routes{k});
    fprintf('\n');
end

function [routes, totalDistance] = solve_CVRP(n, m, Q, d, c)
    % SOLVECVRP Solves the Capacitated Vehicle Routing Problem (CVRP)
    %
    % Inputs:
    %   n - Number of customer locations (excluding the depot)
    %   m - Number of vehicles
    %   Q - Vehicle capacity constraint
    %   d - Demand of each customer point (including depot as 0)
    %   c - Distance matrix
    %
    % Outputs:
    %   routes - Cell array containing the routes for each vehicle
    %   totalDistance - Total distance of the optimal solution
    
    % Include depot in the demand array if not already included

    % Decision variables: x(i,j,k) indicates if vehicle k travels from i to j
    x = optimvar('x', n+1, n+1, m, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);

    % Expand the distance matrix to match the dimensions of x
    c_expanded = repmat(c, 1, 1, m);
    
    % Objective function: minimize the total distance
    obj = sum(sum(sum(c_expanded .* x)));
    
    % Constraints
    eq_cons = [];
    ineq_cons = [];
    
    % Constraint 1: Each customer point must be visited exactly once
    for i = 2:n+1
        eq_cons = [eq_cons, sum(sum(x(i, 2:n+1, :))) == 1];
    end
    
    % Constraint 2: Each vehicle must start and end at the depot
    for k = 1:m
        eq_cons = [eq_cons, sum(x(1, 2:n+1, k)) == 1, sum(x(2:n+1, 1, k)) == 1];
    end
    
    % Constraint 3: Vehicle capacity constraint
    for i = 2:n+1
        for k = 1:m
            ineq_cons = [ineq_cons, sum(d(2:n+1) .* x(i, 2:n+1, k)) <= Q];
        end
    end
    
    % Constraint 4: Ensure x_ii^k = 0 for all i and k
    for i = 1:n+1
        for k = 1:m
            eq_cons = [eq_cons, x(i, i, k) == 0];
        end
    end
    
    % Solve the problem
    prob = optimproblem;
    prob.Objective = obj;
    prob.Constraints.Equality = eq_cons;
    prob.Constraints.Inequality = ineq_cons;
    options = optimoptions('intlinprog', 'Display', 'off');
    [sol, fval, exitflag, ~] = solve(prob, 'Options', options);
    
    % Extract routes
    if (exitflag == 0)
        disp('No feasible resolution');
    else
        routes = cell(1, m);
        for k = 1:m
            route = [];
            for i = 2:n+1
                for j = 2:n+1
                    if sol.x(i, j, k) == 1
                        route = [route, i];
                        break;
                    end
                end
            end
            routes{k} = route;
        end
        
        % Total distance
        totalDistance = fval;
    end
end