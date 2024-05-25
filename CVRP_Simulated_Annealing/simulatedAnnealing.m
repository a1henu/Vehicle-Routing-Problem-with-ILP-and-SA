function solution = simulatedAnnealing(model, init_temperature, cutoff_temperature, cooling_rate)
    cur_state = initState(model);
    cur_cost = getCost(cur_state, model);
    temperature = init_temperature;
    flag = 0;
    cost_arr = [];
    k = 0;
    
    while(temperature > cutoff_temperature)
        k = k + 1;
        
        % search
        for i = 1:300
            next_state = getNext(cur_state, model);
            next_cost = getCost(next_state, model);
    
            if accepted(cur_cost, next_cost, temperature)
                cur_state = next_state;
                cur_cost = next_cost;
                flag = 1;
            end
        end
        
        cost_arr = [cost_arr, cur_cost];
        temperature = temperature * cooling_rate;

        disp(['Iteration: ' num2str(k) '; Current Cost: ' num2str(cur_cost) '; Current Temperature: ' num2str(temperature)]);
        
        cur_cap = getCap(cur_state, model);
        for i = 1:model.veh
            disp(['Car ' num2str(i) ': ' num2str(cur_cap(i)) ' / ' num2str(model.cap(i))]);
        end

        figure(1);
        if flag == 1
            plotRoute(cur_state, model);
            flag = 0;
        end

        subplot(1,2,2)
        plot(cost_arr);
    end

    solution = cur_state;
end