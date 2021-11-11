function X = findQ (pp, A)
% Find matrix Q for sliding-mode control; inputs are the coefficients of
% the diagonal matrix P and the matrix H_tilde

P = diag(pp);

X = lyap(A', P);