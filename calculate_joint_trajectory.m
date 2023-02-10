function trajectory_joint = calculate_joint_trajectory(trajectory_cartesian, parameters)

    d_1_inverse = zeros(size(trajectory_cartesian.t));
    theta_2_inverse = zeros(size(trajectory_cartesian.t));
    theta_3_inverse = zeros(size(trajectory_cartesian.t));

    d_1p_inverse = zeros(size(trajectory_cartesian.t));
    theta_2p_inverse = zeros(size(trajectory_cartesian.t));
    theta_3p_inverse = zeros(size(trajectory_cartesian.t));

    for index = 1:length(trajectory_cartesian.t)        
        x = trajectory_cartesian.x(index);
        y = trajectory_cartesian.y(index);
        z = trajectory_cartesian.z(index);
        
        vx = trajectory_cartesian.vx(index);
        vy = trajectory_cartesian.vy(index);
        vz = trajectory_cartesian.vz(index);
        
        a1 = parameters.a1;
        a2 = parameters.a2;
        a3 = parameters.a3;
        
        % Polozenie
        [d_1_inverse(index), theta_2_inverse(index), theta_3_inverse(index)] = inverse_kinematic(x, y, z, parameters);
                
        % Predkosc
        d_1p_inverse(index) = vz;
        
        gamma_prim = (vx / y + ((a1 - x) * vy) / y^2) / ((a1 - x)^2 / y^2 + 1);
        phi_prim = -((2*y*vy - 2*(a1 - x)*vx)/(2*a2*(y^2 + (a1 - x)^2)^(1/2)) - ((2*y*vy - 2*(a1 - x)*vx)*(y^2 + (a1 - x)^2 + a2^2 - a3^2))/(4*a2*(y^2 + (a1 - x)^2)^(3/2)))/(1 - (y^2 + (a1 - x)^2 + a2^2 - a3^2)^2/(4*a2^2*(y^2 + (a1 - x)^2)))^(1/2);
        theta_2p_inverse(index) = -(gamma_prim + phi_prim);
        
        theta_3p_inverse(index) = (2 * (x - a1) * vx + 2 * y * vy) * (-1 / sqrt((a2^2 + (x - a1)^2 + y^2 - a3^2) / (2 * a2 * sqrt((x -a1)^2 + y^2)))) / (2 * a2 * a3);
        cumsum (theta_3p_inverse(index));   
    end

    %%
    trajectory_joint = struct( ...
        't', trajectory_cartesian.t, ...
        ...
        'd_1', d_1_inverse, ...
        'theta_2', theta_2_inverse, ...
        'theta_3', theta_3_inverse, ...
        ...
        'd_1_velocity', d_1p_inverse, ...
        'theta_2_velocity', theta_2p_inverse, ...
        'theta_3_velocity', theta_3p_inverse);
end

