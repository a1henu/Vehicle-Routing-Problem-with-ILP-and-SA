function flag = success(state, model)
    len = length(state);
    if state(1) > model.city || state(len) > model.city
        flag = false; return
    end 
    
    for i = 2:len
        if state(i) > model.city && state(i - 1) > model.city  % not use all vehicles
            flag = false; return
        end
    end

    cap = getCap(state, model);
    for i = 1:model.veh
        if cap(i) > model.cap(i)
            flag = false; return
        end
    end

    flag = true;
end