function mpaFeedBack(type)

switch type
    
    case 'instructive'
                sound(sin(1:100));
        
    case 'Wrong'
                sound(sin(10*(1:700)));

end