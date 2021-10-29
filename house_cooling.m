function [time_range, temperature, energy_consumption, on_time] = house_cooling(set_temp_range)

    %initial conditions
    set_temp = set_temp_range(1);
    temp_amb = 285;
    heater_state = true;
    t_cur = temp_amb;
    
    %hosue paramters
    A = 6 * 5^2;  %m^2
    d = 0.2; %m
    k = 1.3; %W/m
    m = A * d * 2300;  %using 2300 as density
   
    c = 1000; %for concreat
    H = 100000; %Watts
    
    U_0 = c*m*t_cur;
    
    %ODE45 did not work...
    %[time, energy] = ode45(@rate, [0:0.01:(6*60*60)], U_0);
    
    %setup for Eulers method
    start_time = 1;
    end_time = length(set_temp_range);
    dt = 1;
    time_range = start_time:dt:end_time;
    
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
    temperature = energyToTemperature(energy, m, c);
    

    
    %rate function
    function [dUdt, dHdt] = rate(~, U)
        %calculate curret temp
        t_cur = energyToTemperature(U, m, c);
        
        %find curret heater statues
        heater_state = get_heater_state(t_cur, set_temp, heater_state);

        %computute conduction R value
        R_tot = (d / (A*k));
        
        %put it all together
        
        dHdt = (heater_state * H);
        dUdt = dHdt - ((t_cur - temp_amb) / R_tot);
        
        
    end
end
