function [] = dispOnTime(on_time_in_seconds)
    global k_to_c hours_to_seconds effective_off_temp;
    disp("Total on time: " + string(on_time_in_seconds / (hours_to_seconds) + "hours"))
end

