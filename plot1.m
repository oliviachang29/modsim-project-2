figure(1)
clf
title("House Cooling With Variable Daily Temperature")
xlabel("Time (hours)")
hold on
plot(time_range / (hours_to_seconds), temperature-k_to_c, "Color", [0 0.4470 0.7410], "Linewidth", 1.5)
plot(time_range / (hours_to_seconds), outside_temp-k_to_c, "k:", "Linewidth", 1.5)
hold off
ylim([-8 22])
xlim([min(time_range / (hours_to_seconds)), max(time_range / (hours_to_seconds))])

ylabel("Temperature (C)")
legend("House Temp", "Outside Temp")