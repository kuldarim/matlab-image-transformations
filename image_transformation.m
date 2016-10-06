%% Vaizdo posukis koordinaciu pradzios atzvilgiu
clc, clear, close all

I = imread('cameraman.tif');
Idouble = im2double(I);
figure, imshow(I)
   
% posukis pagal laikrodzio rodykle???   
T1 = [ cos(deg2rad(45)) -sin(deg2rad(45))   0;
       sin(deg2rad(45))  cos(deg2rad(45))   0;
            0        0    1 ];

% atspindys   
 T2 = [ -1 0   0;
        0  -1   0;
        0  0    1 ];

% poslinkis        
T3 = [ 1  0  0;
       0  1  0;
       20  -20.7  1 ];
   
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

t1 = maketform('affine',T_komp_.tdata.Tinv);% or t_ = fliptform(T_); 
I_a = imtransform(I1,t1,'bicubic', 'XYScale', 1);%.........,'FillValues',.3);

figure, subplot(1,3,1); imshow(I); title('a) Originalus')
subplot(1,3,2),imshow(Ilast,'XData',xdata1,'YData',ydata1); title('b) Transformuotas')
axis on; axis([-300 580 -280 300])
%axis on; axis([0 660 -160 460])
subplot(1,3,3), imshow(I_a); title('c) Atstatytas')


% palyginti gautus paveiksliukus su psnr