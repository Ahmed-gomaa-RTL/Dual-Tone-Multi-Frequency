% Clear the workspace and the command window
clear;
clc;

% Get input from the user: A string of numbers with spaces between each digit
str_number = input("Please Enter The Number (Put Space Between Each Digit): ", 's');

% Convert the input string to numeric format
number = str2num(str_number); %#ok<ST2NM>

% Prompt user to input the time increment in seconds
the_time_increment = input("Please Enter The Time Increment (second): ");

% Prompt user to input the duration of the signal
nd = input("Please Enter The Parameter Duration (nd): ");

% Prompt user to input the duration of the pause
np = input("Please Enter The Parameter Duration of Pause (np): ");

% Calculate total duration and pause time based on the increments
Td = the_time_increment * nd;
Tp = the_time_increment * np;

% Set the sampling frequency
f = 1 / the_time_increment;

% Loop through each digit in the input number
for i = 1:length(number)
    
    % Create a time vector for the signal duration
    t = linspace(0, Td, 850);
    
    % Define the dual-tone frequencies based on the input digit
    switch number(i)
        case 1
            f1 = 697; f2 = 1209;
        case 2
            f1 = 697; f2 = 1336;
        case 3
            f1 = 697; f2 = 1477;
        case 4
            f1 = 770; f2 = 1209;
        case 5
            f1 = 770; f2 = 1336;
        case 6
            f1 = 770; f2 = 1477;
        case 7
            f1 = 852; f2 = 1209;
        case 8
            f1 = 852; f2 = 1336;
        case 9
            f1 = 852; f2 = 1477;
        case 10
            f1 = 941; f2 = 1209;
        case 0
            f1 = 941; f2 = 1336;
        case 11
            f1 = 941; f2 = 1477;
        otherwise
            disp("Error! Invalid Number Entered.");
            continue;
    end
    
    % Generate the signal as a sum of two sine waves with frequencies f1 and f2
    x_t = sin(2 * pi * f1 * t) + sin(2 * pi * f2 * t);
    
    % Perform Fourier Transform to get frequency components
    x_t_transform = fft(x_t) * the_time_increment;
    x_t_transform = fftshift(x_t_transform);
    
    % Generate frequency vector for plotting
    n = length(t);
    if rem(n, 2)
        fs = f / n * (-(n - 1) / 2 : (n - 1) / 2);
    else
        fs = f / n * (-(n / 2) : (n / 2 - 1));
    end
    
    % Plot the time-domain signal
    figure(1);
    plot(t + (i - 1) * (Td + Tp) * ones(1, length(t)), x_t);
    xlabel("Time (s)");
    ylabel("Signal Amplitude");
    title("Signal of Each Number");
    hold on;
    
    % Plot the frequency-domain magnitude and phase
    figure(i + 1);
    
    % Subplot for magnitude spectrum
    subplot(2, 1, 1);
    plot(fs, abs(x_t_transform));
    xlabel("Frequency (Hz)");
    ylabel("Magnitude");
    title(['Magnitude Spectrum of Number ' num2str(number(i))]);
    
    % Subplot for phase spectrum
    subplot(2, 1, 2);
    plot(fs, angle(x_t_transform));
    xlabel("Frequency (Hz)");
    ylabel("Phase (radians)");
    title(['Phase Spectrum of Number ' num2str(number(i))]);
    
    % Play the sound of the generated tone
    sound(x_t, f);
    
    % Pause to allow sound to play before the next iteration
    pause(1);
end
