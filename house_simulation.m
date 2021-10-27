function [T, M] = house_simulation()
    % set parameters (at some point move this into function arguments)
    time_leave = 9; % time you leave the house in hours (military)
    time_return = 17; % time you come back
    
    % calculated values
    time_gone = time_return - time_leave; % hours
    thermal_mass = 0; % TODO: set value
    specific_heat_house = 0; % TODO: set value
    environment_temp = get_environment_temp(time_leave); % TODO: create function to get 
    
    
    % initial stock values
    U_0 = temperatureToEnergy(initial_house_temp, thermal_mass, specific_heat_house);
        
    t_0 = 0;
    t_end = time_gone * 60 * 60; % seconds
    
    [T, U] = ode45(@rate_func, [t_0, t_end], U_0);
    M = % something;
    
    function res = rate_func(t, U_i)
        % dUdt = conduction flow out = - dQ/dt
        % conduction flow out: -kA * delta T / d
        % convection flow out: - h A * delta T
        
        current_environment_temp = get_environment_temp(t);
        current_temp = energyToTemperature(U_i, thermal_mass, specific_heat_house);
        delta_T = current_temp - current_environment_temp; % T(coffee) - T(environment);
        dQdt = delta_T / R_thermal;
                
        dUdt = -dQdt;
        res = [dUdt];
    end
end

