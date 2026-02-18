ImagePath='TEP.jpg'; %Give Path of your file here
Img=imread(ImagePath);
 
Img=im2bw(Img(:,:,3));  
Rmin=70;
Rmax=100;  
[centersDark, radiiDark] = imfindcircles(Img, [Rmin Rmax], ...
                                        'ObjectPolarity','bright','sensitivity',0.90);
imagesc(Img);
hold on
viscircles(centersDark, radiiDark,'LineStyle','--');
hold off
%path=uigetfile