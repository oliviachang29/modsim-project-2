function [energy_consumed_from_leave_to_normal_temp,time_house_returns_to_normal_temp] = getEnergyConsumptionAtIdealTemp(hour_leave_house, time_gone, simulation_length, time_range,temperature,energy_consumption)
    global k_to_c hours_to_seconds effective_off_temp ideal_temp freezing_temp;
    
    time_after_return = hour_leave_house + time_gone;
    
    X = [time_range; temperature; energy_consumption]';
    
    % get the cumulative energy consumption when the person leaves the
    % house (so we can subtract it out later)
    energy_consumption_at_leave = X(hour_leave_house*hours_to_seconds,3);
    energy_consumption_at_return = X(time_after_return*hours_to_seconds,3);
    
    % truncate X into only containing values after person returns to house
    X_time_after_return = X((time_after_return*hours_to_seconds):(simulation_length * hours_to_seconds),:);
    
    % loop through the truncated matrix until we find the first time at
    % which the temperature has returned tho the ideal temp
    for j=1:size(X_time_after_return,1)
        if X_time_after_return(j,2) >= ideal_temp
            energy_consumption_when_house_returns_to_normal_temp = X_time_after_return(j,3);
            time_house_returns_to_normal_temp = time_after_return + j;
            break
        end
    end
    
    energy_consumed_from_leave_to_normal_temp = energy_consumption_when_house_returns_to_normal_temp - energy_consumption_at_leave;
end

