function J = jacobian(d_1, theta_2, theta_3, parameters)
    J = zeros(3);
        
    c2 = cos(theta_2);
    s2 = sin(theta_2);
    
    c23 = cos(theta_2 + theta_3);
    s23 = sin(theta_2 + theta_3);
    
    J(1,1) = 0;
    J(1,2) = -parameters.a2 * s2 - parameters.a3 * s23;
    J(1,3) = -parameters.a3 * s23;
    
    J(2,1) = 0;
    J(2,2) = parameters.a2 * c2 + parameters.a3 * c23;
    J(2,3) = parameters.a3 * c23;
    
    J(3,1) = 1;
    J(3,2) = 0;
    J(3,3) = 0;
end
