function state = initState(model)
    while(1)
        state = randperm(model.city + model.veh - 1);
        if success(state, model)
            break;
        end
    end
end