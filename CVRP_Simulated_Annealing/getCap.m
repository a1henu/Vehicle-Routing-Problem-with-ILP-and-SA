function cap = getCap(state, model)
    veh_pos = find(state > model.city);
    from = [0 veh_pos] + 1;
    to = [veh_pos model.city + model.veh] - 1;
    veh_indices = (model.city + 1):(model.city + model.veh);
    indices = [setdiff(veh_indices, state(veh_pos)) state(veh_pos)] - model.city;
    cap = zeros(1, model.veh);
    for i = 1:length(indices)
        cap(indices(i)) = sum(model.demand(state(from(i):to(i))));
    end
end

