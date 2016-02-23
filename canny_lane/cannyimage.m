function show=cannyimage(im)
x=imread(im);
%convert to gray scale image
%equation y=0.2989*red+0.5870*green+0.114*blue
y=0.2989*x(:,:,1)+0.5870*x(:,:,2)+0.114*x(:,:,3);

[i,j]=size(y);
y1=y(1:i,1:j);
%define 5*5 kernel size gaussian filter with sigma=1.4
g=fspecial('gaussian',[5,5],1.4);
%smooth out image
z=imfilter(y1,g);
%taking gradient
[g1,g2]=gradient(g);
G_x=conv2(z,g1,'same');
G_y=conv2(z,g2,'same');
%take magnitude
new=sqrt(G_x.^2+G_y.^2);
%take angle
angle = atan2(G_y, G_x);
angle = angle*180/pi;
[m,n]=size(y1);
%Noting we have troubled at G_x=0; description is available in paper
angle_grad = zeros(m, n);
for i = 1  : m
    for j = 1 : n

        if ((angle(i, j) > 0 ) && (angle(i, j) < 22.5) || (angle(i, j) > 157.5) && (angle(i, j) < -157.5))
            angle_grad(i, j) = 0;
        end
        
        if ((angle(i, j) > 22.5) && (angle(i, j) < 67.5) || (angle(i, j) < -112.5) && (angle(i, j) > -157.5))
            angle_grad(i, j) = 45;
        end
        
        if ((angle(i, j) > 67.5 && angle(i, j) < 112.5) || (angle(i, j) < -67.5 && angle(i, j) > 112.5))
            angle_grad(i, j) = 90;
        end
        
        if ((angle(i, j) > 112.5 && angle(i, j) <= 157.5) || (angle(i, j) < -22.5 && angle(i, j) > -67.5))
            angle_grad(i, j) = 135;
        end
    end
end
new_im=zeros(size(new));

for k=2:i-1
    for l=2:j-1
        if (angle_grad(i, j) == 0)
        if new(k,l) <new(k-1,l-1) || new(k,l)<new(k+1,l+1)
            new(k,l)=0;
        else
            new_im(k,l)=new(k,l);
        end
        end
        if (angle_grad(i, j) == 45)
        if new(k,l) <new(k-1,l-1) || new(k,l)<new(k+1,l+1)
            new(k,l)=0;
        else
            new_im(k,l)=new(k,l);
        end
        end
        if (angle_grad(i, j) == 90)
        if new(k,l) <new(k-1,l-1) || new(k,l)<new(k+1,l+1)
            new(k,l)=0;
        else
            new_im(k,l)=new(k,l);
        end
        end
        if (angle_grad(i, j) == 135)
        if new(k,l) <new(k-1,l-1) || new(k,l)<new(k+1,l+1)
            new(k,l)=0;
        else
            new_im(k,l)=new(k,l);
        end
        end
        
        
    end
end

%hysteris thresholding selecting low and high threshold value 

low_factor=0.1;
high_factor=0.2;
%canny suggested to choose high_threshold approx 2*low_threshold
low_threshold = low_factor * max(max(new_im));
high_threshold = high_factor * max(max(new_im));

final_im = zeros(m, n);
for i = 1  : m
    for j = 1 : n
        if (new_im(i, j) < low_threshold)
            final_im(i, j) = 0;
        elseif (new_im(i, j) > high_threshold)
            final_im(i, j) = 1;
        else
            if ((new_im(i + 1, j) > high_threshold) || ...
                 (new_im(i - 1, j) > high_threshold) || ...
                 (new_im(i, j + 1) > high_threshold) || ...
                 (new_im(i, j - 1) > high_threshold))
               
                final_im(i, j) = 1;
            end
        end
    end
end
show = final_im;
%show final image due to canny edge detector
imshow(show);

end
