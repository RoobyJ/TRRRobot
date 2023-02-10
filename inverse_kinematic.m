function [d_1, theta_2, theta_3] = inverse_kinematic(x, y, z, parameters)
    
    %% Zmienne pomocnicze
    r = sqrt((x - parameters.a1).^2 + y.^2);
    
    if x - parameters.a1 > 0
        gamma = wrapTo2Pi(atan2(x - parameters.a1, abs(y)));
    else
        gamma = atan2(x - parameters.a1, abs(y));
    end
    
    phi = acos((parameters.a2.^2 + r.^2 - parameters.a3.^2) ./ (2 * parameters.a2 .* r));

    %% wyznaczenie katow
    d_1 = z;
    theta_2 = pi/2 - (gamma + phi);
    
    if y < 0
        theta_2 = -theta_2;
    end
    theta_3 = acos((r.^2 - (parameters.a2^2 + parameters.a3^2)) / (2 * parameters.a2 * parameters.a3));
    if y < 0
        theta_3 = -theta_3;
    end
    
end

