function distanceMoved = computeDistance(blimpsLocations,currentLocation, map)

%A (for now) dummy function that uses the GPS Map and current/intended
%locations to compute how far each blimp would move for the given
%Solution.


currentX=map(1,currentLocation);
currentY=map(2,currentLocation);
newX=map(1,blimpsLocations);
newY=map(2,blimpsLocations);

distanceMoved=sqrt(((newX-currentX)^2)+((newY-currentY)^2));

end

