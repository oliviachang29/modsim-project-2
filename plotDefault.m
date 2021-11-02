function [] = plotDefault(set_temp_range, time_range, temperature, energy_consumption, outside_temp, graph_title, ylim_temp)
    global k_to_c hours_to_seconds effective_off_temp ideal_temp freezing_temp heater_power;
    figure(1)
    clf
    title(graph_title)
    xlabel("Time (hours)")
    yyaxis left
    hold on
    plot(time_range / (hours_to_seconds), temperature-k_to_c, "Color", [0 0.4470 0.7410], "Linewidth", 1.5)
    plot(time_range / (hours_to_seconds), set_temp_range-k_to_c, "Black", "Linewidth", 1.5)
    plot(time_range / (hours_to_seconds), outside_temp-k_to_c, "Color", [0 0.4470 0.7410], "Linewidth", 1.5)
    hold off
    ylim(ylim_temp)
    ylabel("Temperature (C)")
    legend("House Temp", "Set Temp", "Outside Temp", "Location", "SOutheast")
    
    yyaxis right
    plot(time_range / (hours_to_seconds), energy_consumption / 3.6E6, "Color", [0.4660 0.6740 0.1880], "Linewidth", 1.5)
    ylabel("Energy (kWh)")
    legend("House Temp", "Set Temp", "Outside Temp", "Cumulative Energy Consumption")
    
    
    
    ax = gca;
    ax.YAxis(1).Color = [0 0.4470 0.7410];
    ax.YAxis(2).Color = [0.4660 0.6740 0.1880];
end

