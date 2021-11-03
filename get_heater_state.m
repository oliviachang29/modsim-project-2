function heater_state = get_heater_state(temp, set_temp, heater_state)
    global k_to_c hours_to_seconds effective_off_temp;
    
    buffer = 0.25;  %in degrees C, reflects how closly the thermostat matches the set_temp
    
    %thermostat logic
    %if heater is off and house is colder than minimum tolerance...
    if temp < (set_temp - buffer)
        %turn heater on
        heater_state = true;
    end

    %if heater is heating, continue heating untill maximum tolerance is reached
    if temp < (set_temp + buffer) && heater_state == true
        heater_state = true;
        %if temperature is at maximum tolerance
    elseif temp > (set_temp - buffer)
        %turn off the heater
        heater_state = false;
    end
end

 