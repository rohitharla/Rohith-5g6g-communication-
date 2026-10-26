clear;
clc;
close all;

serviceAreaKm2 = 5;
radiiKm = [1.0 0.5];
usersPerCell = 30;

hexArea = @(R) (3 * sqrt(3) / 2) .* R.^2;

cellAreaKm2 = hexArea(radiiKm);
cellCount = ceil(serviceAreaKm2 ./ cellAreaKm2);
estimatedUsers = cellCount .* usersPerCell;

capacityTable = table( ...
    radiiKm(:), ...
    cellAreaKm2(:), ...
    cellCount(:), ...
    repmat(usersPerCell, numel(radiiKm), 1), ...
    estimatedUsers(:), ...
    'VariableNames', { ...
        'Radius_km', ...
        'CellArea_km2', ...
        'EstimatedCells', ...
        'UsersPerCell', ...
        'IllustrativeUsers'});

disp(capacityTable);

R = radiiKm(1);

centers = [
     0,                  0;
     1.5*R,  sqrt(3)*R/2;
     1.5*R, -sqrt(3)*R/2;
     0,      sqrt(3)*R;
     0,     -sqrt(3)*R;
    -1.5*R,  sqrt(3)*R/2;
    -1.5*R, -sqrt(3)*R/2
];

theta = (0:6) * pi/3;

figure;
hold on;
axis equal;
grid on;

for k = 1:size(centers, 1)
    x = centers(k, 1) + R*cos(theta);
    y = centers(k, 2) + R*sin(theta);

    plot(x, y, 'k-');

    text(centers(k, 1), centers(k, 2), ...
        sprintf('Cell %d', k), ...
        'HorizontalAlignment', 'center');
end

xlabel('x (km)');
ylabel('y (km)');
title('Idealized Seven-Cell Hexagonal Cluster');

hold off;

mobileX = linspace(-0.2*R, 1.7*R, 300);
mobileY = zeros(size(mobileX));

d1 = hypot(mobileX, mobileY);
d2 = hypot(mobileX - 1.5*R, mobileY);


servingCell = ones(size(mobileX));
servingCell(d2 < d1) = 2;

handoffIndex = find(diff(servingCell) ~= 0, 1, 'first') + 1;

figure;
hold on;
grid on;

plot(mobileX, d1, 'LineWidth', 1.5);
plot(mobileX, d2, 'LineWidth', 1.5);

if ~isempty(handoffIndex)
    xline(mobileX(handoffIndex), '--r', 'Handoff decision');
end

xlabel('Mobile x-position (km)');
ylabel('Distance to cell center (km)');

legend('Cell 1', 'Cell 2', 'Location', 'best');
title('Nearest-Center Handoff Approximation');

hold off;

figure;

stairs(mobileX, servingCell, 'LineWidth', 1.5);
grid on;

xlabel('Mobile x-position (km)');
ylabel('Serving-cell ID');

title('Serving Cell Along the Mobile Path');

if ~isempty(handoffIndex)
    fprintf('Geometric handoff at x = %.3f km\n', ...
        mobileX(handoffIndex));
end

