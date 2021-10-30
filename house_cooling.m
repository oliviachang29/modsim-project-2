function [time_range, temperature, energy_consumption, on_time] = house_cooling(set_temp_range)
    set_temp_range

    %initial conditions
    set_temp = set_temp_range(1);
    temp_amb = 270;

    heater_state = true;
    t_cur = temp_amb;
    
    % house paramters
    house_width = 10; % m
    house_length = 15; % m
    house_height = 3 % m, approx 10 ft
    
    % surface areas
    A_wall = 2 * house_width * house_height + 2 * house_length * house_height; %m^2, surface area of attic
    A_attic = house_width * house_length; %m^2, surface area of attic
    
    A_floor = house_width * house_length; %m^2, surface area of attic
    A_tot = A_wall + A_attic; % no floor;

     % thermal conducitivty of each material (W / m K)
     % using data from MIT ocw
     gipsum_k = 0.16;
     fiber_batt_k = 0.043;
     concrete_k = 1.75; % apparently this is dense
     stucco_k = 0.69;
     air_k = 0.024; % if needed for convection
     
     % specific heat, J/ kg K
     air_c = 1000;
     concrete_c = 840;
     
     % density of each material (kg/m^3)
     concrete_density = 2400;
     fiber_batt_density = 12;
     gypsum_board_density = 950;
     stucco_density = 1858;
     air_density = 1.2;
     
     % define thickness in inches and convert to meters
     % WALL
     inches_to_meters = (2.54) * (1 / 100);
     wall_gipsum_thickness = 0.5 * inches_to_meters;
     wall_fiber_batt_thickness = 2 * inches_to_meters; 
     wall_concrete_thickness = 8 * inches_to_meters;
     wall_stucco_thickness = 1 * inches_to_meters;
     
     % ATTIC (ROOF)
     attic_fiber_batt_thickness = 16 * inches_to_meters; %m, thickness of attic
     
     % FLOOR
     floor_concrete_thickness = 4 * inches_to_meters; %m, thickness of floor
 
     % Rcond wall 
%      R_wall = 1/A_wall * (wall_concrete_thickness / concrete_k);
     R_wall = 1/A_wall * (wall_gipsum_thickness/gipsum_k + wall_fiber_batt_thickness/fiber_batt_k + wall_concrete_thickness / concrete_k + wall_stucco_thickness/stucco_k); % Km^2 / W
     RSI_value = R_wall / A_tot
     
     R_attic = 1/A_attic * (attic_fiber_batt_thickness/fiber_batt_k);
%      R_floor = 1/A_floor * (floor_concrete_thickness/concrete_k);
   
    % mass = density * volume
    thermal_mass = concrete_density * house_width * house_length * floor_concrete_thickness;
    air_mass = air_density * house_width * house_length * house_height;
    tot_mass = air_mass + thermal_mass;
    c_weighted = concrete_c * (thermal_mass / tot_mass) + air_c * (air_mass / tot_mass);
    H = 15000; % watts, Heater power
    
    U_0 = temperatureToEnergy(t_cur, tot_mass, c_weighted)
    
    %setup for Eulers method

    t_0 = 1;
    t_end = length(set_temp_range);
    dt = 1;
    time_range = t_0:dt:t_end;
    
    %make empty array
    energy = zeros(1, length(time_range));
    energy_consumption = zeros(1, length(time_range));
    on_time = 0;
    
    %populate with initial condition
    energy(1) = U_0;
    energy_consumption(1) = (1*H*dt);
    
    %Eulers method
    for t=2:length(set_temp_range)
        set_temp = set_temp_range(t);
        [dUdt, dHdt] = rate(0, energy(t-1));
        energy(t) = energy(t-1) + (dt * dUdt);
        energy_consumption(t) = energy_consumption(t-1) + (dt * dHdt);
        if dHdt > 0
            on_time = on_time + dt;
        end
    end
   
    %convert to energy
    temperature = energyToTemperature(energy, tot_mass, c_weighted);
    
    %rate function
    function [dUdt, dHdt] = rate(~, U)
        % calculate current temp
        t_cur = energyToTemperature(U, tot_mass, c_weighted);
        
        %find current heater statues
        heater_state = get_heater_state(t_cur, set_temp, heater_state);
        R_tot = 1 / ( (1/R_attic) + (1/R_wall));
%         R_tot = R_wall;
        
        %computute conduction R value
%         R_tot = (d / (A*k));
        
        R_tot = 1 / ( (1/R_attic) + (1/R_wall));
        
        dHdt = (heater_state * H);
        dUdt = dHdt - ((t_cur - temp_amb) / R_tot);
        
    end
end