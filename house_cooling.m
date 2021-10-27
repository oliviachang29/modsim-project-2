function [time, TEMP] = house_cooling()

    %set_temp = 293;
    
    %temp_amb = 270;
    %heater_state = true;
    
    
    temp = 293;
    A = 6 * 10^2;
    d = 0.25;
    k = 1.13;
    
    m = A * d * 2300

   
    c = 1000; %for concreat
    H = 1; %Watts
    
    U_0 = c*m*temp
    
    [time, energy] = ode45(@rate, [0, 3*60*60], U_0);
    
    TEMP = U2T(energy, m, c);




    function dUdt = rate(t, U)
        temp = U2T(U, m, c);
        %heater_state = get_heater_state(temp, set_temp, heater_state);
        %R_tot = (d / (A*k));
        dUdt = (H); %- ((temp_amb - temp) / R_tot);
    end
end
