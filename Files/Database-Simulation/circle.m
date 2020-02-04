function h = circle(x,y,r)
    d = 2*r;
    px = x - r;
    py = y - r;
    str = '#21A19F';
    color = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;
    h = rectangle('Position', [px, py, d, d],'Curvature',[1, 1], ...
        'LineWidth', 6, 'EdgeColor',color);
    daspect([1, 1, 1]);
end

