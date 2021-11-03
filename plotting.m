figure()
clf
hold on

plot(sweep_range, energy(1,:)/36000, "Color", [0 0.4470 0.7410], "Linewidth", 1.5)
plot(sweep_range, energy(2,:)/36000, "Color", [0.8500 0.3250 0.0980], "Linewidth", 1.5)
plot(sweep_range, energy(3,:)/36000, "Color", [0.4660 0.6740 0.1880], "Linewidth", 1.5)

title("Parameter Sweep")
xlabel("Hours gone")
ylabel("Energy used")
legend('Heater Off', 'Heater Down', 'Heater On')
hold off

