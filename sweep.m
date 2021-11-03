
global hours_to_seconds effective_off_temp ideal_temp down_temp;
house_temp_0 = 22 + 273;

%make matrix to save meaningfull data
energy = zeros(3, length(sweep_range));


for i = 1:length(sweep_range)
    
    away_from_home = sweep_range(i);
    
    temp_range(1:1+away_from_home*hours_to_seconds/dt) = effective_off_temp;
    temp_range(1+away_from_home*hours_to_seconds/dt:end) = ideal_temp;
    evaluation_matrix = [time_range ; temp_range];
    [~, energy_consumption, ~, ~] = house_simulation(evaluation_matrix, house_temp_0);
    energy(1,i) = max(energy_consumption);
    
    
    temp_range(1:1+away_from_home*hours_to_seconds/dt) = down_temp;
    temp_range(1+away_from_home*hours_to_seconds/dt:end) = ideal_temp;
    evaluation_matrix = [time_range ; temp_range];
    [~, energy_consumption, ~, ~] = house_simulation(evaluation_matrix, house_temp_0);
    energy(2,i) = max(energy_consumption);
    
    
    temp_range(:) = ideal_temp;
    evaluation_matrix = [time_range ; temp_range];
    [~, energy_consumption, ~, ~] = house_simulation(evaluation_matrix, house_temp_0);
    energy(3,i) = max(energy_consumption);

end
    

figure()
clf
hold on

plot(sweep_range, energy(1,:)/3.6E6, "Color", [0 0.4470 0.7410], "Linewidth", 1.5)
plot(sweep_range, energy(2,:)/3.6E6, "Color", [0.8500 0.3250 0.0980], "Linewidth", 1.5)
plot(sweep_range, energy(3,:)/3.6E6, "Color", [0.4660 0.6740 0.1880], "Linewidth", 1.5)

title("Parameter Sweep Results")
xlabel("Time Away from Home (hours)")
ylabel("Energy used (kWh)")
legend('Heater Off', 'Heater Down', 'Heater On', "Location", "Southwest")
hold off