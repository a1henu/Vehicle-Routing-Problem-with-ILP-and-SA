function model = initModel(map_size, city, veh, offset)
    % This function initializes a model with random positions for cities and vehicles.

    % Initialize the model
    model = struct('city', city, 'veh', veh);

     % ranges of x and y
    xmin = 0; xmax = map_size;
    ymin = 0; ymax = map_size;

    maps = zeros(city + veh, city + veh);

    % the center of the map
    x0 = floor(map_size / 2); y0 = floor(map_size / 2);
    model.x0 = x0; model.y0 = y0;

    % for showing multiple vehicles
    x1 = randi([xmin, floor(xmax / 2 - offset)], 1, floor(city / 4));
    x2 = randi([xmin, floor(xmax / 2 - offset)], 1, floor(city / 4));
    x3 = randi([floor(xmax / 2 + offset), xmax], 1, floor(city / 4));
    x4 = randi([floor(xmax / 2 + offset), xmax], 1, floor(city / 4));

    y1 = randi([ymin, floor(ymax / 2 - offset)], 1, floor(city / 4));
    y2 = randi([ymin, floor(ymax / 2 - offset)], 1, floor(city / 4));
    y3 = randi([floor(ymax / 2 + offset), ymax], 1, floor(city / 4));
    y4 = randi([floor(ymax / 2 + offset), ymax], 1, floor(city / 4));

    x = [x1, x2, x3, x4, repmat(x0, 1, veh)];
    y = [y1, y3, y2, y4, repmat(y0, 1, veh)];

    model.x = x; model.y = y;

    n = city + veh;

    for i = 1:n
        for j = i:n
            maps(j, i) = sqrt((x(i) - x(j))^2 + (y(i) - y(j))^2);
            maps(i, j) = maps(j, i);
        end
    end

    model.maps = maps;
end

% Usage:
% map_size = 100; city = 50; veh = 4; offset = 30;
% model = initModel(map_size, city, veh, offset);