function point = select_point_in_cartesian(parameters)

    %% X
    x_min = parameters.a1 - parameters.a3;
    x_max = parameters.a1 + parameters.a2 + parameters.a3;

    while true
        prompt = ['X z zakresu [', num2str(x_min, 4), ', ', num2str(x_max, 4), '] [mm]: '];
        x = input(prompt);
        if ( (x >= x_min) && (x <= x_max) )
            break;
        else
            warning('Wartosc z poza zakresu dopuszczalnego!');
        end
    end

    %% Y
    y_limits = available_y(x, parameters);
    
    if length(y_limits) == 1
        while true
            prompt = ['Y z zakresu [', num2str(y_limits.y_start, 4), ', ', num2str(y_limits.y_end, 4), '] [mm]: '];
            y = input(prompt);
            if (y >= y_limits.y_start) && (y <= y_limits.y_end)
                break;
            else
                warning('Wartosc z poza zakresu dopuszczalnego!');
            end
        end
    else
        while true
            prompt = ['Y z zakresu [', num2str(y_limits(1).y_start, 4), ', ', num2str(y_limits(1).y_end, 4), '] lub [',  num2str(y_limits(2).y_start, 4), ', ', num2str(y_limits(2).y_end, 4), '] [mm]: '];
            y = input(prompt);
            if ((y >= y_limits(1).y_start) && (y <= y_limits(1).y_end)) || ((y >= y_limits(2).y_start) && (y <= y_limits(2).y_end))
                break;
            else
                warning('Wartosc z poza zakresu dopuszczalnego!');
            end
        end
    end

    %% Z
    z_min = parameters.d_1_min;
    z_max = parameters.d_1_max;
    
    while true
        prompt = ['Z z zakresu [', num2str(z_min, 4), ', ', num2str(z_max, 4), '] [mm]: '];
        z = input(prompt);
        if ( (z >= z_min) && (z <= z_max) )
            break;
        else
            warning('Wartosc z poza zakresu dopuszczalnego!');
        end
    end

    point.x = x;
    point.y = y;
    point.z = z;

end

%% Helpers
function y_limits = available_y(x, parameters)
    limit = struct('y_start', 0, 'y_end', 0);
    is_minimum_set = false;
    is_maximum_set = false;
    
    for y = 0 : 1 : (parameters.a1 + parameters.a2 + parameters.a3)
        is_valid = is_point_valid(x, y, 0, parameters);
        
        
        if is_valid
            if is_minimum_set == false
                limit.y_start = y;
                is_minimum_set = true;
            else
                limit.y_end = y;
                is_maximum_set = true;
            end
        end
    end
    
    if is_maximum_set == false
        limit.y_end = limit.y_start;
    end
    
    if limit.y_start == 0
        y_limits = struct('y_start', -limit.y_end, 'y_end', limit.y_end);
    else
        if x > 1167
            oposit_limit = struct('y_start', -limit.y_end, 'y_end', -limit.y_start);
            y_limits = [oposit_limit, limit];
        else
            
            oposit_limit = struct('y_start', -limit.y_end, 'y_end', -limit.y_start);
            y_limits = [oposit_limit, limit];
        end
    end
end