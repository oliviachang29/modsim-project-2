hour_leave_house = 9; % time you leave the house in hours (military) 
simulation_length = 24;
simulation_length = 48; % how long to run simulation for

% sweep time_gone
sweep_range = [0:1:23];

sweep_results = zeros(size(sweep_range, 2), 4);

for i = 1:size(sweep_range, 2)
    time_gone = sweep_range(i);
    time_until_end_of_simulation = simulation_length - time_gone - hour_leave_house;
    
    turn_off_range = [(ideal_temp)*ones(1,hour_leave_house*hours_to_seconds), (effective_off_temp)*ones(1,time_gone*hours_to_seconds), (ideal_temp)*ones(1,time_until_end_of_simulation*hours_to_seconds)];
    turn_down_range = [(ideal_temp)*ones(1,hour_leave_house*hours_to_seconds), (down_temp)*ones(1,time_gone*hours_to_seconds), (ideal_temp)*ones(1,time_until_end_of_simulation*hours_to_seconds)];     
    
    [turn_off_time_range, turn_off_temperature, turn_off_energy_consumption, turn_off_on_time, turn_off_outside_temp] = house_cooling(turn_off_range, ideal_temp);
    [turn_down_time_range, turn_down_temperature, turn_down_energy_consumption, turn_down_on_time, turn_down_outside_temp] = house_cooling(turn_down_range, ideal_temp);
    
    [turn_off_energy_consumed_from_leave_to_normal_temp,turn_off_time_house_returns_to_normal_temp] = getEnergyConsumptionAtIdealTemp(hour_leave_house, time_gone, simulation_length, turn_off_time_range, turn_off_temperature, turn_off_energy_consumption);
    [turn_down_energy_consumed_from_leave_to_normal_temp,turn_down_time_house_returns_to_normal_temp] = getEnergyConsumptionAtIdealTemp(hour_leave_house, time_gone, simulation_length, turn_down_time_range, turn_down_temperature, turn_down_energy_consumption);
    
    sweep_results(i, 1) = time_gone;
    sweep_results(i, 2) = turn_off_energy_consumed_from_leave_to_normal_temp;
    sweep_results(i, 3) = turn_down_energy_consumed_from_leave_to_normal_temp;
end
keep_on_range = [(ideal_temp)*ones(1,simulation_length*hours_to_seconds)];
[time_range, temperature, energy_consumption, turn_off_on_time, outside_temp] = house_cooling(keep_on_range, ideal_temp);
for i = 1:size(sweep_range, 2)
    time_gone = sweep_range(i);
    time_after_return = hour_leave_house + time_gone;
    [energy_consumed_from_leave_to_normal_temp,time_house_returns_to_normal_temp] = getEnergyConsumptionAtIdealTemp(hour_leave_house, time_gone, simulation_length, time_range, temperature, energy_consumption);
    sweep_results(i, 4) = energy_consumed_from_leave_to_normal_temp;
end
clf; hold on;
title('Time gone from house vs. total energy consumed')
plot(sweep_results(:,1), sweep_results(:,2) / 3.6E6, "Color", [0 0.4470 0.7410], "Linewidth", 1.5) % turn off
plot(sweep_results(:,1), sweep_results(:,3) / 3.6E6, "Color", [0.8500 0.3250 0.0980], "Linewidth", 1.5) % turn down to lower temp
plot(sweep_results(:,1), sweep_results(:,4) / 3.6E6, "Color", [0.4660 0.6740 0.1880], "Linewidth", 1.5) % keep on
hold off;
legend("Heater Off", "Heater Down", "Heater On", "Location", "Southeast")
xlabel('Time gone from house (hours)')
ylabel("Total energy consumed (kwh)")