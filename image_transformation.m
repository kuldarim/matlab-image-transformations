clc, clear, close all

I = imread('cameraman.tif');
Idouble = im2double(I);
figure, imshow(I)
   
% posukis 45 laipsniu kampu  
T1 = [ 
    cos(deg2rad(45)) -sin(deg2rad(45))   0;
    sin(deg2rad(45))  cos(deg2rad(45))   0;
         0               0               1; 
];
% atspindys   
 T2 = [ 
    -1 0   0;
    0  -1   0;
    0  0    1 ;
];

% poslinkis        
T3 = [ 
   1  0  0;
   0  1  0;
   20  -20.7  1;
];
   
% matricos nuosekliai sudauginamos
T_komp = T1*T2*T3;

T_komp_1 = maketform('affine', T1);
I1 = imtransform(I, T_komp_1, 'bicubic', 'XYScale', 1);
T_komp_2 = maketform('affine', T2);
I2 = imtransform(I, T_komp_2, 'bicubic', 'XYScale', 1);
T_komp_3 = maketform('affine', T3);
I3 = imtransform(I, T_komp_3, 'bicubic', 'XYScale', 1);
T_komp_ = maketform('affine', T_komp);
Ilast = imtransform(I, T_komp_, 'bicubic', 'XYScale', 1);
[I1, xdata1, ydata1] = imtransform(I, T_komp_, 'bicubic', 'XYScale', 1);

figure, imshow(I1); title('posukis');
figure, imshow(I2); title('atspindys')
figure, imshow(I3); title('poslinkis')
figure, imshow(Ilast); title('a')

%atstatymas
t1 = maketform('affine', T_komp_.tdata.Tinv);
I_a = imtransform(I1, t1, 'bicubic', 'XYScale', 1);

%rezultatai transformacijos
figure, subplot(1,3,1); imshow(I); title('a) Originalus')
subplot(1,3,2),imshow(Ilast,'XData',xdata1,'YData',ydata1); title('b) Transformuotas')
axis on; axis([-300 580 -280 300])
subplot(1,3,3), imshow(I_a); title('c) Atstatytas')

%remelio salinimas
I1thresh = I_a >= 100; 
nonZeroCols = find(any(I1thresh)); %// Change
minCol = min(nonZeroCols); %// Change
maxCol = max(nonZeroCols); %// Change
I_b = I_a(:, minCol : maxCol, :); 
I2thresh = I1thresh(:, minCol : maxCol, :);  % // Note new variable
nonZeroRows = find(any(I2thresh, 2)); %// Change
minRow = min(nonZeroRows); %// Change
maxRow = max(nonZeroRows); %// Change
I_c = I_b(minRow : maxRow, :, :); %// Change

%remelio salinimo vaizdavimas
figure;
subplot(1,3,1), imshow(I_a);title('Figure 1');
subplot(1,3,2), imshow(I_b);title('Figure 2');
subplot(1,3,3), imshow(I_c);title('Figure 3');

%originaliai gautas paveiksliukas
figure;
imshow(I_c);

% psnr palyginimas
[ps1, snr1] = psnr(I, I_c);
s = ssim(I, I_c);
fprintf('\n psnr %0.4f \n', snr1);
fprintf('\n ssim %0.4f \n', s);