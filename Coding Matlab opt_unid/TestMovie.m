image_names = {'13.bmp','14.bmp','15.bmp','16.bmp'};

v = VideoWriter('TestVideo13-16.avi','Uncompressed AVI');
v.FrameRate = 1;
for i = 1 : length(image_names)
  A = imread(image_names{i});
  open(v)
  writeVideo(v, A);
end
close(v);