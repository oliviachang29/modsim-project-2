function [time_range, temperature, energy_consumption, on_time, outside_temp] = house_cooling(set_temp_range, initial_house_temp)
    global k_to_c hours_to_seconds effective_off_temp ideal_temp freezing_temp heater_power;

    %initial conditions
    set_temp = set_temp_range(1);
    temp_amb = 285;
    heater_state = true; % heater initially on

    if strcmp(initial_house_temp, 'temp_amb')
      disp('current_house_temp defaulting to temp_amb')
      initial_house_temp = temp_amb;
    end

    current_house_temp = initial_house_temp;

    % house paramters
    house_width = 10; % m
    house_length = 15; % m
    house_height = 3; % m, approx 10 ft

    % surface areas
    A_wall = 2 * house_width * house_height + 2 * house_length * house_height; %m^2, surface area of attic
    A_attic = house_width * house_length; %m^2, surface area of attic
    A_floor = house_width * house_length; %m^2, surface area of floor
    A_tot = A_wall + A_attic; % no floor;

    % thermal conducitivty of each material (W / m K)
    % using data from MIT ocw
    gipsum_k = 0.16;
    fiber_batt_k = 0.043;
    concrete_k = 1.75; % apparently this is dense
    stucco_k = 0.69;
    air_k = 0.024; % if needed for convection
    
    R_conv = 0.15;

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
    inches_to_meters = 1 / 39.37;
    wall_gipsum_thickness = 0.5 * inches_to_meters;
    wall_fiber_batt_thickness = 2 * inches_to_meters; 
    wall_concrete_thickness = 8 * inches_to_meters;
    wall_stucco_thickness = 1 * inches_to_meters;
    
    heater_power = 25000; % watts, Heater power

    % ATTIC (ROOF)
    attic_fiber_batt_thickness = 16 * inches_to_meters; %m, thickness of attic

    % FLOOR
    floor_concrete_thickness = 4 * inches_to_meters; %m, thickness of floor

    % resistance values
    %      R_wall = 1/A_wall * (wall_concrete_thickness / concrete_k);

    R_wall = (wall_gipsum_thickness/gipsum_k + wall_fiber_batt_thickness/fiber_batt_k + wall_concrete_thickness / concrete_k + wall_stucco_thickness/stucco_k) + R_conv; % Km^2 / W
    R_wall = R_wall * 11.5 * inches_to_meters / A_wall;  %W/K
    
    R_attic = (attic_fiber_batt_thickness/fiber_batt_k);
    R_attic = R_attic * 16 * inches_to_meters / A_attic;  %W/K
   
    
    % mass = density * volume
    thermal_mass = concrete_density * house_width * house_length * floor_concrete_thickness;
    air_mass = air_density * house_width * house_length * house_height;
    tot_mass = air_mass + thermal_mass;
    c_weighted = concrete_c * (thermal_mass / tot_mass) + air_c * (air_mass / tot_mass);
    
    heater_power = 25000; % watts, Heater power

    
    U_0 = temperatureToEnergy(current_house_temp, tot_mass, c_weighted);
    
    %setup for Eulers method

    t_0 = 1;
    t_end = length(set_temp_range);
    dt = 1;
    time_range = t_0:dt:t_end;
    
    %make empty array
    energy = zeros(1, length(time_range));
    energy_consumption = zeros(1, length(time_range));
    outside_temp = zeros(1, length(time_range));
    on_time = dt;
    
    %populate with initial condition
    energy(1) = U_0;
    energy_consumption(1) = (1*heater_power*dt);
    outside_temp(1) = daily_temp_model(1);
    
    %Eulers method
    for t=2:length(set_temp_range)
        set_temp = set_temp_range(t);
        time = time_range(t);
        %evaluate ODE
        [dUdt, dHdt, temp_amb] = rate(time, energy(t-1));
        
        
        %update stocks
        energy(t) = energy(t-1) + (dt * dUdt);
        energy_consumption(t) = energy_consumption(t-1) + (dt * dHdt);
        if dHdt > 0
            on_time = on_time + dt;
        end
        
        %also save temp_amb for plotting
        outside_temp(t) = temp_amb;
        
    end
   
    %convert to energy
    temperature = energyToTemperature(energy, tot_mass, c_weighted);
    
    %rate function
    function [dUdt, dHdt, temp_amb] = rate(time, U)
        % calculate current temp
        current_house_temp = energyToTemperature(U, tot_mass, c_weighted);
        
        %find current heater statues
        heater_state = get_heater_state(current_house_temp, set_temp, heater_state);

        temp_amb = daily_temp_model(time);  %get temp based on model
        R_tot = 1 / ( (1/R_attic) + (1/R_wall));
        
        dHdt = (heater_state * heater_power);
        dUdt = dHdt - ((current_house_temp - temp_amb) / R_tot);
        
    end
end