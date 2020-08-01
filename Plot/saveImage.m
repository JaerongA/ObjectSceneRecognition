%To save a figure with a better quality
%
%    saveImage (figureHandle, fileName, imagePosition)
%
%    figureHandle : handle to the figure you want to save
%    fileName : the name of the pitcure you want to save on the disk
%    imagePosition : [x y(left down  corner)width heigth] those are the dimension of the figure
%
% Copyright (C) 2011 by Sebastien Delcasso
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

function saveImage (figureHandle, fileName, imagePosition)
set(figureHandle, 'Position', [imagePosition(1) imagePosition(2) imagePosition(3) imagePosition(4)]);
% Convert figure to image
set(figureHandle, 'Visible', 'on');
frame = getframe(figureHandle);
set(figureHandle,'Visible','off');
imagen = frame.cdata;
% Save the image to disk
imwrite(imagen, fileName);
end