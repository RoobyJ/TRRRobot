function [trajectory, bezier_points] = generate_bezier_curves(spline_points)
    spline_points_number = length(spline_points);
    
    if (spline_points_number == 2)
        t = linspace(0, 1, 100);
            
        x_position = bezier_curve_position(spline_points(1).x, spline_points(1).x, spline_points(2).x, spline_points(2).x, t);
        y_position = bezier_curve_position(spline_points(1).y, spline_points(1).y, spline_points(2).y, spline_points(2).y, t);
        z_position = bezier_curve_position(spline_points(1).z, spline_points(1).z, spline_points(2).z, spline_points(2).z, t);

        x_velocity = bezier_curve_velocity(spline_points(1).x, spline_points(1).x, spline_points(2).x, spline_points(2).x, t);
        y_velocity = bezier_curve_velocity(spline_points(1).y, spline_points(1).y, spline_points(2).y, spline_points(2).y, t);
        z_velocity = bezier_curve_velocity(spline_points(1).z, spline_points(1).z, spline_points(2).z, spline_points(2).z, t);
        
        bezier_points = spline_points;
    else
        parts_number = spline_points_number - 1;
        
        A = zeros(2 * (parts_number));
        Bx = zeros(2 * (parts_number), 1);
        By = zeros(2 * (parts_number), 1);
        Bz = zeros(2 * (parts_number), 1);
        
        velocity_and_acceleration_conditions = [0, 1, 1, 0; 1, -2, 2, -1];
        
        A(1, 1) = 1;
        Bx(1) = spline_points(1).x;
        By(1) = spline_points(1).y;
        Bz(1) = spline_points(1).z;
        for index = 1:parts_number-1
            A((index-1) * 2 + 2 : (index-1) * 2 + 3, (index-1) * 2 + 1 : (index-1) * 2 + 4) = velocity_and_acceleration_conditions;
            Bx((index-1) * 2 + 2 : (index-1) * 2 + 3) = [2 * spline_points(index + 1).x; 0];
            By((index-1) * 2 + 2 : (index-1) * 2 + 3) = [2 * spline_points(index + 1).y; 0];
            Bz((index-1) * 2 + 2 : (index-1) * 2 + 3) = [2 * spline_points(index + 1).z; 0];
        end
        A(end,end) = 1;
        Bx(end) = spline_points(end).x;
        By(end) = spline_points(end).y;
        Bz(end) = spline_points(end).z;
        
        %% Wyznaczenie punktow
        X = inv(A) * Bx;
        Y = inv(A) * By;
        Z = inv(A) * Bz;
        
        bezier_points.x = X;
        bezier_points.y = Y;
        bezier_points.z = Z;
                
        %% Generuj trajektorię
        x_position = [];
        y_position = [];
        z_position = [];
        
        x_velocity = [];
        y_velocity = [];
        z_velocity = [];
                
        t = [];
        
        for index = 1:parts_number
            t_tmp = linspace(0, 1, 100);
            t = [t, linspace(index - 1, index, 100)];
            
            x_position = [x_position, bezier_curve_position(spline_points(index).x, X((index - 1) * 2 + 1), X((index - 1) * 2 + 2), spline_points(index + 1).x, t_tmp)];
            y_position = [y_position, bezier_curve_position(spline_points(index).y, Y((index - 1) * 2 + 1), Y((index - 1) * 2 + 2), spline_points(index + 1).y, t_tmp)];
            z_position = [z_position, bezier_curve_position(spline_points(index).z, Z((index - 1) * 2 + 1), Z((index - 1) * 2 + 2), spline_points(index + 1).z, t_tmp)];
            
            x_velocity = [x_velocity, bezier_curve_velocity(spline_points(index).x, X((index - 1) * 2 + 1), X((index - 1) * 2 + 2), spline_points(index + 1).x, t_tmp)];
            y_velocity = [y_velocity, bezier_curve_velocity(spline_points(index).y, Y((index - 1) * 2 + 1), Y((index - 1) * 2 + 2), spline_points(index + 1).y, t_tmp)];
            z_velocity = [z_velocity, bezier_curve_velocity(spline_points(index).z, Z((index - 1) * 2 + 1), Z((index - 1) * 2 + 2), spline_points(index + 1).z, t_tmp)];
        end 
    end
    
    %% Droga
    s = [0, cumsum(sqrt(x_velocity(2:end).^2 + y_velocity(2:end).^2 + z_velocity(2:end).^2) .* diff(t))];
        
    %%
    [t, ia, ~] = unique(t);

    trajectory = struct( ...
        't', t, ...
        ...
        'x', x_position(ia), ...
        'y', y_position(ia), ...
        'z', z_position(ia), ...
        ...
        'sx', cumsum(abs(x_velocity(ia)) .* [0, diff(t)]), ...
        'sy', cumsum(abs(y_velocity(ia)) .* [0, diff(t)]), ...
        'sz', cumsum(abs(z_velocity(ia)) .* [0, diff(t)]), ...
        ...
        'droga', s(ia), ...
        ...
        'vx', x_velocity(ia), ...
        'vy', y_velocity(ia), ...
        'vz', z_velocity(ia));
end

function value = a(A, B, C, D)
    value = D - 3*C + 3*B - A;
end

function value = b(A, B, C)
    value = 3*A - 6*B + 3*C;
end

function value = c(A, B)
    value = 3*B - 3*A;
end

function value = d(A)
    value = A;
end

function position = bezier_curve_position(A, B, C, D, t)
    position = a(A, B, C, D) * t.^3 + b(A, B, C) * t.^2 + c(A, B) * t + d(A);
end

function velocity = bezier_curve_velocity(A, B, C, D, t)
    velocity = 3 * a(A, B, C, D) * t.^2 + 2 * b(A, B, C) * t + c(A, B);
end