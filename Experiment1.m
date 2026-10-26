clear;
clc; 
close all;

totalBandwidthHz = 1e6; 
fdmaChannelHz = 200e3;
tdmaSlots = 8;
processingGain = 64;
targetSIRdB = 7;
fdmaUsers = floor(totalBandwidthHz / fdmaChannelHz);
tdmaUsers = tdmaSlots;
targetSIR = 10^(targetSIRdB / 10);
cdmaUsers = floor(1 + processingGain / targetSIR);
fprintf('Illustrative maximum supported users\n');
fprintf('FDMA: %d users\n', fdmaUsers);
fprintf('TDMA: %d users\n', tdmaUsers);
fprintf('CDMA: %d users at a target SIR of %.1f dB\n\n', ...
    cdmaUsers, targetSIRdB);

K = 2:30;
sirLinear = processingGain ./ (K - 1);
sirDb = 10 * log10(sirLinear);

method = ["FDMA"; "TDMA"; "CDMA"];
supportedUsers = [fdmaUsers; tdmaUsers; cdmaUsers];
results = table(method, supportedUsers);
disp(results);

figure;
bar(categorical(method), supportedUsers);
ylabel('Illustrative maximum supported simultaneous users');
title('FDMA, TDMA and CDMA: Capacity Estimate');
grid on;

figure;
plot(K, sirDb, 'o-', 'LineWidth', 1.5);
hold on;
yline(targetSIRdB, '--r', 'Target SIR');
xlabel('Number of simultaneous CDMA users (K)');
ylabel('Estimated SIR (dB)');
title('Estimated CDMA SIR versus Number of Users');
grid on;
hold off;