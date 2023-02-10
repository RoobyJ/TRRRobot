function [vx, vy, vz, v] = calculate_cartesian_speed_from_joints(trajectory_joint, parameters)
        
    s2 = sin(trajectory_joint.theta_2);
    c2 = cos(trajectory_joint.theta_2);
    
    s23 = sin(trajectory_joint.theta_2 + trajectory_joint.theta_3);
    c23 = cos(trajectory_joint.theta_2 + trajectory_joint.theta_3);
    
    vx = -trajectory_joint.omega_2 .* (parameters.a2 .* s2 + parameters.a3 .* s23) - trajectory_joint.omega_3 .* parameters.a3 .* s23;
    vy = trajectory_joint.omega_2 .* (parameters.a2 .* c2 + parameters.a3 .* c23) + trajectory_joint.omega_3 .* parameters.a3 .* c23;
    vz = trajectory_joint.omega_1;
    
    v = sqrt(vx.^2 + vy.^2 + vz.^2);

end

