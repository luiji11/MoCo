function P = createDirections(mu, kappa, x, R)
% Note all inputs and outputs in radians
P   = R .*  exp(kappa*cos(x - mu'))  / (2*pi*besseli(0, kappa));


end