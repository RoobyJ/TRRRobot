function is_valid = is_point_valid(x, y, z, parameters)
    
    [d_1, theta_2, theta_3] = inverse_kinematic(x, y, z, parameters);
    is_d1_in_range = ~isnan(d_1) && isreal(d_1) && (d_1 >= parameters.d_1_min) && (d_1 <= parameters.d_1_max);
    is_theta2_in_range = ~isnan(theta_2) && isreal(theta_2) && (theta_2 >= parameters.theta_2_min) && (theta_2 <= parameters.theta_2_max);
    is_theta3_in_range = ~isnan(theta_3) && isreal(theta_3) && (theta_3 >= parameters.theta_3_min) && (theta_3 <= parameters.theta_3_max);

    is_valid = is_d1_in_range && is_theta2_in_range && is_theta3_in_range;
    
end
