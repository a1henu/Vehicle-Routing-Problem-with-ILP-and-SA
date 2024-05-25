function cost = getCost(state, model)
    cost = 0;
    for i = 1:length(state) - 1
        cost = cost + model.maps(state(i), state(i + 1));
    end
    cost = cost + model.maps(state(end), state(1));
end

