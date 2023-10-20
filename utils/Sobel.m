function [mag,angle] = Sobel(img)
  Kx = [1 2 1 ; 0 0 0 ; -1 -2 -1] ./ 4;
  Ky = Kx';

  dx = conv2(img, Kx, 'same');
  dy = conv2(img, Ky, 'same');

  mag = sqrt(dx.^2 + dy.^2);
  angle = atan2(dy,dx);

  angle = angle - min(reshape(angle, 1, []));
return;