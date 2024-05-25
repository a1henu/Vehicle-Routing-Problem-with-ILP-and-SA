function flag = accepted(cur_cost, next_cost, temperature)
    if next_cost < cur_cost
        flag = true; return
    else
        p=exp(-(next_cost - cur_cost) / temperature);
        if rand() <= p 
             flag = true; return
        end
    end
    flag = false;
end

