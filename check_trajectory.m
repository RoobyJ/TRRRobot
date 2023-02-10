function is_valid = check_trajectory(trajectory, parameters)
    for index = 1:trajectory.points_number_in_trajectory
        if ~is_point_valid(trajectory.x(index), trajectory.y(index), trajectory.z(index), parameters)
            is_valid = false;
            return;
        end
    end
    is_valid = true;
end
