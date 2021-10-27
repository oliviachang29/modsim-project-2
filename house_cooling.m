function [time, TEMP] = house_cooling()

    set_temp = 293;
    
    temp_amb = 270;
    heater_state = true;
    
    temp = 290;
    A = 6 * 10^2;  %m^2
    d = 0.25; %m
    k = 0.005; %W/m
    
    m = A * d * 2300;  %using 2300 as density
    c = 1000; %for concreat
    H = 15000; %Watts
    
    U_0 = c*m*temp;
    
    
    %[time, energy] = ode45(@rate, [0:(200*60*60)], U_0);
  
    
    %for i=1:10:200*60*60
        
    
    TEMP = energyToTemperature(energy, m, c);
    
    figure(1)
    clf
    plot(time / (60*60), TEMP)


    function [dUdt] = rate(t, U)
        temp = energyToTemperature(U, m, c);
        %heater_state = get_heater_state(temp, set_temp, heater_state);
        if temp > set_temp
            heater_state = false;
        else
            heater_state = true;
        end
        R_tot = (d / (A*k));
        
        [dUdt] = (H*heater_state) - ((temp - temp_amb) / R_tot);
    end
end
