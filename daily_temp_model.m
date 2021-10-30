function temp = daily_temp_model(t)
%temp based off the pearson type III distribution curve
%direct copy of this model
%https://mathscinotes.com/wp-content/uploads/2012/12/dailytempvariation.pdf

global hours_to_seconds;
t = mod(t, 24*hours_to_seconds);
t_offset = 13.5*hours_to_seconds;
t = t - t_offset;


gamma = 0.5/hours_to_seconds;

temp_min = 20;  %minimum temp
temp_range = 15;  %maximum temp from range

a = 7.2 * hours_to_seconds;

if norm(t) > a
    t = t + 24*hours_to_seconds;
end
if norm(t) > 24*hours_to_seconds - a
        t = t - 24*hours_to_seconds;
end


temp = temp_min + (temp_range * (exp(-1 * gamma * t) * ((1 + t / a)^(gamma * a))));

temp = 5/9*(temp - 32) + 273; %convert to K
end