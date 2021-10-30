function [] = plotDefault(set_temp_range, time_range, temperature, energy_consumption, graph_title, ylim_temp)
    global k_to_c hours_to_seconds effective_off_temp;
    figure(1)
    clf
    title(graph_title)
    xlabel("Time (hours)")
    yyaxis left
    hold on
    plot(time_range / (hours_to_seconds), temperature-k_to_c)
    plot(time_range / (hours_to_seconds), set_temp_range-k_to_c)
    hold off
    ylim(ylim_temp)
    ylabel("House Temperature (C)")
    legend("House Temp", "Set Temp", "Location", "Southeast")
    
    yyaxis right
    plot(time_range / (hours_to_seconds), energy_consumption / 3.6E6)
    ylabel("Cumulative Energy Consuption (kWh)")
    legend("House Temp", "Set Temp", "Energy Consumption")
end

