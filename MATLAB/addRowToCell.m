function [ a ] = addRowToCell( a,b )

    start = size(a,1);
    for i=1:size(b,2)
        a{start+1,i} = b{1,i};
    end


end

