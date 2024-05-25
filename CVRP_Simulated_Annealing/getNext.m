function next_state = getNext(cur_state, model)
    mode = randi([1 3]);
    while(1)
        [i1, i2] = randomTwoCities(cur_state);
        switch mode
            case 1
                next_state = Swap(cur_state, i1, i2);
            case 2
                next_state = Reversion(cur_state, i1, i2);
            case 3
                next_state = Insertion(cur_state, i1, i2);
        end
        
        if (success(next_state, model)) 
            break; 
        end
    end
end

function [i1, i2] = randomTwoCities(route)
    n = numel(route);
    i = randsample(n,2);
    i1 = i(1);
    i2 = i(2);
end

function newRoute = Swap(route, i1, i2)
    newRoute = route;
    newRoute([i1 i2]) = route([i2 i1]);
end

function newRoute = Reversion(route, i1, i2)
    newRoute = route;
    newRoute(min(i1,i2):max(i1,i2)) = route(max(i1,i2):-1:min(i1,i2));
end

function newRoute = Insertion(route, i1, i2)
    n = numel(route);
    if i1 < i2
        newRoute = [route(1:i1-1) route(i1+1:i2) route(i1) route(i2+1:n)];
    else
        newRoute = [route(1:i2) route(i1) route(i2+1:i1-1) route(i1+1:n)];
    end
end