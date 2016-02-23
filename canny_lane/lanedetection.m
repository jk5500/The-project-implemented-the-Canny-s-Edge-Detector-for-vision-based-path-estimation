%there is lane departure system in matlab
%following information is taken from 
%http://www.mathworks.com/help/vision/examples/lane-departure-warning-system.html
video=vision.VideoFileReader('viplanedeparture.avi');
videoPlay=vision.VideoPlayer;
hAutothreshold = vision.Autothresholder;                
frame=0;

while ~isDone(video)
    videoFrame=step(video);
    if frame>=1
        imwrite(videoFrame,'img.jpg');  
        %cannyimage is function to generate image due to the canny's
        %edge detector
        hAutothreshold = vision.Autothresholder;
        myimage  =(cannyimage('img.jpg')); 
        newimage=step(hAutothreshold,myimage);
        newimage(1:115, :, :)=0;
        
        %matlab
        [H,theta,rho] = hough(newimage,'Theta',-75:2:65);
        P = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
        lines = houghlines(newimage,theta,rho,P,'FillGap',100,'MinLength',1);
        imshow(imread('img.jpg'))
        hold on
        max_len = 0;
        for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',7,'Color','green');
        
        % Plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
          plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
       end
        frame=0;
    else 
        frame=frame+1;
        pause(0.05);
       
    end
end
 