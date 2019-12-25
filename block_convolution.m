function [out] = block_convolution(x, h, block_length)

Nx = length(x);
Nh = length(h);
L = block_length;

x_new = [x zeros(1,L-mod(Nx,L))];

num = length(x_new)/L;
h_new = [h zeros(1,L-1)];

for k = 1:num
    x_matrix(k,:) = x_new(((k-1)*L+1):k*L);
    if k == 1
        xm_new(k,:) = [zeros(1,Nh-1) x_matrix(k,:)];
    else
        xm_new(k,:) = [x_matrix(k-1,(L-Nh+2):L) x_matrix(k,:)];
    end
    y_matrix(k,:) = ifft(fft(xm_new(k,:)).*fft(h_new));
end

y_matrix_new = (y_matrix(:,Nh:(L+Nh-1)))';
out = y_matrix_new(1:Nx+Nh-1);

end