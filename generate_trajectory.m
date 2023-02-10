function trajectory = generate_trajectory(p_start, p_end, parameters, trajectory)
    % prosta trajektoria
    trajectory_tmp = struct( ...
        'x', linspace(p_start.x, p_end.x, 100), ...
        'y', linspace(p_start.y, p_end.y, 100), ...
        'z', linspace(p_start.z, p_end.z, 100), ...
        'points_number_in_trajectory', 100, ...
        'knot_number', 1, ...
        'P', p_start ...
    );
            
    if check_trajectory(trajectory_tmp, parameters)
        %% Super - zwracamy trajectory + trajectory_tmp
        trajectory.x = [trajectory.x, trajectory_tmp.x];
        trajectory.y = [trajectory.y, trajectory_tmp.y];
        trajectory.z = [trajectory.z, trajectory_tmp.z];
        trajectory.points_number_in_trajectory = trajectory.points_number_in_trajectory + trajectory_tmp.points_number_in_trajectory;
        trajectory.knot_number = trajectory.knot_number + trajectory_tmp.knot_number;
        trajectory.spline_points = [trajectory.spline_points, p_end];
    else        
        azimuth_start = atan2(p_start.y, p_start.x);
        azimuth_end = atan2(p_end.y, p_end.x);
        azimuth = 0.5 * (azimuth_end + azimuth_start);
        
        sa = sin(azimuth);
        ca = cos(azimuth);
        
        middle_point = [ca; sa; 0];
        vector_normalized = middle_point / norm(middle_point);        
        pc_vec = FindRangeForCentrePoint(vector_normalized, p_start, p_end, parameters);
        
        p_c.x = pc_vec(1);
        p_c.y = pc_vec(2);
        p_c.z = pc_vec(3);
        
        trajectory = generate_trajectory(p_start, p_c, parameters, trajectory);
        trajectory = generate_trajectory(p_c, p_end, parameters, trajectory);
    end
end

%%
function point = FindRangeForCentrePoint(normalized_vector, p_start, p_end, parameters)
    distance_from_origin = 2 * (parameters.a1 + parameters.a2 + parameters.a3);
    maximum_distance = 0;
    minimum_distance = inf;
    closest_point = [];
    furthest_point = [];
    
    for index = 100 : -1 : 0
        p = normalized_vector * distance_from_origin * (index / 100) + [0; 0; 0.5 * (p_end.z + p_start.z)];
        x = p(1);
        y = p(2);
        z = p(3);
        
        is_valid = is_point_valid(x, y, z, parameters);
        
        if is_valid
            distance = norm(p - [p_start.x;p_start.y;p_start.z]) + norm(p - [p_end.x;p_end.y;p_end.z]);
            if distance < minimum_distance
                minimum_distance = distance;
                closest_point = p;
            end
            if distance > maximum_distance
                maximum_distance = distance;
                furthest_point = p;
            end
        end
    end
    
    point = 0.5 * (furthest_point + closest_point);
end
